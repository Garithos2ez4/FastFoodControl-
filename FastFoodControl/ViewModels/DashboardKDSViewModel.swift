import Foundation

final class DashboardKDSViewModel {

    private(set) var comandas: [ComandaOrder] = []
    private(set) var todasLasComandas: [ComandaOrder] = []

    var filtroEstadoActual: EstadoComanda? = nil
    var textoBusqueda: String = ""

    var onDataUpdated: (() -> Void)?
    var onComandaAvanzada: ((ComandaOrder) -> Void)?

    // MARK: - Métricas KPI para el Tablero de Cocina
    var totalPendientes: Int {
        todasLasComandas.filter { $0.estado == .pendiente }.count
    }

    var totalEnCocina: Int {
        todasLasComandas.filter { $0.estado == .enCocina }.count
    }

    var totalListas: Int {
        todasLasComandas.filter { $0.estado == .listo }.count
    }

    func cargarComandas() {
        todasLasComandas = CoreDataManager.shared.obtenerComandas()
        comandas = CoreDataManager.shared.obtenerComandas(
            filtroEstado: filtroEstadoActual,
            busqueda: textoBusqueda
        )
        onDataUpdated?()
    }

    func avanzarEstado(comanda: ComandaOrder) {
        guard let siguiente = comanda.estado.siguienteEstado else { return }
        CoreDataManager.shared.actualizarEstadoComanda(id: comanda.id, nuevoEstado: siguiente)

        if siguiente == .enCocina {
            NotificationService.shared.programarAlertaTemporizadorComanda(
                comanda: comanda,
                segundosDemostracion: 5
            )
        }

        cargarComandas()
        if let actualizada = todasLasComandas.first(where: { $0.id == comanda.id }) {
            onComandaAvanzada?(actualizada)
        }
    }

    func eliminarComanda(at index: Int) {
        guard index < comandas.count else { return }
        let target = comandas[index]
        CoreDataManager.shared.eliminarComanda(id: target.id)
        cargarComandas()
    }
}
