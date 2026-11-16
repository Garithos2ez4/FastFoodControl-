import Foundation

extension Double {

    /// Formatea minutos de preparación (ej. "15 min").
    var formatoMinutos: String {
        "\(Int(self)) min"
    }

    /// Formatea cantidades de stock o mermas con un decimal.
    var formatoCantidadStock: String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self)
        }
        return String(format: "%.1f", self)
    }

    /// Formatea calorías nutricionales por porción.
    var formatoCalorias: String {
        "\(Int(self)) kcal"
    }

    /// Formatea distancia en kilómetros para el mapa de sedes.
    var formatoKilometros: String {
        if self < 1.0 {
            return String(format: "%.0f m", self * 1000)
        }
        return String(format: "%.1f km", self)
    }
}
