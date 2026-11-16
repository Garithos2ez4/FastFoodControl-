import UIKit

final class InsumosStockViewController: UIViewController {

    private let viewModel = InsumosStockViewModel()
    private let headerView = AnimatedHeaderView()

    private lazy var filterSegmented: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Todos los Insumos", "Solo Stock Crítico"])
        seg.selectedSegmentIndex = 0
        seg.selectedSegmentTintColor = .ffPrimaryRed
        seg.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        seg.addTarget(self, action: #selector(filtroCambiado), for: .valueChanged)
        seg.translatesAutoresizingMaskIntoConstraints = false
        return seg
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.register(InsumoStockCell.self, forCellReuseIdentifier: InsumoStockCell.reuseIdentifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Control de Insumos y Mermas"
        view.backgroundColor = .ffSurfaceBg
        configurarNavBar()
        setupUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.cargarInsumos()
    }

    private func configurarNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(nuevoInsumoTapped)
        )
    }

    private func setupUI() {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        [headerView, filterSegmented, tableView].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            filterSegmented.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            filterSegmented.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterSegmented.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: filterSegmented.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            let criticos = self.viewModel.cantidadCriticos
            self.headerView.configurar(
                titulo: "Inventario Core Data",
                subtitulo: "Control de insumos, reposiciones y mermas operativas.",
                insignia: "\(criticos) CRÍTICOS"
            )
            self.tableView.reloadData()
        }

        viewModel.onAlertaStockCritico = { [weak self] insumo in
            let alert = UIAlertController(
                title: "⚠️ Stock Crítico Detectado",
                message: "\(insumo.nombre) quedó en \(insumo.cantidadActual.formatoCantidadStock) \(insumo.unidadMedida). Se disparó alerta nativa de UserNotifications.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Entendido", style: .default))
            self?.present(alert, animated: true)
        }
    }

    @objc private func filtroCambiado() {
        viewModel.soloCriticos = (filterSegmented.selectedSegmentIndex == 1)
        viewModel.cargarInsumos()
    }

    @objc private func nuevoInsumoTapped() {
        let alert = UIAlertController(
            title: "Nuevo Insumo (Core Data)",
            message: "Registra un ingrediente o empaque para monitoreo.",
            preferredStyle: .alert
        )
        alert.addTextField { $0.placeholder = "Nombre (ej. Tocino Ahumado)" }
        alert.addTextField { $0.placeholder = "Categoría (ej. Proteínas)" }
        alert.addTextField {
            $0.placeholder = "Stock actual (ej. 12)"
            $0.keyboardType = .decimalPad
        }
        alert.addTextField {
            $0.placeholder = "Stock mínimo (ej. 5)"
            $0.keyboardType = .decimalPad
        }
        alert.addTextField { $0.placeholder = "Unidad (kg / und / lt)" }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            let nombre = alert.textFields?[0].text ?? ""
            let cat = alert.textFields?[1].text ?? "General"
            let actual = Double(alert.textFields?[2].text ?? "10") ?? 10
            let minimo = Double(alert.textFields?[3].text ?? "5") ?? 5
            let unidad = alert.textFields?[4].text ?? "und"

            let ok = self?.viewModel.registrarNuevoInsumo(
                nombre: nombre,
                categoria: cat,
                actual: actual,
                minimo: minimo,
                unidad: unidad
            ) ?? false

            if !ok {
                let err = UIAlertController(title: "Campo requerido", message: "Ingresa un nombre válido.", preferredStyle: .alert)
                err.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(err, animated: true)
            }
        })
        present(alert, animated: true)
    }

    private func mostrarModalMovimiento(para insumo: InsumoStock, esMerma: Bool) {
        let titulo = esMerma ? "Registrar Merma (-)" : "Reponer Stock (+)"
        let mensaje = "\(insumo.nombre) — Actual: \(insumo.cantidadActual.formatoCantidadStock) \(insumo.unidadMedida)"
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Cantidad en \(insumo.unidadMedida)"
            tf.keyboardType = .decimalPad
            tf.text = esMerma ? "2" : "10"
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default) { [weak self] _ in
            let cantidad = Double(alert.textFields?.first?.text ?? "0") ?? 0
            if esMerma {
                self?.viewModel.registrarMerma(insumo: insumo, cantidad: cantidad)
            } else {
                self?.viewModel.reponerStock(insumo: insumo, cantidad: cantidad)
            }
        })
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate
extension InsumosStockViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.insumos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: InsumoStockCell.reuseIdentifier,
            for: indexPath
        ) as? InsumoStockCell else {
            return UITableViewCell()
        }

        let insumo = viewModel.insumos[indexPath.row]
        cell.configurar(con: insumo)
        cell.onReponerTapped = { [weak self] in
            self?.mostrarModalMovimiento(para: insumo, esMerma: false)
        }
        cell.onRegistrarMermaTapped = { [weak self] in
            self?.mostrarModalMovimiento(para: insumo, esMerma: true)
        }
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let eliminar = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completion in
            self?.viewModel.eliminarInsumo(at: indexPath.row)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [eliminar])
    }
}
