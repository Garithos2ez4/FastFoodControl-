import UIKit

final class ComandaDetailViewController: UIViewController {

    private var comanda: ComandaOrder
    private let adminViewModel = ComandasAdminViewModel()

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private let badgeEstado = UILabel()
    private let detalleLabel = UILabel()
    private let qrImageView = UIImageView()
    private let actionButton = UIButton(type: .system)

    init(comanda: ComandaOrder) {
        self.comanda = comanda
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ticket #\(comanda.codigoTicket)"
        view.backgroundColor = .ffSurfaceBg
        setupUI()
        refrescarVista()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])

        // Tarjeta de resumen
        let infoCard = UIView()
        infoCard.backgroundColor = .ffCardBg
        infoCard.layer.cornerRadius = 16

        badgeEstado.font = .systemFont(ofSize: 13, weight: .bold)
        badgeEstado.textColor = .white
        badgeEstado.textAlignment = .center
        badgeEstado.layer.cornerRadius = 10
        badgeEstado.clipsToBounds = true
        badgeEstado.translatesAutoresizingMaskIntoConstraints = false

        detalleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        detalleLabel.textColor = .ffDarkText
        detalleLabel.numberOfLines = 0
        detalleLabel.translatesAutoresizingMaskIntoConstraints = false

        infoCard.addSubview(badgeEstado)
        infoCard.addSubview(detalleLabel)

        NSLayoutConstraint.activate([
            badgeEstado.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 16),
            badgeEstado.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 16),
            badgeEstado.heightAnchor.constraint(equalToConstant: 28),
            badgeEstado.widthAnchor.constraint(greaterThanOrEqualToConstant: 140),

            detalleLabel.topAnchor.constraint(equalTo: badgeEstado.bottomAnchor, constant: 14),
            detalleLabel.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 16),
            detalleLabel.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -16),
            detalleLabel.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -16)
        ])

        // Tarjeta QR de Despacho (Herramienta Nativa #3: CoreImage CIQRCodeGenerator)
        let qrCard = UIView()
        qrCard.backgroundColor = .ffCardBg
        qrCard.layer.cornerRadius = 16

        let qrTitle = UILabel()
        qrTitle.text = "Ticket QR de Despacho en Barra (CoreImage)"
        qrTitle.font = .systemFont(ofSize: 15, weight: .bold)
        qrTitle.textColor = .ffDarkText
        qrTitle.textAlignment = .center
        qrTitle.translatesAutoresizingMaskIntoConstraints = false

        qrImageView.contentMode = .scaleAspectFit
        qrImageView.translatesAutoresizingMaskIntoConstraints = false

        let qrHint = UILabel()
        qrHint.text = "Escanear en estación de empaque/entrega para validar estado de comanda."
        qrHint.font = .systemFont(ofSize: 12)
        qrHint.textColor = .ffMutedText
        qrHint.textAlignment = .center
        qrHint.numberOfLines = 0
        qrHint.translatesAutoresizingMaskIntoConstraints = false

        qrCard.addSubview(qrTitle)
        qrCard.addSubview(qrImageView)
        qrCard.addSubview(qrHint)

        NSLayoutConstraint.activate([
            qrTitle.topAnchor.constraint(equalTo: qrCard.topAnchor, constant: 16),
            qrTitle.leadingAnchor.constraint(equalTo: qrCard.leadingAnchor, constant: 16),
            qrTitle.trailingAnchor.constraint(equalTo: qrCard.trailingAnchor, constant: -16),

            qrImageView.topAnchor.constraint(equalTo: qrTitle.bottomAnchor, constant: 12),
            qrImageView.centerXAnchor.constraint(equalTo: qrCard.centerXAnchor),
            qrImageView.widthAnchor.constraint(equalToConstant: 190),
            qrImageView.heightAnchor.constraint(equalToConstant: 190),

            qrHint.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 10),
            qrHint.leadingAnchor.constraint(equalTo: qrCard.leadingAnchor, constant: 16),
            qrHint.trailingAnchor.constraint(equalTo: qrCard.trailingAnchor, constant: -16),
            qrHint.bottomAnchor.constraint(equalTo: qrCard.bottomAnchor, constant: -16)
        ])

        actionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 12
        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        actionButton.addTarget(self, action: #selector(avanzarEstadoTapped), for: .touchUpInside)

        let timerBtn = UIButton(type: .system)
        timerBtn.setTitle("Probar Alerta de Temporizador (5 seg)", for: .normal)
        timerBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        timerBtn.setTitleColor(.ffPrimaryRed, for: .normal)
        timerBtn.backgroundColor = UIColor.ffPrimaryRed.withAlphaComponent(0.1)
        timerBtn.layer.cornerRadius = 12
        timerBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        timerBtn.addTarget(self, action: #selector(probarNotificacionTapped), for: .touchUpInside)

        stackView.addArrangedSubview(infoCard)
        stackView.addArrangedSubview(qrCard)
        stackView.addArrangedSubview(actionButton)
        stackView.addArrangedSubview(timerBtn)
    }

    private func refrescarVista() {
        badgeEstado.text = "  \(comanda.estado.rawValue.uppercased())  "
        badgeEstado.backgroundColor = comanda.estado.colorBadge

        let notas = comanda.notasCocina.isEmpty ? "Ninguna" : comanda.notasCocina
        detalleLabel.text = """
        Plato: \(comanda.platoNombre) (x\(comanda.cantidad))
        Categoría: \(comanda.categoria)
        Canal / Mesa: \(comanda.numeroMesa)
        Cliente / Ref.: \(comanda.clienteNombre)
        Sede: \(comanda.sedeNombre)
        Tiempo estimado: \(comanda.tiempoPreparacionMin) min
        Registrado: \(comanda.fechaCreacion.formatoFechaHora)
        Notas de cocina: \(notas)
        """

        qrImageView.image = adminViewModel.generarTicketQR(para: comanda)

        if comanda.estado.siguienteEstado != nil {
            actionButton.isEnabled = true
            actionButton.backgroundColor = comanda.estado.colorBadge
            actionButton.setTitle(comanda.estado.tituloAccionSiguiente, for: .normal)
        } else {
            actionButton.isEnabled = false
            actionButton.backgroundColor = .systemGray3
            actionButton.setTitle("Comanda Despachada ✓", for: .normal)
        }
    }

    @objc private func avanzarEstadoTapped() {
        guard let siguiente = comanda.estado.siguienteEstado else { return }
        adminViewModel.cambiarEstado(comanda: comanda, a: siguiente)
        comanda.estado = siguiente
        refrescarVista()
    }

    @objc private func probarNotificacionTapped() {
        NotificationService.shared.programarAlertaTemporizadorComanda(
            comanda: comanda,
            segundosDemostracion: 5
        )
        let alert = UIAlertController(
            title: "Notificación Programada",
            message: "En 5 segundos recibirás una alerta nativa de UserNotifications para #\(comanda.codigoTicket).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}
