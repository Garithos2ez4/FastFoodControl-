import Foundation
import UserNotifications

/// Herramienta Nativa iOS #1: UserNotifications (UNUserNotificationCenter).
/// Programa alertas de temporizador de cocina y avisos de stock crítico de insumos.
final class NotificationService: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        center.delegate = self
    }

    func solicitarPermisos() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("⚠️ Error solicitando permisos de notificación: \(error.localizedDescription)")
            } else {
                print("🔔 Permisos UserNotifications: \(granted ? "Concedidos" : "Denegados")")
            }
        }
    }

    /// Programa una alerta local cuando vence el tiempo estimado de preparación de una comanda.
    /// Para demostración rápida en sustentación, permite indicar segundos de prueba.
    func programarAlertaTemporizadorComanda(
        comanda: ComandaOrder,
        segundosDemostracion: TimeInterval = 5
    ) {
        let content = UNMutableNotificationContent()
        content.title = "⏱️ Comanda \(comanda.codigoTicket) Lista para Revisión"
        content.body = "\(comanda.platoNombre) (\(comanda.numeroMesa)) cumplió su tiempo estimado de \(comanda.tiempoPreparacionMin) min."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(2, segundosDemostracion),
            repeats: false
        )
        let identifier = "\(Constants.Notifications.kitchenTimerPrefix)\(comanda.id)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("⚠️ No se pudo programar notificación KDS: \(error.localizedDescription)")
            }
        }
    }

    /// Envía una notificación inmediata cuando un insumo en Core Data cae en estado crítico.
    func enviarAlertaStockCritico(insumo: InsumoStock) {
        let content = UNMutableNotificationContent()
        content.title = "⚠️ Alerta de Stock Crítico"
        content.body = "\(insumo.nombre) bajó a \(insumo.cantidadActual.formatoCantidadStock) \(insumo.unidadMedida) (Mínimo: \(insumo.cantidadMinima.formatoCantidadStock))."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.5, repeats: false)
        let identifier = "\(Constants.Notifications.lowStockPrefix)\(insumo.id)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request)
    }

    // Mostrar notificación en primer plano incluso con la app abierta (ideal para la demo en clase)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .list])
    }
}
