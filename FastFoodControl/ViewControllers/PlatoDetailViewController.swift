import UIKit

final class PlatoDetailViewController: UIViewController {

    private let plato: PlatoMenuDTO

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    init(plato: PlatoMenuDTO) {
        self.plato = plato
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ficha Técnica de Receta"
        view.backgroundColor = .ffSurfaceBg
        setupUI()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .systemGray6
        imageView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        imageView.loadImage(from: plato.image)

        let titleLabel = UILabel()
        titleLabel.text = plato.name
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .ffDarkText
        titleLabel.numberOfLines = 0

        let metricsLabel = UILabel()
        metricsLabel.text = "⏱ Prep: \(plato.tiempoTotalMinutos) min   •   🔥 \(plato.caloriesPerServing) kcal   •   ★ \(String(format: "%.1f", plato.rating))   •   Dificultad: \(plato.difficulty)"
        metricsLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        metricsLabel.textColor = .ffPrimaryRed
        metricsLabel.numberOfLines = 0

        let ingredientesCard = crearTarjetaTexto(
            titulo: "Ingredientes Estandarizados (\(plato.ingredients.count))",
            cuerpo: plato.ingredients.map { "• \($0)" }.joined(separator: "\n")
        )

        let pasosCard = crearTarjetaTexto(
            titulo: "Procedimiento en Estación de Cocina",
            cuerpo: plato.instructions.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n\n")
        )

        let btnEnviar = UIButton(type: .system)
        btnEnviar.setTitle("Generar Comanda en Cocina (Core Data)", for: .normal)
        btnEnviar.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btnEnviar.setTitleColor(.white, for: .normal)
        btnEnviar.backgroundColor = .ffPrimaryRed
        btnEnviar.layer.cornerRadius = 12
        btnEnviar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnEnviar.addTarget(self, action: #selector(generarComandaTapped), for: .touchUpInside)

        [imageView, titleLabel, metricsLabel, ingredientesCard, pasosCard, btnEnviar].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func crearTarjetaTexto(titulo: String, cuerpo: String) -> UIView {
        let card = UIView()
        card.backgroundColor = .ffCardBg
        card.layer.cornerRadius = 14

        let titleLbl = UILabel()
        titleLbl.text = titulo
        titleLbl.font = .systemFont(ofSize: 15, weight: .bold)
        titleLbl.textColor = .ffDarkText
        titleLbl.translatesAutoresizingMaskIntoConstraints = false

        let bodyLbl = UILabel()
        bodyLbl.text = cuerpo
        bodyLbl.font = .systemFont(ofSize: 14)
        bodyLbl.textColor = .ffDarkText
        bodyLbl.numberOfLines = 0
        bodyLbl.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(titleLbl)
        card.addSubview(bodyLbl)

        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            titleLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            titleLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),

            bodyLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 8),
            bodyLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            bodyLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            bodyLbl.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14)
        ])

        return card
    }

    @objc private func generarComandaTapped() {
        let comanda = CoreDataManager.shared.crearComanda(
            numeroMesa: "Estación KDS",
            clienteNombre: "Preparación Estándar",
            platoNombre: plato.name,
            categoria: plato.categoriaCocina,
            cantidad: 1,
            tiempoPreparacionMin: plato.tiempoTotalMinutos,
            estado: .pendiente,
            notasCocina: "Generada desde ficha REST (\(plato.caloriesPerServing) kcal)"
        )

        let alert = UIAlertController(
            title: "Comanda #\(comanda.codigoTicket) Creada",
            message: "La orden de \(plato.name) se guardó en Core Data y ya aparece en Cocina KDS.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ver en KDS", style: .default) { [weak self] _ in
            self?.tabBarController?.selectedIndex = 0
            self?.navigationController?.popToRootViewController(animated: false)
        })
        alert.addAction(UIAlertAction(title: "Seguir aquí", style: .cancel))
        present(alert, animated: true)
    }
}
