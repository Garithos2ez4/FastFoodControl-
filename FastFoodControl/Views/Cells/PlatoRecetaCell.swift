import UIKit

final class PlatoRecetaCell: UITableViewCell {

    static let reuseIdentifier = "PlatoRecetaCell"

    var onEnviarACocinaTapped: (() -> Void)?

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .ffCardBg
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dishImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.backgroundColor = .systemGray6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nombreLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .bold)
        lbl.textColor = .ffDarkText
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let metaLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .ffMutedText
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let categoriaTag: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 11, weight: .semibold)
        lbl.textColor = .ffPrimaryRed
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("  + Comanda KDS  ", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .ffPrimaryRed
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(handleSendTap), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(cardView)
        [dishImageView, categoriaTag, nombreLabel, metaLabel, sendButton].forEach {
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dishImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            dishImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            dishImageView.widthAnchor.constraint(equalToConstant: 84),
            dishImageView.heightAnchor.constraint(equalToConstant: 84),
            dishImageView.topAnchor.constraint(greaterThanOrEqualTo: cardView.topAnchor, constant: 12),
            dishImageView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -12),

            categoriaTag.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            categoriaTag.leadingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: 12),
            categoriaTag.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            nombreLabel.topAnchor.constraint(equalTo: categoriaTag.bottomAnchor, constant: 3),
            nombreLabel.leadingAnchor.constraint(equalTo: categoriaTag.leadingAnchor),
            nombreLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            metaLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 4),
            metaLabel.leadingAnchor.constraint(equalTo: categoriaTag.leadingAnchor),
            metaLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            sendButton.topAnchor.constraint(equalTo: metaLabel.bottomAnchor, constant: 8),
            sendButton.leadingAnchor.constraint(equalTo: categoriaTag.leadingAnchor),
            sendButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 126),
            sendButton.heightAnchor.constraint(equalToConstant: 28),
            sendButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }

    func configurar(con plato: PlatoMenuDTO) {
        categoriaTag.text = "\(plato.categoriaCocina.uppercased()) • ★ \(String(format: "%.1f", plato.rating))"
        nombreLabel.text = plato.name
        metaLabel.text = "⏱ \(plato.tiempoTotalMinutos) min  •  🔥 \(plato.caloriesPerServing) kcal  •  \(plato.ingredients.count) ingred."
        dishImageView.loadImage(from: plato.image)
    }

    @objc private func handleSendTap() {
        onEnviarACocinaTapped?()
    }
}
