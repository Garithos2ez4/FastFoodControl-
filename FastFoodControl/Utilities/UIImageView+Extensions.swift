import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    private let lock = NSLock()
    private var activeURLs: [ObjectIdentifier: String] = [:]

    private init() {
        cache.countLimit = 100
    }

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func setActiveURL(_ url: String, for imageView: UIImageView) {
        lock.lock()
        defer { lock.unlock() }
        activeURLs[ObjectIdentifier(imageView)] = url
    }

    func activeURL(for imageView: UIImageView) -> String? {
        lock.lock()
        defer { lock.unlock() }
        return activeURLs[ObjectIdentifier(imageView)]
    }
}

extension UIImageView {

    /// Carga una imagen de forma asíncrona con caché en memoria usando URLSession.
    func loadImage(from urlString: String?, placeholderSystemName: String = "fork.knife.circle.fill") {
        let placeholder = UIImage(systemName: placeholderSystemName)
        self.image = placeholder
        self.tintColor = .ffPrimaryRed

        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return
        }

        if let cached = ImageCacheManager.shared.image(forKey: urlString) {
            self.image = cached
            return
        }

        ImageCacheManager.shared.setActiveURL(urlString, for: self)

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data,
                  let downloadedImage = UIImage(data: data) else {
                return
            }

            ImageCacheManager.shared.setImage(downloadedImage, forKey: urlString)

            DispatchQueue.main.async {
                if ImageCacheManager.shared.activeURL(for: self) == urlString {
                    self.image = downloadedImage
                    self.contentMode = .scaleAspectFill
                }
            }
        }.resume()
    }
}
