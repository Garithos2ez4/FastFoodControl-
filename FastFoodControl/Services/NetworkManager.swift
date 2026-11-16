import Foundation

enum NetworkError: LocalizedError {
    case urlInvalida
    case errorRed(Error)
    case respuestaInvalida(Int)
    case sinDatos
    case errorDecodificacion(Error)

    var errorDescription: String? {
        switch self {
        case .urlInvalida:
            return "La URL del servicio REST no es válida."
        case .errorRed(let error):
            return "Error de conexión: \(error.localizedDescription)"
        case .respuestaInvalida(let statusCode):
            return "El servidor respondió con código HTTP \(statusCode)."
        case .sinDatos:
            return "El servicio REST no devolvió datos."
        case .errorDecodificacion(let error):
            return "No se pudo interpretar la respuesta JSON: \(error.localizedDescription)"
        }
    }
}

/// Cliente REST genérico basado en URLSession nativo de iOS y Codable.
final class NetworkManager {

    static let shared = NetworkManager()
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: config)
    }

    func get<T: Decodable>(
        urlString: String,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(.urlInvalida)) }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(.errorRed(error))) }
                return
            }

            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async { completion(.failure(.respuestaInvalida(httpResponse.statusCode))) }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.sinDatos)) }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.errorDecodificacion(error))) }
            }
        }.resume()
    }
}
