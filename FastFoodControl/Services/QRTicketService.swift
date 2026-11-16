import UIKit
import CoreImage

/// Herramienta Nativa iOS #3: CoreImage (CIQRCodeGenerator).
/// Genera códigos QR nítidos para tickets de despacho en barra y control de comandas.
final class QRTicketService {

    static let shared = QRTicketService()
    private let context = CIContext()

    private init() {}

    func generarImagenQR(desde texto: String, escala: CGFloat = 10.0) -> UIImage? {
        guard let data = texto.data(using: .utf8),
              let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }

        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else {
            return nil
        }

        let transform = CGAffineTransform(scaleX: escala, y: escala)
        let scaledImage = outputImage.transformed(by: transform)

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
