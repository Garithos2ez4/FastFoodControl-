import Foundation

enum MockData {

    // MARK: - Comandas Iniciales para Core Data (Seed)
    static let comandasIniciales: [(codigoTicket: String, numeroMesa: String, clienteNombre: String, platoNombre: String, categoria: String, cantidad: Int, tiempoMin: Int, estado: EstadoComanda, notas: String, sede: String)] = [
        ("KDS-1041", "Mesa 04", "Carlos Mendoza", "Doble Smash Burger BBQ", "Burgers", 2, 12, .enCocina, "Sin cebolla, extra queso cheddar", "Sede Miraflores"),
        ("KDS-1042", "Retiro Barra", "Lucía Paredes", "Combo Crispy Chicken 6pz", "Pollo Crispy", 1, 10, .pendiente, "Salsa honey mustard aparte", "Sede Miraflores"),
        ("KDS-1043", "Drive-Thru 2", "Andrés Quispe", "Classic Bacon Cheeseburger", "Burgers", 3, 15, .listo, "Empaque térmico sellado", "Sede Miraflores"),
        ("KDS-1044", "Mesa 09", "Valeria Torres", "Wrap Pollo Grill & Palta", "Wraps", 1, 8, .pendiente, "Tortilla bien dorada", "Sede San Isidro"),
        ("KDS-1045", "Retiro Barra", "Diego Salazar", "Pizza Pepperoni Express", "Pizzas", 1, 14, .entregado, "Cortar en 8 porciones", "Sede Miraflores")
    ]

    // MARK: - Insumos Iniciales para Core Data (Seed)
    static let insumosIniciales: [(nombre: String, categoria: String, actual: Double, minimo: Double, unidad: String, merma: Double)] = [
        ("Carne Angus Smash 120g", "Proteínas", 48.0, 20.0, "und", 2.0),
        ("Pan Brioche Artesanal", "Panadería", 16.0, 25.0, "und", 3.0),
        ("Pechuga Crispy Marinada", "Proteínas", 34.0, 15.0, "kg", 1.5),
        ("Papas Bastón Pre-fritas", "Guarniciones", 12.0, 15.0, "kg", 1.0),
        ("Queso Cheddar Láminas", "Lácteos", 90.0, 40.0, "und", 4.0),
        ("Salsa BBQ Ahumada", "Salsas", 8.5, 5.0, "lt", 0.5),
        ("Lechuga Hidropónica", "Vegetales", 4.0, 6.0, "kg", 1.2)
    ]

    // MARK: - Sedes Operativas en Lima para MapKit
    static let sedesLima: [SedeSucursal] = [
        SedeSucursal(
            id: "SEDE-01",
            nombre: "FastFoodControl Miraflores",
            direccion: "Av. Larco 745, Miraflores",
            distrito: "Miraflores",
            latitud: -12.1235,
            longitud: -77.0298,
            jefeTurno: "Jorge Ramírez",
            comandasActivas: 7,
            horario: "10:00 - 23:30",
            telefono: "(01) 445-8901"
        ),
        SedeSucursal(
            id: "SEDE-02",
            nombre: "FastFoodControl San Isidro",
            direccion: "Av. Javier Prado Este 1450",
            distrito: "San Isidro",
            latitud: -12.0908,
            longitud: -77.0185,
            jefeTurno: "Mariana Vega",
            comandasActivas: 5,
            horario: "10:30 - 23:00",
            telefono: "(01) 422-3310"
        ),
        SedeSucursal(
            id: "SEDE-03",
            nombre: "FastFoodControl Surco (Jockey)",
            direccion: "Av. Javier Prado Este 4200",
            distrito: "Santiago de Surco",
            latitud: -12.0856,
            longitud: -76.9762,
            jefeTurno: "Luis Castillo",
            comandasActivas: 11,
            horario: "10:00 - 22:30",
            telefono: "(01) 436-7820"
        ),
        SedeSucursal(
            id: "SEDE-04",
            nombre: "FastFoodControl San Miguel",
            direccion: "Av. La Marina 2000",
            distrito: "San Miguel",
            latitud: -12.0774,
            longitud: -77.0819,
            jefeTurno: "Paola Huamán",
            comandasActivas: 6,
            horario: "10:00 - 23:00",
            telefono: "(01) 451-1920"
        ),
        SedeSucursal(
            id: "SEDE-05",
            nombre: "FastFoodControl Independencia",
            direccion: "Av. Alfredo Mendiola 3698",
            distrito: "Independencia",
            latitud: -11.9942,
            longitud: -77.0615,
            jefeTurno: "Renato Flores",
            comandasActivas: 9,
            horario: "10:00 - 23:00",
            telefono: "(01) 521-6044"
        )
    ]

    // MARK: - Fallback Offline para el Catálogo REST
    static let platosFallback: [PlatoMenuDTO] = [
        PlatoMenuDTO(
            id: 901,
            name: "Classic Smash Burger Doble",
            ingredients: ["2x Carne Angus 100g", "Pan Brioche", "2x Queso Cheddar", "Pepinillos", "Salsa Especial"],
            instructions: [
                "Precalentar plancha a 220°C.",
                "Aplastar las porciones de carne por 90 segundos cada lado.",
                "Fundir queso cheddar sobre la carne y ensamblar en pan brioche tostado."
            ],
            prepTimeMinutes: 5,
            cookTimeMinutes: 7,
            servings: 1,
            difficulty: "Estándar",
            cuisine: "Fast Food Grill",
            caloriesPerServing: 720,
            tags: ["Burger", "Best Seller"],
            image: "https://cdn.dummyjson.com/recipe-images/1.webp",
            rating: 4.9,
            mealType: ["Burgers"]
        ),
        PlatoMenuDTO(
            id: 902,
            name: "Crispy Chicken Deluxe",
            ingredients: ["Pechuga marinada 160g", "Pan Papa", "Coleslaw", "Mayonesa Ahumada"],
            instructions: [
                "Freír pechuga empanizada a 175°C por 5 minutos hasta alcanzar 74°C internos.",
                "Agregar coleslaw fresco y salsa ahumada sobre el pan."
            ],
            prepTimeMinutes: 4,
            cookTimeMinutes: 6,
            servings: 1,
            difficulty: "Fácil",
            cuisine: "Fast Food Crispy",
            caloriesPerServing: 610,
            tags: ["Chicken", "Crispy"],
            image: "https://cdn.dummyjson.com/recipe-images/2.webp",
            rating: 4.7,
            mealType: ["Pollo Crispy"]
        )
    ]
}
