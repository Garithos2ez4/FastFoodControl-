import UIKit

final class NuevaComandaViewController: UIViewController {

    private let adminViewModel = ComandasAdminViewModel()
    var onComandaCreada: ((ComandaOrder) -> Void)?

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private let mesaField = UITextField()
    private let clienteField = UITextField()
    private let platoField = UITextField()
    private let notasField = UITextField()

    private let categoriaSegmented = UISegmentedControl(items: ["Burgers", "Pollo Crispy", "Pizzas", "Wraps"])
    private let sedeSegmented = UISegmentedControl(items: ["Sede Miraflores", "Sede San Isidro", "Sede Surco"])

    private let cantidadLabel = UILabel()
    private let cantidadStepper = UIStepper()

    private let tiempoLabel = UILabel()
    private let tiempoStepper = UIStepper()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nueva Comanda KDS"
        view.backgroundColor = .ffSurfaceBg
        configurarNavBar()
        setupFormulario()
    }

    private func configurarNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancelar",
            style: .plain,
            target: self,
            action: #selector(cerrarTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Guardar",
            style: .done,
            target: self,
            action: #selector(guardarTapped)
        )
    }

    private func setupFormulario() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 14
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

        configurarCampo(mesaField, placeholder: "Ej. Mesa 06, Drive-Thru 1 o Retiro Barra", textoInicial: "Mesa 06")
        configurarCampo(clienteField, placeholder: "Nombre del cliente o referencia", textoInicial: "")
        configurarCampo(platoField, placeholder: "Nombre del plato o combo", textoInicial: "Combo Double Bacon")
        configurarCampo(notasField, placeholder: "Observaciones de cocina (ej. Sin pepinillos)", textoInicial: "")

        categoriaSegmented.selectedSegmentIndex = 0
        categoriaSegmented.selectedSegmentTintColor = .ffPrimaryRed
        categoriaSegmented.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

        sedeSegmented.selectedSegmentIndex = 0
        sedeSegmented.selectedSegmentTintColor = .ffPrimaryRed
        sedeSegmented.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

        cantidadStepper.minimumValue = 1
        cantidadStepper.maximumValue = 20
        cantidadStepper.value = 1
        cantidadStepper.addTarget(self, action: #selector(stepperCambiado), for: .valueChanged)

        tiempoStepper.minimumValue = 5
        tiempoStepper.maximumValue = 45
        tiempoStepper.stepValue = 5
        tiempoStepper.value = 10
        tiempoStepper.addTarget(self, action: #selector(stepperCambiado), for: .valueChanged)

        actualizarLabelsSteppers()

        agregarSeccion(titulo: "Canal / Mesa", vista: mesaField)
        agregarSeccion(titulo: "Cliente / Referencia", vista: clienteField)
        agregarSeccion(titulo: "Plato / Combo a Preparar", vista: platoField)
        agregarSeccion(titulo: "Estación / Categoría", vista: categoriaSegmented)
        agregarSeccion(titulo: "Sede Operativa", vista: sedeSegmented)
        agregarSeccion(titulo: "Cantidad", vista: crearFilaStepper(label: cantidadLabel, stepper: cantidadStepper))
        agregarSeccion(titulo: "Tiempo Estimado de Cocina", vista: crearFilaStepper(label: tiempoLabel, stepper: tiempoStepper))
        agregarSeccion(titulo: "Notas de Cocina", vista: notasField)

        let btnRegistrar = UIButton(type: .system)
        btnRegistrar.setTitle("Registrar Comanda en Core Data", for: .normal)
        btnRegistrar.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btnRegistrar.setTitleColor(.white, for: .normal)
        btnRegistrar.backgroundColor = .ffPrimaryRed
        btnRegistrar.layer.cornerRadius = 12
        btnRegistrar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnRegistrar.addTarget(self, action: #selector(guardarTapped), for: .touchUpInside)
        stackView.addArrangedSubview(btnRegistrar)
    }

    private func configurarCampo(_ field: UITextField, placeholder: String, textoInicial: String) {
        field.placeholder = placeholder
        field.text = textoInicial
        field.borderStyle = .roundedRect
        field.backgroundColor = .ffCardBg
        field.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    private func agregarSeccion(titulo: String, vista: UIView) {
        let label = UILabel()
        label.text = titulo
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .ffDarkText

        let container = UIStackView(arrangedSubviews: [label, vista])
        container.axis = .vertical
        container.spacing = 6
        stackView.addArrangedSubview(container)
    }

    private func crearFilaStepper(label: UILabel, stepper: UIStepper) -> UIView {
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .ffDarkText
        let row = UIStackView(arrangedSubviews: [label, stepper])
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .equalSpacing
        return row
    }

    @objc private func stepperCambiado() {
        actualizarLabelsSteppers()
    }

    private func actualizarLabelsSteppers() {
        cantidadLabel.text = "\(Int(cantidadStepper.value)) unidad(es)"
        tiempoLabel.text = "\(Int(tiempoStepper.value)) minutos"
    }

    @objc private func cerrarTapped() {
        dismiss(animated: true)
    }

    @objc private func guardarTapped() {
        let categoria = categoriaSegmented.titleForSegment(at: categoriaSegmented.selectedSegmentIndex) ?? "Burgers"
        let sede = sedeSegmented.titleForSegment(at: sedeSegmented.selectedSegmentIndex) ?? Constants.Session.defaultSede

        let resultado = adminViewModel.validarYRegistrarComanda(
            numeroMesa: mesaField.text ?? "",
            cliente: clienteField.text ?? "",
            plato: platoField.text ?? "",
            categoria: categoria,
            cantidad: Int(cantidadStepper.value),
            tiempoMin: Int(tiempoStepper.value),
            notas: notasField.text ?? "",
            sede: sede
        )

        switch resultado {
        case .success(let comanda):
            onComandaCreada?(comanda)
            dismiss(animated: true)
        case .failure(let error):
            let alert = UIAlertController(
                title: "Validación",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Corregir", style: .default))
            present(alert, animated: true)
        }
    }
}
