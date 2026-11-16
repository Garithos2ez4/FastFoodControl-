import UIKit

final class CategoryPillCell: UICollectionViewCell {

    static let reuseIdentifier = "CategoryPillCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurar(titulo: String, seleccionada: Bool) {
        titleLabel.text = titulo
        if seleccionada {
            contentView.backgroundColor = .ffPrimaryRed
            contentView.layer.borderColor = UIColor.ffPrimaryRed.cgColor
            titleLabel.textColor = .white
        } else {
            contentView.backgroundColor = .ffCardBg
            contentView.layer.borderColor = UIColor.systemGray4.cgColor
            titleLabel.textColor = .ffDarkText
        }
    }
}
