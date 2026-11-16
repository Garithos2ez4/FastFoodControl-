import UIKit

/// Cabecera visual reutilizable inspirada en la estética de Click & Eat,
/// adaptada para tableros operativos de cocina rápida (KDS).
final class AnimatedHeaderView: UIView {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let badgeLabel = UILabel()
    private let badgeContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .ffPrimaryRed
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        badgeContainer.backgroundColor = .ffSecondaryAmber
        badgeContainer.layer.cornerRadius = 10
        badgeContainer.translatesAutoresizingMaskIntoConstraints = false

        badgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textColor = .ffDarkText
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false

        badgeContainer.addSubview(badgeLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(badgeContainer)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: badgeContainer.leadingAnchor, constant: -8),

            badgeContainer.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            badgeContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            badgeLabel.topAnchor.constraint(equalTo: badgeContainer.topAnchor, constant: 4),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor, constant: -4),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeContainer.leadingAnchor, constant: 8),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeContainer.trailingAnchor, constant: -8),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
    }

    func configurar(titulo: String, subtitulo: String, insignia: String) {
        titleLabel.text = titulo
        subtitleLabel.text = subtitulo
        badgeLabel.text = insignia

        alpha = 0.85
        transform = CGAffineTransform(translationX: 0, y: 6)
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseOut]) {
            self.alpha = 1.0
            self.transform = .identity
        }
    }
}
