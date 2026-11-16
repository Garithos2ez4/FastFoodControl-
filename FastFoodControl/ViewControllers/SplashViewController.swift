import UIKit

final class SplashViewController: UIViewController {

    private let iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "flame.circle.fill"))
        iv.tintColor = .ffSecondaryAmber
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "FastFoodControl"
        lbl.font = .systemFont(ofSize: 32, weight: .heavy)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sistema KDS de Comandas & Control de Insumos"
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = UIColor.white.withAlphaComponent(0.9)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let loader = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animarYContinuar()
    }

    private func setupUI() {
        view.backgroundColor = .ffPrimaryRed
        loader.color = .white
        loader.startAnimating()
        loader.translatesAutoresizingMaskIntoConstraints = false

        [iconView, titleLabel, subtitleLabel, loader].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            iconView.widthAnchor.constraint(equalToConstant: 96),
            iconView.heightAnchor.constraint(equalToConstant: 96),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            loader.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func animarYContinuar() {
        iconView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5) {
            self.iconView.transform = .identity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            let loginVC = LoginViewController()
            if let scene = SceneDelegate.current {
                scene.cambiarARootViewController(loginVC, animado: true)
            } else {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
        }
    }
}
