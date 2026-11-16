import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarTabs()
    }

    private func configurarTabs() {
        let kdsVC = UINavigationController(rootViewController: DashboardKDSViewController())
        kdsVC.tabBarItem = UITabBarItem(
            title: "Cocina KDS",
            image: UIImage(systemName: "flame"),
            selectedImage: UIImage(systemName: "flame.fill")
        )

        let catalogoVC = UINavigationController(rootViewController: MenuCatalogViewController())
        catalogoVC.tabBarItem = UITabBarItem(
            title: "Recetario REST",
            image: UIImage(systemName: "network"),
            selectedImage: UIImage(systemName: "network")
        )

        let insumosVC = UINavigationController(rootViewController: InsumosStockViewController())
        insumosVC.tabBarItem = UITabBarItem(
            title: "Insumos",
            image: UIImage(systemName: "shippingbox"),
            selectedImage: UIImage(systemName: "shippingbox.fill")
        )

        let sedesVC = UINavigationController(rootViewController: SedesMapViewController())
        sedesVC.tabBarItem = UITabBarItem(
            title: "Sedes Mapa",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )

        viewControllers = [kdsVC, catalogoVC, insumosVC, sedesVC]
    }
}
