import Foundation
import CoreData

/// Gestor centralizado de persistencia local nativa usando Core Data (NSPersistentContainer).
final class CoreDataManager {

    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() {
        if let modelURL = Bundle.main.url(forResource: Constants.CoreData.modelName, withExtension: "momd"),
           let managedModel = NSManagedObjectModel(contentsOf: modelURL) {
            persistentContainer = NSPersistentContainer(
                name: Constants.CoreData.modelName,
                managedObjectModel: managedModel
            )
        } else {
            // Respaldo programático idéntico al esquema .xcdatamodeld para evitar caídas
            // si los archivos Swift se integran directamente en otro proyecto Xcode.
            let fallbackModel = CoreDataManager.construirModeloProgramatico()
            persistentContainer = NSPersistentContainer(
                name: Constants.CoreData.modelName,
                managedObjectModel: fallbackModel
            )
        }

        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("❌ Error al cargar Core Data: \(error), \(error.userInfo)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Modelo Core Data Programático de Respaldo
    private static func construirModeloProgramatico() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // Entidad: ComandaEntity
        let comandaEntity = NSEntityDescription()
        comandaEntity.name = Constants.CoreData.comandaEntity
        comandaEntity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        comandaEntity.properties = [
            makeAttribute("id", .stringAttributeType, defaultValue: ""),
            makeAttribute("codigoTicket", .stringAttributeType, defaultValue: ""),
            makeAttribute("numeroMesa", .stringAttributeType, defaultValue: "Barra 1"),
            makeAttribute("clienteNombre", .stringAttributeType, defaultValue: ""),
            makeAttribute("platoNombre", .stringAttributeType, defaultValue: ""),
            makeAttribute("categoria", .stringAttributeType, defaultValue: "Burgers"),
            makeAttribute("cantidad", .integer16AttributeType, defaultValue: 1),
            makeAttribute("tiempoPreparacionMin", .integer16AttributeType, defaultValue: 10),
            makeAttribute("estado", .stringAttributeType, defaultValue: EstadoComanda.pendiente.rawValue),
            makeAttribute("notasCocina", .stringAttributeType, defaultValue: ""),
            makeAttribute("fechaCreacion", .dateAttributeType, defaultValue: nil),
            makeAttribute("sedeNombre", .stringAttributeType, defaultValue: Constants.Session.defaultSede)
        ]

        // Entidad: InsumoEntity
        let insumoEntity = NSEntityDescription()
        insumoEntity.name = Constants.CoreData.insumoEntity
        insumoEntity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        insumoEntity.properties = [
            makeAttribute("id", .stringAttributeType, defaultValue: ""),
            makeAttribute("nombre", .stringAttributeType, defaultValue: ""),
            makeAttribute("categoria", .stringAttributeType, defaultValue: "Proteínas"),
            makeAttribute("cantidadActual", .doubleAttributeType, defaultValue: 0.0),
            makeAttribute("cantidadMinima", .doubleAttributeType, defaultValue: 10.0),
            makeAttribute("unidadMedida", .stringAttributeType, defaultValue: "und"),
            makeAttribute("mermaRegistrada", .doubleAttributeType, defaultValue: 0.0),
            makeAttribute("ultimaActualizacion", .dateAttributeType, defaultValue: nil)
        ]

        model.entities = [comandaEntity, insumoEntity]
        return model
    }

    private static func makeAttribute(
        _ name: String,
        _ type: NSAttributeType,
        defaultValue: Any?
    ) -> NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = name
        attr.attributeType = type
        attr.isOptional = true
        attr.defaultValue = defaultValue
        return attr
    }

    // MARK: - Guardado Seguro
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("❌ Error guardando Core Data: \(error.localizedDescription)")
        }
    }

    // MARK: - Población Inicial (Seed)
    func seedInitialDataIfNeeded() {
        let yaPoblado = UserDefaults.standard.bool(forKey: Constants.CoreData.seedCompletedKey)
        let existentes = obtenerComandas()
        if yaPoblado && !existentes.isEmpty { return }

        if existentes.isEmpty {
            for item in MockData.comandasIniciales {
                _ = crearComanda(
                    codigoTicket: item.codigoTicket,
                    numeroMesa: item.numeroMesa,
                    clienteNombre: item.clienteNombre,
                    platoNombre: item.platoNombre,
                    categoria: item.categoria,
                    cantidad: item.cantidad,
                    tiempoPreparacionMin: item.tiempoMin,
                    estado: item.estado,
                    notasCocina: item.notas,
                    sedeNombre: item.sede
                )
            }
        }

        if obtenerInsumos().isEmpty {
            for item in MockData.insumosIniciales {
                _ = crearInsumo(
                    nombre: item.nombre,
                    categoria: item.categoria,
                    cantidadActual: item.actual,
                    cantidadMinima: item.minimo,
                    unidadMedida: item.unidad,
                    mermaRegistrada: item.merma
                )
            }
        }

        UserDefaults.standard.set(true, forKey: Constants.CoreData.seedCompletedKey)
    }

    // MARK: - CRUD Comandas (Core Data)

    @discardableResult
    func crearComanda(
        codigoTicket: String = String.generarCodigoTicketKDS(),
        numeroMesa: String,
        clienteNombre: String,
        platoNombre: String,
        categoria: String,
        cantidad: Int,
        tiempoPreparacionMin: Int,
        estado: EstadoComanda = .pendiente,
        notasCocina: String = "",
        sedeNombre: String = Constants.Session.defaultSede
    ) -> ComandaOrder {
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: Constants.CoreData.comandaEntity,
            into: context
        )
        let nuevoId = UUID().uuidString
        let fecha = Date()

        entity.setValue(nuevoId, forKey: "id")
        entity.setValue(codigoTicket, forKey: "codigoTicket")
        entity.setValue(numeroMesa, forKey: "numeroMesa")
        entity.setValue(clienteNombre, forKey: "clienteNombre")
        entity.setValue(platoNombre, forKey: "platoNombre")
        entity.setValue(categoria, forKey: "categoria")
        entity.setValue(Int16(cantidad), forKey: "cantidad")
        entity.setValue(Int16(tiempoPreparacionMin), forKey: "tiempoPreparacionMin")
        entity.setValue(estado.rawValue, forKey: "estado")
        entity.setValue(notasCocina, forKey: "notasCocina")
        entity.setValue(fecha, forKey: "fechaCreacion")
        entity.setValue(sedeNombre, forKey: "sedeNombre")

        saveContext()
        return mapComanda(entity)
    }

    func obtenerComandas(filtroEstado: EstadoComanda? = nil, busqueda: String? = nil) -> [ComandaOrder] {
        let request = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.comandaEntity)
        request.sortDescriptors = [NSSortDescriptor(key: "fechaCreacion", ascending: false)]

        var predicates: [NSPredicate] = []
        if let estado = filtroEstado {
            predicates.append(NSPredicate(format: "estado == %@", estado.rawValue))
        }
        if let query = busqueda?.trimmed, !query.isEmpty {
            predicates.append(NSPredicate(
                format: "platoNombre CONTAINS[cd] %@ OR clienteNombre CONTAINS[cd] %@ OR codigoTicket CONTAINS[cd] %@ OR numeroMesa CONTAINS[cd] %@",
                query, query, query, query
            ))
        }

        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        do {
            let results = try context.fetch(request)
            return results.map { mapComanda($0) }
        } catch {
            print("❌ Error al consultar comandas: \(error.localizedDescription)")
            return []
        }
    }

    func actualizarEstadoComanda(id: String, nuevoEstado: EstadoComanda, notas: String? = nil) {
        let request = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.comandaEntity)
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        do {
            if let obj = try context.fetch(request).first {
                obj.setValue(nuevoEstado.rawValue, forKey: "estado")
                if let notas = notas {
                    obj.setValue(notas, forKey: "notasCocina")
                }
                saveContext()
            }
        } catch {
            print("❌ Error actualizando comanda: \(error.localizedDescription)")
        }
    }

    func eliminarComanda(id: String) {
        let request = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.comandaEntity)
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            let objects = try context.fetch(request)
            objects.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("❌ Error eliminando comanda: \(error.localizedDescription)")
        }
    }

    private func mapComanda(_ obj: NSManagedObject) -> ComandaOrder {
        let estadoRaw = obj.value(forKey: "estado") as? String ?? EstadoComanda.pendiente.rawValue
        return ComandaOrder(
            id: obj.value(forKey: "id") as? String ?? UUID().uuidString,
            codigoTicket: obj.value(forKey: "codigoTicket") as? String ?? "KDS-0000",
            numeroMesa: obj.value(forKey: "numeroMesa") as? String ?? "Barra",
            clienteNombre: obj.value(forKey: "clienteNombre") as? String ?? "Cliente",
            platoNombre: obj.value(forKey: "platoNombre") as? String ?? "Combo",
            categoria: obj.value(forKey: "categoria") as? String ?? "Burgers",
            cantidad: Int(obj.value(forKey: "cantidad") as? Int16 ?? 1),
            tiempoPreparacionMin: Int(obj.value(forKey: "tiempoPreparacionMin") as? Int16 ?? 10),
            estado: EstadoComanda(rawValue: estadoRaw) ?? .pendiente,
            notasCocina: obj.value(forKey: "notasCocina") as? String ?? "",
            fechaCreacion: obj.value(forKey: "fechaCreacion") as? Date ?? Date(),
            sedeNombre: obj.value(forKey: "sedeNombre") as? String ?? Constants.Session.defaultSede
        )
    }

    // MARK: - CRUD Insumos y Mermas (Core Data)

    @discardableResult
    func crearInsumo(
        nombre: String,
        categoria: String,
        cantidadActual: Double,
        cantidadMinima: Double,
        unidadMedida: String,
        mermaRegistrada: Double = 0.0
    ) -> InsumoStock {
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: Constants.CoreData.insumoEntity,
            into: context
        )
        let nuevoId = UUID().uuidString
        let fecha = Date()

        entity.setValue(nuevoId, forKey: "id")
        entity.setValue(nombre, forKey: "nombre")
        entity.setValue(categoria, forKey: "categoria")
        entity.setValue(cantidadActual, forKey: "cantidadActual")
        entity.setValue(cantidadMinima, forKey: "cantidadMinima")
        entity.setValue(unidadMedida, forKey: "unidadMedida")
        entity.setValue(mermaRegistrada, forKey: "mermaRegistrada")
        entity.setValue(fecha, forKey: "ultimaActualizacion")

        saveContext()
        return mapInsumo(entity)
    }

    func obtenerInsumos(soloCriticos: Bool = false) -> [InsumoStock] {
        let request = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.insumoEntity)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]

        do {
            let items = try context.fetch(request).map { mapInsumo($0) }
            if soloCriticos {
                return items.filter { $0.esStockCritico }
            }
            return items
        } catch {
            print("❌ Error consultando insumos: \(error.localizedDescription)")
            return []
        }
    }

    func registrarMovimientoInsumo(id: String, deltaStock: Double, nuevaMerma: Double = 0.0) -> InsumoStock? {
        let request = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.insumoEntity)
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        do {
            if let obj = try context.fetch(request).first {
                let actual = obj.value(forKey: "cantidadActual") as? Double ?? 0.0
                let mermaActual = obj.value(forKey: "mermaRegistrada") as? Double ?? 0.0
                let nuevoStock = max(0.0, actual + deltaStock)

                obj.setValue(nuevoStock, forKey: "cantidadActual")
                obj.setValue(mermaActual + nuevaMerma, forKey: "mermaRegistrada")
                obj.setValue(Date(), forKey: "ultimaActualizacion")
                saveContext()
                return mapInsumo(obj)
            }
        } catch {
            print("❌ Error actualizando insumo: \(error.localizedDescription)")
        }
        return nil
    }

    func eliminarInsumo(id: String) {
        let request = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.insumoEntity)
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            let items = try context.fetch(request)
            items.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("❌ Error eliminando insumo: \(error.localizedDescription)")
        }
    }

    private func mapInsumo(_ obj: NSManagedObject) -> InsumoStock {
        InsumoStock(
            id: obj.value(forKey: "id") as? String ?? UUID().uuidString,
            nombre: obj.value(forKey: "nombre") as? String ?? "Insumo",
            categoria: obj.value(forKey: "categoria") as? String ?? "General",
            cantidadActual: obj.value(forKey: "cantidadActual") as? Double ?? 0.0,
            cantidadMinima: obj.value(forKey: "cantidadMinima") as? Double ?? 10.0,
            unidadMedida: obj.value(forKey: "unidadMedida") as? String ?? "und",
            mermaRegistrada: obj.value(forKey: "mermaRegistrada") as? Double ?? 0.0,
            ultimaActualizacion: obj.value(forKey: "ultimaActualizacion") as? Date ?? Date()
        )
    }
}
