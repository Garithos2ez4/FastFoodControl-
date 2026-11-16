import UIKit

final class DashboardKDSViewController: UIViewController {

    private let viewModel = DashboardKDSViewModel()

    private let kpiStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let kpiPendienteValue = UILabel()
    private let kpiCocinaValue = UILabel()
    private let kpiListoValue = UILabel()

    private lazy var statusSegmented: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Todas", "Pendiente", "En Cocina", "Listo"])
        seg.selectedSegmentIndex = 0
        seg.selectedSegmentTintColor = .ffPrimaryRed
        seg.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        seg.addTarget(self, action: #selector(filtroCambiado), for: .valueChanged)
        seg.translatesAutoresizingMaskIntoConstraints = false
        return seg
    }()

    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Buscar por ticket, cliente o plato..."
        sb.searchBarStyle = .minimal
        sb.delegate = self
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.register(ComandaKitchenCell.self, forCellReuseIdentifier: ComandaKitchenCell.reuseIdentifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tablero Cocina (KDS)"
        view.backgroundColor = .ffSurfaceBg
        configurarNavBar()
        setupUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.cargarComandas()
    }

    private func configurarNavBar() {
        let btnAgregar = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(nuevaComandaTapped)
        )
        navigationItem.rightBarButtonItem = btnAgregar
    }

    private func setupUI() {
        let cardPend = crearKPICard(titulo: "Pendientes", valueLabel: kpiPendienteValue, color: .ffPendingOrange)
        let cardCoc = crearKPICard(titulo: "En Cocina", valueLabel: kpiCocinaValue, color: .ffCookingBlue)
        let cardListo = crearKPICard(titulo: "Listas", valueLabel: kpiListoValue, color: .ffReadyGreen)

        [cardPend, cardCoc, cardListo].forEach { kpiStackView.addArrangedSubview($0) }

        [kpiStackView, statusSegmented, searchBar, tableView].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            kpiStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            kpiStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            kpiStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            kpiStackView.heightAnchor.constraint(equalToConstant: 68),

            statusSegmented.topAnchor.constraint(equalTo: kpiStackView.bottomAnchor, constant: 12),
            statusSegmented.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusSegmented.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            searchBar.topAnchor.constraint(equalTo: statusSegmented.bottomAnchor, constant: 6),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func crearKPICard(titulo: String, valueLabel: UILabel, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = .ffCardBg
        card.layer.cornerRadius = 12
        card.layer.borderWidth = 1
        card.layer.borderColor = color.withAlphaComponent(0.25).cgColor

        valueLabel.text = "0"
        valueLabel.font = .systemFont(ofSize: 22, weight: .heavy)
        valueLabel.textColor = color
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLbl = UILabel()
        titleLbl.text = titulo
        titleLbl.font = .systemFont(ofSize: 11, weight: .semibold)
        titleLbl.textColor = .ffMutedText
        titleLbl.textAlignment = .center
        titleLbl.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(valueLabel)
        card.addSubview(titleLbl)

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -4),

            titleLbl.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            titleLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 4),
            titleLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -4)
        ])
        return card
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            self.kpiPendienteValue.text = "\(self.viewModel.totalPendientes)"
            self.kpiCocinaValue.text = "\(self.viewModel.totalEnCocina)"
            self.kpiListoValue.text = "\(self.viewModel.totalListas)"
            self.tableView.reloadData()
        }

        viewModel.onComandaAvanzada = { [weak self] comanda in
            guard comanda.estado == .enCocina else { return }
            let alert = UIAlertController(
                title: "Comanda en Preparación",
                message: "Se programó alerta de temporizador (UserNotifications) para #\(comanda.codigoTicket).",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }

    @objc private func filtroCambiado() {
        switch statusSegmented.selectedSegmentIndex {
        case 1: viewModel.filtroEstadoActual = .pendiente
        case 2: viewModel.filtroEstadoActual = .enCocina
        case 3: viewModel.filtroEstadoActual = .listo
        default: viewModel.filtroEstadoActual = nil
        }
        viewModel.cargarComandas()
    }

    @objc private func nuevaComandaTapped() {
        let vc = NuevaComandaViewController()
        vc.onComandaCreada = { [weak self] _ in
            self?.viewModel.cargarComandas()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension DashboardKDSViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.comandas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ComandaKitchenCell.reuseIdentifier,
            for: indexPath
        ) as? ComandaKitchenCell else {
            return UITableViewCell()
        }

        let comanda = viewModel.comandas[indexPath.row]
        cell.configurar(con: comanda)
        cell.onAvanzarEstadoTapped = { [weak self] in
            self?.viewModel.avanzarEstado(comanda: comanda)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comanda = viewModel.comandas[indexPath.row]
        let detailVC = ComandaDetailViewController(comanda: comanda)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let eliminarAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completion in
            self?.viewModel.eliminarComanda(at: indexPath.row)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [eliminarAction])
    }
}

// MARK: - UISearchBarDelegate
extension DashboardKDSViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.textoBusqueda = searchText
        viewModel.cargarComandas()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
