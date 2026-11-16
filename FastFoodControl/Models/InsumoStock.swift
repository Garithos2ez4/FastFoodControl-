import UIKit

struct InsumoStock: Identifiable {
    let id: String
    var nombre: String
    var categoria: String
    var cantidadActual: Double
    var cantidadMinima: Double
    var unidadMedida: String
    var mermaRegistrada: Double
    var ultimaActualizacion: Date

    /// Indica si el inventario actual igualó o cayó por debajo del umbral mínimo.
    var esStockCritico: Bool {
        cantidadActual <= cantidadMinima
    }

    /// Nivel porcentual respecto a una capacidad óptima estimada (3x el mínimo).
    var porcentajeNivel: Float {
        let referenciaMaxima = max(cantidadMinima * 3.0, 1.0)
        let ratio = Float(cantidadActual / referenciaMaxima)
        return min(max(ratio, 0.0), 1.0)
    }

    var colorEstado: UIColor {
        if cantidadActual <= cantidadMinima {
            return .ffPrimaryRed
        } else if cantidadActual <= cantidadMinima * 1.5 {
            return .ffSecondaryAmber
        }
        return .ffKitchenGreen
    }

    var textoEstado: String {
        if cantidadActual <= cantidadMinima {
            return "STOCK CRÍTICO"
        } else if cantidadActual <= cantidadMinima * 1.5 {
            return "POR REPONER"
        }
        return "ÓPTIMO"
    }
}
