import UIKit

final class LoginViewController: UIViewController {

    private let headerView = AnimatedHeaderView()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .ffCardBg
        view.layer.cornerRadius = 18
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let staffNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Nombre del operador / jefe de turno"
        tf.text = "Jorge Ramírez"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let pinField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "PIN de turno (4 dígitos)"
        tf.text = "2026"
        tf.isSecureTextEntry = true
        tf.keyboardType = .numberPad
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let rolSegmented: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Jefe Turno", "Cocina KDS", "Auditor"])
        seg.selectedSegmentIndex = 0
        seg.selectedSegmentTintColor = .ffPrimaryRed
        seg.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        seg.translatesAutoresizingMaskIntoConstraints = false
        return seg
    }()

    private lazy var ingresarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Iniciar Turno Operativo", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .ffPrimaryRed
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(ingresarTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ffSurfaceBg
        setupLayout()
        headerView.configurar(
            titulo: "Acceso de Personal",
            subtitulo: "Control interno de comandas en cocina e inventario.",
            insignia: "TURNO 2026"
        )
    }

    private func setupLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        view.addSubview(cardView)

        let lblRol = UILabel()
        lblRol.text = "Estación / Rol asignado"
        lblRol.font = .systemFont(ofSize: 13, weight: .semibold)
        lblRol.textColor = .ffMutedText
        lblRol.translatesAutoresizingMaskIntoConstraints = false

        let lblNota = UILabel()
        lblNota.text = "Nota: Módulo operativo interno (sin carrito de compras). Persistencia en Core Data y recetas en servicio REST."
        lblNota.font = .systemFont(ofSize: 12)
        lblNota.textColor = .ffMutedText
        lblNota.numberOfLines = 0
        lblNota.textAlignment = .center
        lblNota.translatesAutoresizingMaskIntoConstraints = false

        [staffNameField, pinField, lblRol, rolSegmented, ingresarButton, lblNota].forEach {
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            staffNameField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            staffNameField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            staffNameField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            staffNameField.heightAnchor.constraint(equalToConstant: 44),

            pinField.topAnchor.constraint(equalTo: staffNameField.bottomAnchor, constant: 12),
            pinField.leadingAnchor.constraint(equalTo: staffNameField.leadingAnchor),
            pinField.trailingAnchor.constraint(equalTo: staffNameField.trailingAnchor),
            pinField.heightAnchor.constraint(equalToConstant: 44),

            lblRol.topAnchor.constraint(equalTo: pinField.bottomAnchor, constant: 16),
            lblRol.leadingAnchor.constraint(equalTo: staffNameField.leadingAnchor),

            rolSegmented.topAnchor.constraint(equalTo: lblRol.bottomAnchor, constant: 8),
            rolSegmented.leadingAnchor.constraint(equalTo: staffNameField.leadingAnchor),
            rolSegmented.trailingAnchor.constraint(equalTo: staffNameField.trailingAnchor),

            ingresarButton.topAnchor.constraint(equalTo: rolSegmented.bottomAnchor, constant: 22),
            ingresarButton.leadingAnchor.constraint(equalTo: staffNameField.leadingAnchor),
            ingresarButton.trailingAnchor.constraint(equalTo: staffNameField.trailingAnchor),
            ingresarButton.heightAnchor.constraint(equalToConstant: 48),

            lblNota.topAnchor.constraint(equalTo: ingresarButton.bottomAnchor, constant: 14),
            lblNota.leadingAnchor.constraint(equalTo: staffNameField.leadingAnchor),
            lblNota.trailingAnchor.constraint(equalTo: staffNameField.trailingAnchor),
            lblNota.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18)
        ])
    }

    @objc private func ingresarTapped() {
        let nombre = staffNameField.text?.trimmed ?? ""
        let pin = pinField.text?.trimmed ?? ""

        guard nombre.isNotEmpty, pin.count >= 4 else {
            let alert = UIAlertController(
                title: "Datos incompletos",
                message: "Ingresa tu nombre de operador y un PIN de al menos 4 dígitos.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(alert, animated: true)
            return
        }

        let rol = rolSegmented.titleForSegment(at: rolSegmented.selectedSegmentIndex) ?? "Jefe Turno"
        UserDefaults.standard.set(nombre, forKey: Constants.Session.currentStaffNameKey)
        UserDefaults.standard.set(rol, forKey: Constants.Session.currentStaffRoleKey)

        cambiarPantallaRaiz(a: MainTabBarController())
    }
}
