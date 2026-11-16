import UIKit

final class ComandasAdminViewModel {

    func validarYRegistrarComanda(
        numeroMesa: String,
        cliente: String,
        plato: String,
        categoria: String,
        cantidad: Int,
        tiempoMin: Int,
        notas: String,
        sede: String
    ) -> Result<ComandaOrder, Error> {
        let mesaLimpia = numeroMesa.trimmed
        let clienteLimpio = cliente.trimmed
        let platoLimpio = plato.trimmed

        guard mesaLimpia.isNotEmpty else {
            return .failure(ValidacionComandaError.campoVacio("Canal o Número de Mesa"))
        }
        guard clienteLimpio.isNotEmpty else {
            return .failure(ValidacionComandaError.campoVacio("Nombre de Cliente / Referencia"))
        }
        guard platoLimpio.isNotEmpty else {
            return .failure(ValidacionComandaError.campoVacio("Plato o Combo"))
        }

        let comanda = CoreDataManager.shared.crearComanda(
            numeroMesa: mesaLimpia,
            clienteNombre: clienteLimpio,
            platoNombre: platoLimpio,
            categoria: categoria,
            cantidad: max(1, cantidad),
            tiempoPreparacionMin: max(3, tiempoMin),
            estado: .pendiente,
            notasCocina: notas.trimmed,
            sedeNombre: sede
        )
        return .success(comanda)
    }

    func cambiarEstado(comanda: ComandaOrder, a nuevoEstado: EstadoComanda, notas: String? = nil) {
        CoreDataManager.shared.actualizarEstadoComanda(id: comanda.id, nuevoEstado: nuevoEstado, notas: notas)
        if nuevoEstado == .enCocina {
            NotificationService.shared.programarAlertaTemporizadorComanda(comanda: comanda, segundosDemostracion: 5)
        }
    }

    func generarTicketQR(para comanda: ComandaOrder) -> UIImage? {
        QRTicketService.shared.generarImagenQR(desde: comanda.resumenQR)
    }
}

enum ValidacionComandaError: LocalizedError {
    case campoVacio(String)

    var errorDescription: String? {
        switch self {
        case .campoVacio(let campo):
            return "Por favor, completa el campo obligatorio: \(campo)."
        }
    }
}
