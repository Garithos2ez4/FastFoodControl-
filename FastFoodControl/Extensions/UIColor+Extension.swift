import UIKit

extension UIColor {

    /// Inicializador conveniente mediante código hexadecimal (ej. "#C72923").
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted.removeFirst()
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    // MARK: - Paleta de Marca FastFoodControl
    static let ffPrimaryRed     = UIColor(hex: "#C72923")
    static let ffSecondaryAmber = UIColor(hex: "#F59E0B")
    static let ffKitchenGreen   = UIColor(hex: "#16A34A")
    static let ffSurfaceBg      = UIColor(hex: "#F6F7FB")
    static let ffCardBg         = UIColor.systemBackground
    static let ffDarkText       = UIColor(hex: "#1F2937")
    static let ffMutedText      = UIColor(hex: "#6B7280")

    // MARK: - Colores de Estado de Comanda (KDS)
    static let ffPendingOrange  = UIColor(hex: "#EA580C")
    static let ffCookingBlue    = UIColor(hex: "#2563EB")
    static let ffReadyGreen     = UIColor(hex: "#15803D")
    static let ffDeliveredGray  = UIColor(hex: "#64748B")
}
