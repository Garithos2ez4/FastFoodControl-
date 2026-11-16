import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = SplashViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    func cambiarARootViewController(_ vc: UIViewController, animado: Bool = true) {
        guard let window = self.window else { return }
        window.rootViewController = vc
        if animado {
            UIView.transition(
                with: window,
                duration: 0.35,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        }
    }

    static var current: SceneDelegate? {
        UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
}
