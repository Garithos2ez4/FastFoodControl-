import UIKit

final class MenuCatalogViewController: UIViewController {

    private let viewModel = MenuCatalogViewModel()

    private let headerView = AnimatedHeaderView()

    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Buscar receta o ingrediente REST..."
        sb.searchBarStyle = .minimal
        sb.delegate = self
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()

    private lazy var categoriesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(CategoryPillCell.self, forCellWithReuseIdentifier: CategoryPillCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private let refreshControl = UIRefreshControl()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.register(PlatoRecetaCell.self, forCellReuseIdentifier: PlatoRecetaCell.reuseIdentifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = .ffPrimaryRed
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recetario & Estándares (REST)"
        view.backgroundColor = .ffSurfaceBg
        setupUI()
        bindViewModel()
        viewModel.cargarCatalogoREST()
    }

    private func setupUI() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.configurar(
            titulo: "Estándares de Preparación",
            subtitulo: "Datos sincronizados en vivo desde API REST externa.",
            insignia: "API REST"
        )

        refreshControl.addTarget(self, action: #selector(recargarREST), for: .valueChanged)
        tableView.refreshControl = refreshControl

        [headerView, searchBar, categoriesCollection, tableView, activityIndicator].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 6),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            categoriesCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 2),
            categoriesCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollection.heightAnchor.constraint(equalToConstant: 42),

            tableView.topAnchor.constraint(equalTo: categoriesCollection.bottomAnchor, constant: 6),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
        }

        viewModel.onDataLoaded = { [weak self] in
            guard let self = self else { return }
            let insignia = self.viewModel.esModoOffline ? "MODO LOCAL" : "REST ONLINE"
            self.headerView.configurar(
                titulo: "Estándares de Preparación",
                subtitulo: "\(self.viewModel.platosFiltrados.count) recetas técnicas disponibles para cocina.",
                insignia: insignia
            )
            self.categoriesCollection.reloadData()
            self.tableView.reloadData()
        }

        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Error de Red", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default) { _ in
                self?.viewModel.cargarCatalogoREST()
            })
            self?.present(alert, animated: true)
        }
    }

    @objc private func recargarREST() {
        viewModel.cargarCatalogoREST()
    }

    private func enviarACocina(plato: PlatoMenuDTO) {
        let alert = UIAlertController(
            title: "Enviar a Cocina (Core Data)",
            message: "Generar comanda KDS para: \(plato.name)",
            preferredStyle: .alert
        )
        alert.addTextField { tf in
            tf.placeholder = "Canal / Mesa (ej. Barra 2)"
            tf.text = "Barra KDS"
        }
        alert.addTextField { tf in
            tf.placeholder = "Nombre de cliente / ref."
            tf.text = "Turno Actual"
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Enviar a KDS", style: .default) { [weak self] _ in
            let canal = alert.textFields?[0].text ?? "Barra KDS"
            let cliente = alert.textFields?[1].text ?? "Orden Rápida"
            let comanda = self?.viewModel.enviarPlatoACocina(
                plato: plato,
                canal: canal.isNotEmpty ? canal : "Barra KDS",
                cliente: cliente.isNotEmpty ? cliente : "Orden Rápida"
            )
            if let ticket = comanda?.codigoTicket {
                let confirm = UIAlertController(
                    title: "Comanda Generada",
                    message: "Se registró #\(ticket) en Core Data. Revísala en la pestaña Cocina KDS.",
                    preferredStyle: .alert
                )
                confirm.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(confirm, animated: true)
            }
        })
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension MenuCatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categorias.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryPillCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryPillCell else {
            return UICollectionViewCell()
        }
        let cat = viewModel.categorias[indexPath.item]
        cell.configurar(titulo: cat, seleccionada: cat == viewModel.categoriaSeleccionada)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.categoriaSeleccionada = viewModel.categorias[indexPath.item]
    }
}

// MARK: - UITableViewDataSource & Delegate
extension MenuCatalogViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.platosFiltrados.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlatoRecetaCell.reuseIdentifier,
            for: indexPath
        ) as? PlatoRecetaCell else {
            return UITableViewCell()
        }

        let plato = viewModel.platosFiltrados[indexPath.row]
        cell.configurar(con: plato)
        cell.onEnviarACocinaTapped = { [weak self] in
            self?.enviarACocina(plato: plato)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plato = viewModel.platosFiltrados[indexPath.row]
        let detailVC = PlatoDetailViewController(plato: plato)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension MenuCatalogViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.textoBusqueda = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
