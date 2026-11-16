import Foundation

final class InsumosStockViewModel {

    private(set) var insumos: [InsumoStock] = []
    var soloCriticos: Bool = false

    var onDataUpdated: (() -> Void)?
    var onAlertaStockCritico: ((InsumoStock) -> Void)?

    var cantidadCriticos: Int {
        CoreDataManager.shared.obtenerInsumos(soloCriticos: true).count
    }

    func cargarInsumos() {
        insumos = CoreDataManager.shared.obtenerInsumos(soloCriticos: soloCriticos)
        onDataUpdated?()
    }

    func registrarNuevoInsumo(
        nombre: String,
        categoria: String,
        actual: Double,
        minimo: Double,
        unidad: String
    ) -> Bool {
        guard nombre.trimmed.isNotEmpty else { return false }
        let nuevo = CoreDataManager.shared.crearInsumo(
            nombre: nombre.trimmed,
            categoria: categoria.trimmed.isEmpty ? "General" : categoria.trimmed,
            cantidadActual: max(0, actual),
            cantidadMinima: max(1, minimo),
            unidadMedida: unidad.trimmed.isEmpty ? "und" : unidad.trimmed
        )
        if nuevo.esStockCritico {
            NotificationService.shared.enviarAlertaStockCritico(insumo: nuevo)
            onAlertaStockCritico?(nuevo)
        }
        cargarInsumos()
        return true
    }

    func reponerStock(insumo: InsumoStock, cantidad: Double) {
        guard cantidad > 0 else { return }
        _ = CoreDataManager.shared.registrarMovimientoInsumo(
            id: insumo.id,
            deltaStock: cantidad,
            nuevaMerma: 0
        )
        cargarInsumos()
    }

    func registrarMerma(insumo: InsumoStock, cantidad: Double) {
        guard cantidad > 0 else { return }
        if let actualizado = CoreDataManager.shared.registrarMovimientoInsumo(
            id: insumo.id,
            deltaStock: -cantidad,
            nuevaMerma: cantidad
        ), actualizado.esStockCritico {
            NotificationService.shared.enviarAlertaStockCritico(insumo: actualizado)
            onAlertaStockCritico?(actualizado)
        }
        cargarInsumos()
    }

    func eliminarInsumo(at index: Int) {
        guard index < insumos.count else { return }
        CoreDataManager.shared.eliminarInsumo(id: insumos[index].id)
        cargarInsumos()
    }
}
