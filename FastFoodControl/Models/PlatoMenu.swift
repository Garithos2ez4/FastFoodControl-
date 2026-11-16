import Foundation

// MARK: - Respuesta Principal de DummyJSON Recipes API
struct DummyJSONRecipesResponse: Codable {
    let recipes: [PlatoMenuDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

// MARK: - Respuesta Complementaria de TheMealDB API (Burgers)
struct TheMealDBResponse: Codable {
    let meals: [MealDBItem]?
}

struct MealDBItem: Codable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?

    func toPlatoMenuDTO() -> PlatoMenuDTO {
        let ingredientes = [
            strIngredient1, strIngredient2, strIngredient3, strIngredient4,
            strIngredient5, strIngredient6, strIngredient7, strIngredient8
        ]
        .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }

        let pasos = (strInstructions ?? "Preparar ingredientes en estación caliente y ensamblar al momento.")
            .components(separatedBy: "\r\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        return PlatoMenuDTO(
            id: Int(idMeal) ?? Int.random(in: 1000...9999),
            name: strMeal,
            ingredients: ingredientes.isEmpty ? ["Pan Brioche", "Carne Grill 150g", "Queso Cheddar", "Salsa de la Casa"] : ingredientes,
            instructions: pasos.isEmpty ? ["Sellar proteína a la plancha", "Tostar pan y ensamblar"] : pasos,
            prepTimeMinutes: 8,
            cookTimeMinutes: 7,
            servings: 1,
            difficulty: "Estándar",
            cuisine: strArea ?? "Fast Food Grill",
            caloriesPerServing: 640,
            tags: ["Burger", strCategory ?? "Fast Food"],
            image: strMealThumb ?? "",
            rating: 4.8,
            mealType: ["Burgers"]
        )
    }
}

// MARK: - Modelo DTO del Catálogo de Cocina (REST API)
struct PlatoMenuDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let prepTimeMinutes: Int
    let cookTimeMinutes: Int
    let servings: Int
    let difficulty: String
    let cuisine: String
    let caloriesPerServing: Int
    let tags: [String]
    let image: String
    let rating: Double
    let mealType: [String]?

    var tiempoTotalMinutos: Int {
        max(5, prepTimeMinutes + cookTimeMinutes)
    }

    var categoriaCocina: String {
        let lowerName = name.lowercased()
        let lowerTags = tags.joined(separator: " ").lowercased()

        if lowerName.contains("burger") || lowerTags.contains("burger") {
            return "Burgers"
        } else if lowerName.contains("pizza") || lowerTags.contains("pizza") {
            return "Pizzas"
        } else if lowerName.contains("chicken") || lowerName.contains("wings") || lowerTags.contains("chicken") {
            return "Pollo Crispy"
        } else if lowerName.contains("wrap") || lowerName.contains("taco") || lowerName.contains("roll") {
            return "Wraps"
        } else if let firstMealType = mealType?.first, !firstMealType.isEmpty {
            return firstMealType
        }
        return "Especialidades"
    }
}
