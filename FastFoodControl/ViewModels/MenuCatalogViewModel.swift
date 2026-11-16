import Foundation

final class MenuCatalogViewModel {

    private var todosLosPlatos: [PlatoMenuDTO] = []
    private(set) var platosFiltrados: [PlatoMenuDTO] = []
    private(set) var categorias: [String] = ["Todos"]
    private(set) var esModoOffline: Bool = false

    var categoriaSeleccionada: String = "Todos" {
        didSet { aplicarFiltros() }
    }

    var textoBusqueda: String = "" {
        didSet { aplicarFiltros() }
    }

    var onLoadingStateChanged: ((Bool) -> Void)?
    var onDataLoaded: (() -> Void)?
    var onError: ((String) -> Void)?

    func cargarCatalogoREST() {
        onLoadingStateChanged?(true)
        APIMenuService.shared.obtenerCatalogoCocina { [weak self] result, offline in
            guard let self = self else { return }
            self.onLoadingStateChanged?(false)
            self.esModoOffline = offline

            switch result {
            case .success(let platos):
                self.todosLosPlatos = platos
                let categoriasUnicas = Array(Set(platos.map { $0.categoriaCocina })).sorted()
                self.categorias = ["Todos"] + categoriasUnicas
                self.aplicarFiltros()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    private func aplicarFiltros() {
        var resultado = todosLosPlatos

        if categoriaSeleccionada != "Todos" {
            resultado = resultado.filter { $0.categoriaCocina == categoriaSeleccionada }
        }

        let query = textoBusqueda.trimmed.lowercased()
        if !query.isEmpty {
            resultado = resultado.filter {
                $0.name.lowercased().contains(query) ||
                $0.cuisine.lowercased().contains(query) ||
                $0.ingredients.joined(separator: " ").lowercased().contains(query)
            }
        }

        platosFiltrados = resultado
        onDataLoaded?()
    }

    /// Convierte un plato del recetario REST en una comanda operativa guardada en Core Data.
    @discardableResult
    func enviarPlatoACocina(plato: PlatoMenuDTO, canal: String = "Barra KDS", cliente: String = "Orden Rápida") -> ComandaOrder {
        CoreDataManager.shared.crearComanda(
            numeroMesa: canal,
            clienteNombre: cliente,
            platoNombre: plato.name,
            categoria: plato.categoriaCocina,
            cantidad: 1,
            tiempoPreparacionMin: plato.tiempoTotalMinutos,
            estado: .pendiente,
            notasCocina: "Receta estándar REST (\(plato.caloriesPerServing) kcal)"
        )
    }
}
