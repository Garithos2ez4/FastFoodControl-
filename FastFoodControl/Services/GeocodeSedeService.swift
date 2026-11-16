import Foundation
import CoreLocation
import MapKit

/// Herramienta Nativa iOS #2: CoreLocation + MapKit.
/// Gestiona permisos de ubicación, cálculo de distancias a sedes y anotaciones geográficas.
final class GeocodeSedeService: NSObject, CLLocationManagerDelegate {

    static let shared = GeocodeSedeService()

    private let locationManager = CLLocationManager()
    private(set) var ultimaUbicacionUsuario: CLLocation?
    var onUbicacionActualizada: ((CLLocation) -> Void)?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func solicitarUbicacion() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func distanciaTexto(hacia sede: SedeSucursal) -> String {
        let origen = ultimaUbicacionUsuario ?? CLLocation(latitude: -12.1190, longitude: -77.0300)
        let metros = origen.distance(from: sede.ubicacion)
        return (metros / 1000.0).formatoKilometros
    }

    func sedeMasCercana(entre sedes: [SedeSucursal]) -> SedeSucursal? {
        let origen = ultimaUbicacionUsuario ?? CLLocation(latitude: -12.1190, longitude: -77.0300)
        return sedes.min {
            origen.distance(from: $0.ubicacion) < origen.distance(from: $1.ubicacion)
        }
    }

    func crearAnotaciones(para sedes: [SedeSucursal]) -> [SedeAnnotation] {
        sedes.map { SedeAnnotation(sede: $0) }
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        ultimaUbicacionUsuario = location
        onUbicacionActualizada?(location)
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("📍 GeocodeSedeService fallback (Miraflores): \(error.localizedDescription)")
    }
}

/// Anotación personalizada para MapKit con referencia a la sede operativa.
final class SedeAnnotation: NSObject, MKAnnotation {
    let sede: SedeSucursal
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(sede: SedeSucursal) {
        self.sede = sede
        self.coordinate = sede.coordenada
        self.title = sede.nombre
        self.subtitle = "\(sede.distrito) • \(sede.comandasActivas) comandas activas"
        super.init()
    }
}
