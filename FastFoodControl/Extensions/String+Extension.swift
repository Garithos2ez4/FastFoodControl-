import Foundation

extension String {

    /// Retorna la cadena sin espacios ni saltos de línea en los extremos.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Indica si la cadena contiene al menos un carácter visible.
    var isNotEmpty: Bool {
        !trimmed.isEmpty
    }

    /// Genera un código de ticket único para cocina (ej. "KDS-4821").
    static func generarCodigoTicketKDS() -> String {
        let numero = Int.random(in: 1000...9999)
        return "KDS-\(numero)"
    }
}

extension Date {

    /// Formatea la fecha en formato corto de hora local (ej. "21:15").
    var formatoHoraCorta: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "es_PE")
        return formatter.string(from: self)
    }

    /// Formatea la fecha completa legible para reportes y detalle de comanda.
    var formatoFechaHora: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        formatter.locale = Locale(identifier: "es_PE")
        return formatter.string(from: self)
    }
}
