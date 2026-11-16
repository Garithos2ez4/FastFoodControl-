import UIKit

final class ComandaKitchenCell: UITableViewCell {

    static let reuseIdentifier = "ComandaKitchenCell"

    var onAvanzarEstadoTapped: (() -> Void)?

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

    private let stripeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let ticketLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .monospacedDigitSystemFont(ofSize: 13, weight: .bold)
        lbl.textColor = .ffDarkText
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let canalLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.textColor = .ffMutedText
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let platoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.textColor = .ffDarkText
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let clienteNotasLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = .ffMutedText
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let estadoBadge: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 11, weight: .bold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let tiempoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.textColor = .ffSecondaryAmber
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(handleActionTap), for: .touchUpInside)
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
        [stripeView, ticketLabel, canalLabel, estadoBadge, platoLabel, clienteNotasLabel, tiempoLabel, actionButton].forEach {
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stripeView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            stripeView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            stripeView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            stripeView.widthAnchor.constraint(equalToConstant: 5),

            ticketLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            ticketLabel.leadingAnchor.constraint(equalTo: stripeView.trailingAnchor, constant: 10),

            canalLabel.centerYAnchor.constraint(equalTo: ticketLabel.centerYAnchor),
            canalLabel.leadingAnchor.constraint(equalTo: ticketLabel.trailingAnchor, constant: 8),
            canalLabel.trailingAnchor.constraint(lessThanOrEqualTo: estadoBadge.leadingAnchor, constant: -8),

            estadoBadge.centerYAnchor.constraint(equalTo: ticketLabel.centerYAnchor),
            estadoBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            estadoBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 92),
            estadoBadge.heightAnchor.constraint(equalToConstant: 22),

            platoLabel.topAnchor.constraint(equalTo: ticketLabel.bottomAnchor, constant: 6),
            platoLabel.leadingAnchor.constraint(equalTo: ticketLabel.leadingAnchor),
            platoLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            clienteNotasLabel.topAnchor.constraint(equalTo: platoLabel.bottomAnchor, constant: 4),
            clienteNotasLabel.leadingAnchor.constraint(equalTo: ticketLabel.leadingAnchor),
            clienteNotasLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            tiempoLabel.topAnchor.constraint(equalTo: clienteNotasLabel.bottomAnchor, constant: 10),
            tiempoLabel.leadingAnchor.constraint(equalTo: ticketLabel.leadingAnchor),
            tiempoLabel.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -8),
            tiempoLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            actionButton.centerYAnchor.constraint(equalTo: tiempoLabel.centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 112),
            actionButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configurar(con comanda: ComandaOrder) {
        let colorEstado = comanda.estado.colorBadge
        stripeView.backgroundColor = colorEstado
        ticketLabel.text = "#\(comanda.codigoTicket)"
        canalLabel.text = "• \(comanda.numeroMesa) • \(comanda.fechaCreacion.formatoHoraCorta)"

        estadoBadge.text = "  \(comanda.estado.rawValue)  "
        estadoBadge.backgroundColor = colorEstado

        platoLabel.text = "\(comanda.cantidad)x \(comanda.platoNombre)"
        let notas = comanda.notasCocina.isEmpty ? "Sin observaciones" : comanda.notasCocina
        clienteNotasLabel.text = "Cliente: \(comanda.clienteNombre) | \(notas)"
        tiempoLabel.text = "⏱ \(comanda.tiempoPreparacionMin) min • \(comanda.sedeNombre)"

        if comanda.estado.siguienteEstado != nil {
            actionButton.isEnabled = true
            actionButton.backgroundColor = colorEstado
            actionButton.setTitle("  \(comanda.estado.tituloAccionSiguiente)  ", for: .normal)
        } else {
            actionButton.isEnabled = false
            actionButton.backgroundColor = .systemGray4
            actionButton.setTitle("  Entregado ✓  ", for: .normal)
        }
    }

    @objc private func handleActionTap() {
        onAvanzarEstadoTapped?()
    }
}
