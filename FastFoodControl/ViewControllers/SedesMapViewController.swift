import UIKit
import MapKit

/// Herramienta Nativa iOS #2: MapKit + CoreLocation.
/// Muestra las sedes operativas de la cadena, carga de comandas por sede y distancia en tiempo real.
final class SedesMapViewController: UIViewController {

    private let sedes = MockData.sedesLima
    private let mapView = MKMapView()

    private let infoCard: UIView = {
        let view = UIView()
        view.backgroundColor = .ffCardBg
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.14
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let sedeTitleLabel = UILabel()
    private let sedeDetailLabel = UILabel()
    private let distanciaBadge = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sedes Operativas (MapKit)"
        view.backgroundColor = .ffSurfaceBg
        configurarNavBar()
        setupMap()
        setupInfoCard()
        cargarAnotaciones()

        GeocodeSedeService.shared.solicitarUbicacion()
        GeocodeSedeService.shared.onUbicacionActualizada = { [weak self] _ in
            self?.centrarEnSedeMasCercana()
        }
    }

    private func configurarNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "location.fill"),
            style: .plain,
            target: self,
            action: #selector(centrarEnSedeMasCercana)
        )
    }

    private func setupMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupInfoCard() {
        sedeTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        sedeTitleLabel.textColor = .ffDarkText
        sedeTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        sedeDetailLabel.font = .systemFont(ofSize: 13)
        sedeDetailLabel.textColor = .ffMutedText
        sedeDetailLabel.numberOfLines = 3
        sedeDetailLabel.translatesAutoresizingMaskIntoConstraints = false

        distanciaBadge.font = .systemFont(ofSize: 12, weight: .bold)
        distanciaBadge.textColor = .white
        distanciaBadge.backgroundColor = .ffPrimaryRed
        distanciaBadge.textAlignment = .center
        distanciaBadge.layer.cornerRadius = 8
        distanciaBadge.clipsToBounds = true
        distanciaBadge.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(infoCard)
        [sedeTitleLabel, distanciaBadge, sedeDetailLabel].forEach { infoCard.addSubview($0) }

        NSLayoutConstraint.activate([
            infoCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            sedeTitleLabel.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 14),
            sedeTitleLabel.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 14),
            sedeTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: distanciaBadge.leadingAnchor, constant: -8),

            distanciaBadge.centerYAnchor.constraint(equalTo: sedeTitleLabel.centerYAnchor),
            distanciaBadge.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -14),
            distanciaBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 72),
            distanciaBadge.heightAnchor.constraint(equalToConstant: 24),

            sedeDetailLabel.topAnchor.constraint(equalTo: sedeTitleLabel.bottomAnchor, constant: 6),
            sedeDetailLabel.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 14),
            sedeDetailLabel.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -14),
            sedeDetailLabel.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -14)
        ])
    }

    private func cargarAnotaciones() {
        let anotaciones = GeocodeSedeService.shared.crearAnotaciones(para: sedes)
        mapView.addAnnotations(anotaciones)

        if let primera = sedes.first {
            mostrarDetalle(sede: primera)
            enfocarSede(primera, spanDelta: 0.08)
        }
    }

    private func mostrarDetalle(sede: SedeSucursal) {
        sedeTitleLabel.text = sede.nombre
        distanciaBadge.text = "  \(GeocodeSedeService.shared.distanciaTexto(hacia: sede))  "
        sedeDetailLabel.text = """
        📍 \(sede.direccion) (\(sede.distrito))
        👨‍🍳 Jefe de Turno: \(sede.jefeTurno) • 🔥 \(sede.comandasActivas) comandas en cocina
        🕒 Horario: \(sede.horario) • Tel: \(sede.telefono)
        """
    }

    private func enfocarSede(_ sede: SedeSucursal, spanDelta: CLLocationDegrees = 0.025) {
        let region = MKCoordinateRegion(
            center: sede.coordenada,
            span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta)
        )
        mapView.setRegion(region, animated: true)
    }

    @objc private func centrarEnSedeMasCercana() {
        guard let cercana = GeocodeSedeService.shared.sedeMasCercana(entre: sedes) else { return }
        mostrarDetalle(sede: cercana)
        enfocarSede(cercana)
    }
}

// MARK: - MKMapViewDelegate
extension SedesMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let sedeAnnotation = annotation as? SedeAnnotation else { return nil }
        let identifier = "SedeMarker"
        let view = (mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView)
            ?? MKMarkerAnnotationView(annotation: sedeAnnotation, reuseIdentifier: identifier)

        view.annotation = sedeAnnotation
        view.markerTintColor = .ffPrimaryRed
        view.glyphImage = UIImage(systemName: "flame.fill")
        view.canShowCallout = true
        return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let sedeAnnotation = view.annotation as? SedeAnnotation else { return }
        mostrarDetalle(sede: sedeAnnotation.sede)
        enfocarSede(sedeAnnotation.sede, spanDelta: 0.03)
    }
}
