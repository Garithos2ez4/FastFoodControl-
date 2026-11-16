import UIKit

extension UIViewController {

    /// Reemplaza la pantalla raíz de la ventana actual con una transición suave.
    /// No depende de SceneDelegate, por lo que funciona en cualquier proyecto Xcode.
    func cambiarPantallaRaiz(a nuevoVC: UIViewController) {
        let ventanaActiva = view.window ?? UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first

        guard let window = ventanaActiva else {
            nuevoVC.modalPresentationStyle = .fullScreen
            present(nuevoVC, animated: true)
            return
        }

        window.rootViewController = nuevoVC
        UIView.transition(
            with: window,
            duration: 0.35,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
}
