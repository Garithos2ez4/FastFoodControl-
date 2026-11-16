import UIKit

enum EstadoComanda: String, CaseIterable, Codable {
    case pendiente = "Pendiente"
    case enCocina  = "En Cocina"
    case listo     = "Listo para Entrega"
    case entregado = "Entregado"

    var colorBadge: UIColor {
        switch self {
        case .pendiente: return .ffPendingOrange
        case .enCocina:  return .ffCookingBlue
        case .listo:     return .ffReadyGreen
        case .entregado: return .ffDeliveredGray
        }
    }

    var iconoSistema: String {
        switch self {
        case .pendiente: return "clock.badge.exclamationmark"
        case .enCocina:  return "flame.fill"
        case .listo:     return "checkmark.seal.fill"
        case .entregado: return "tray.and.arrow.up.fill"
        }
    }

    var siguienteEstado: EstadoComanda? {
        switch self {
        case .pendiente: return .enCocina
        case .enCocina:  return .listo
        case .listo:     return .entregado
        case .entregado: return nil
        }
    }

    var tituloAccionSiguiente: String {
        switch self {
        case .pendiente: return "Iniciar Cocina"
        case .enCocina:  return "Marcar Listo"
        case .listo:     return "Despachar"
        case .entregado: return "Completado"
        }
    }
}

struct ComandaOrder: Identifiable {
    let id: String
    let codigoTicket: String
    var numeroMesa: String
    var clienteNombre: String
    var platoNombre: String
    var categoria: String
    var cantidad: Int
    var tiempoPreparacionMin: Int
    var estado: EstadoComanda
    var notasCocina: String
    let fechaCreacion: Date
    var sedeNombre: String

    var resumenQR: String {
        """
        FASTFOODCONTROL-KDS
        TICKET:\(codigoTicket)
        CANAL:\(numeroMesa)
        CLIENTE:\(clienteNombre)
        PLATO:\(platoNombre) x\(cantidad)
        ESTADO:\(estado.rawValue)
        SEDE:\(sedeNombre)
        HORA:\(fechaCreacion.formatoHoraCorta)
        """
    }
}
