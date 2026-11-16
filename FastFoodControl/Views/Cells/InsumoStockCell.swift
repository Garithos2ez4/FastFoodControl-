import UIKit

final class InsumoStockCell: UITableViewCell {

    static let reuseIdentifier = "InsumoStockCell"

    var onReponerTapped: (() -> Void)?
    var onRegistrarMermaTapped: (() -> Void)?

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .ffCardBg
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nombreLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .bold)
        lbl.textColor = .ffDarkText
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let estadoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 10, weight: .bold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 6
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let stockDetalleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .medium)
        lbl.textColor = .ffMutedText
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .default)
        bar.layer.cornerRadius = 3
        bar.clipsToBounds = true
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private lazy var btnReponer: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("  + Reponer  ", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .ffKitchenGreen
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(handleReponer), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var btnMerma: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("  - Merma  ", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        btn.setTitleColor(.ffPrimaryRed, for: .normal)
        btn.backgroundColor = UIColor.ffPrimaryRed.withAlphaComponent(0.12)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(handleMerma), for: .touchUpInside)
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
        [nombreLabel, estadoLabel, stockDetalleLabel, progressBar, btnReponer, btnMerma].forEach {
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            nombreLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            nombreLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            nombreLabel.trailingAnchor.constraint(lessThanOrEqualTo: estadoLabel.leadingAnchor, constant: -8),

            estadoLabel.centerYAnchor.constraint(equalTo: nombreLabel.centerYAnchor),
            estadoLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            estadoLabel.heightAnchor.constraint(equalToConstant: 20),

            stockDetalleLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 4),
            stockDetalleLabel.leadingAnchor.constraint(equalTo: nombreLabel.leadingAnchor),
            stockDetalleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),

            progressBar.topAnchor.constraint(equalTo: stockDetalleLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: nombreLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            progressBar.heightAnchor.constraint(equalToConstant: 6),

            btnReponer.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
            btnReponer.leadingAnchor.constraint(equalTo: nombreLabel.leadingAnchor),
            btnReponer.widthAnchor.constraint(greaterThanOrEqualToConstant: 96),
            btnReponer.heightAnchor.constraint(equalToConstant: 28),
            btnReponer.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            btnMerma.centerYAnchor.constraint(equalTo: btnReponer.centerYAnchor),
            btnMerma.leadingAnchor.constraint(equalTo: btnReponer.trailingAnchor, constant: 10),
            btnMerma.widthAnchor.constraint(greaterThanOrEqualToConstant: 86),
            btnMerma.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    func configurar(con insumo: InsumoStock) {
        nombreLabel.text = "\(insumo.nombre) (\(insumo.categoria))"
        estadoLabel.text = "  \(insumo.textoEstado)  "
        estadoLabel.backgroundColor = insumo.colorEstado

        stockDetalleLabel.text = "Stock: \(insumo.cantidadActual.formatoCantidadStock) \(insumo.unidadMedida)  |  Mín: \(insumo.cantidadMinima.formatoCantidadStock)  |  Merma: \(insumo.mermaRegistrada.formatoCantidadStock)"

        progressBar.progressTintColor = insumo.colorEstado
        progressBar.setProgress(insumo.porcentajeNivel, animated: false)
    }

    @objc private func handleReponer() {
        onReponerTapped?()
    }

    @objc private func handleMerma() {
        onRegistrarMermaTapped?()
    }
}
