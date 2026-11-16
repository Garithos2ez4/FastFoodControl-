import Foundation

enum Constants {

    // MARK: - Endpoints REST API (Públicos, ajenos a iTunes API y exámenes)
    enum APIEndpoints {
        static let recipesURL = "https://dummyjson.com/recipes?limit=30"
        static let mealDBBurgersURL = "https://www.themealdb.com/api/json/v1/1/search.php?s=burger"
    }

    // MARK: - Core Data
    enum CoreData {
        static let modelName = "FastFoodControl"
        static let comandaEntity = "ComandaEntity"
        static let insumoEntity = "InsumoEntity"
        static let seedCompletedKey = "FastFoodControl_CoreData_Seeded_v1"
    }

    // MARK: - Notificaciones Locales (UserNotifications)
    enum Notifications {
        static let kitchenTimerPrefix = "kds.timer."
        static let lowStockPrefix = "kds.stock."
    }

    // MARK: - Sesión de Personal
    enum Session {
        static let currentStaffNameKey = "FastFoodControl_StaffName"
        static let currentStaffRoleKey = "FastFoodControl_StaffRole"
        static let defaultSede = "Sede Miraflores"
    }
}
