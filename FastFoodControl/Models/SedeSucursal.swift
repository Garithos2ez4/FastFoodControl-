import Foundation
import CoreLocation

struct SedeSucursal: Identifiable {
    let id: String
    let nombre: String
    let direccion: String
    let distrito: String
    let latitud: Double
    let longitud: Double
    let jefeTurno: String
    let comandasActivas: Int
    let horario: String
    let telefono: String

    var coordenada: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
    }

    var ubicacion: CLLocation {
        CLLocation(latitude: latitud, longitude: longitud)
    }
}
