import Foundation

/// Servicio REST que consume el catálogo de recetas e instrucciones técnicas de cocina.
final class APIMenuService {

    static let shared = APIMenuService()
    private init() {}

    /// Obtiene el recetario operativo desde los servicios REST públicos (DummyJSON + TheMealDB Burgers).
    func obtenerCatalogoCocina(completion: @escaping (Result<[PlatoMenuDTO], NetworkError>, _ esModoOffline: Bool) -> Void) {
        let group = DispatchGroup()
        var platosCombinados: [PlatoMenuDTO] = []
        var ultimoError: NetworkError?

        // 1. Consulta REST principal: DummyJSON Recipes
        group.enter()
        NetworkManager.shared.get(
            urlString: Constants.APIEndpoints.recipesURL,
            responseType: DummyJSONRecipesResponse.self
        ) { result in
            switch result {
            case .success(let response):
                platosCombinados.append(contentsOf: response.recipes)
            case .failure(let error):
                ultimoError = error
            }
            group.leave()
        }

        // 2. Consulta REST complementaria: TheMealDB Burgers
        group.enter()
        NetworkManager.shared.get(
            urlString: Constants.APIEndpoints.mealDBBurgersURL,
            responseType: TheMealDBResponse.self
        ) { result in
            switch result {
            case .success(let response):
                let burgers = (response.meals ?? []).map { $0.toPlatoMenuDTO() }
                platosCombinados.insert(contentsOf: burgers, at: 0)
            case .failure(let error):
                if ultimoError == nil {
                    ultimoError = error
                }
            }
            group.leave()
        }

        group.notify(queue: .main) {
            if !platosCombinados.isEmpty {
                completion(.success(platosCombinados), false)
            } else if let error = ultimoError {
                // Fallback seguro para demostración sin conexión sin bloquear la app
                completion(.success(MockData.platosFallback), true)
                print("⚠️ APIMenuService en modo respaldo offline debido a: \(error.localizedDescription)")
            } else {
                completion(.success(MockData.platosFallback), true)
            }
        }
    }
}
