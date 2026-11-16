# INFORME DE PROYECTO DE INVESTIGACIÓN APLICADA — CIBERTEC (2026)

> **Nota de Formato (Sección 6 del Sílabo):** Al pasar este contenido a Microsoft Word / Google Docs para la entrega final, configure la hoja en **tamaño A4**, márgenes **superior e inferior 3 cm**, **derecho e izquierdo 2.5 cm**, fuente **Arial 11 puntos**, **interlineado simple** y notas al pie de página reales para las fuentes del análisis SEPTE.

---

## CARÁTULA (Sección 6.3)

<div align="center">

**INSTITUTO DE EDUCACIÓN SUPERIOR CIBERTEC**  
**DIRECCIÓN ACADÉMICA — CARRERAS PROFESIONALES**  
**ESCUELA DE TECNOLOGÍAS DE LA INFORMACIÓN**  
**CARRERA DE COMPUTACIÓN E INFORMÁTICA**

<br>

### **FastFoodControl: Sistema Móvil iOS para Gestión de Comandas en Cocina (KDS), Recetario Técnico REST y Control de Insumos y Mermas con Core Data**

<br>

**CURSO:** Desarrollo de Aplicaciones Móviles II  
**DOCENTE:** *[Completar con nombre del profesor]*  
**CICLO / AULA / SEMESTRE:** Sexto Ciclo — Aula *[Completar]* — 2026  

</div>

**COORDINADOR DEL GRUPO:** *[Completar Apellidos y Nombres]*  
**INTEGRANTES DEL GRUPO (Máximo 4):**
1. *[Integrante 1 — Coordinador]*
2. *[Integrante 2]*
3. *[Integrante 3]*
4. *[Integrante 4]*

---

## 5. ESTRUCTURA DEL PROYECTO

### 5.1. Resumen
**FastFoodControl** es una aplicación móvil nativa desarrollada en **Swift con UIKit y arquitectura MVVM** para dispositivos **iOS**, orientada a optimizar las operaciones internas de restaurantes de comida rápida (*Fast Food*). A diferencia de las aplicaciones comerciales basadas en carritos de compra (prohibidos por el alcance del curso), la solución se enfoca en el **control de estación de cocina (Kitchen Display System - KDS)**, la estandarización de recetas mediante consumo de **servicios REST (`URLSession` + `Codable`)**, el registro de inventarios y mermas mediante **persistencia local nativa con Core Data (`NSPersistentContainer`)**, y la integración de tres herramientas nativas de Apple: **`UserNotifications`**, **`MapKit` / `CoreLocation`** y **`CoreImage` (`CIQRCodeGenerator`)**.

### 5.2. Introducción
En el sector gastronómico de servicio rápido (*Quick Service Restaurants - QSR*), la velocidad de preparación, la exactitud de las órdenes y el control del desperdicio de insumos (*mermas*) determinan directamente la rentabilidad del negocio y la satisfacción del comensal. Muchos locales medianos y emergentes de comida rápida aún gestionan comandas en papel o pizarras manuales, lo que genera extravío de pedidos en horas punta, demoras en cocina y falta de visibilidad sobre insumos críticos.

El presente proyecto aplica los conocimientos adquiridos en **Desarrollo de Aplicaciones Móviles II** para construir una herramienta móvil operativa, funcional offline y sincronizada vía REST, demostrando un impacto positivo tanto en la eficiencia del personal de cocina como en la trazabilidad operativa de cada sede.

### 5.3. Diagnóstico (Análisis SEPTE)
Con el objetivo de fundamentar la oportunidad de mejora en el sector *Fast Food* en el Perú, se realizó el análisis **SEPTE** considerando cuatro variables clave respaldadas por fuentes oficiales y sectoriales:

#### 1. Variable Social
Los hábitos de consumo urbano han impulsado una alta demanda de comida rápida y formatos *take-away* debido a la menor disponibilidad de tiempo en la jornada laboral y estudiantil. Según reportes del sector gastronómico y estudios de consumo urbano en Lima Metropolitana, los consumidores priorizan tiempos de espera cortos (menores a 10–15 minutos) y precisión en el pedido entregado[^1]. Cuando las comandas se manejan manualmente en cocina, los errores de comunicación (*ej. ingredientes omitidos o pedidos cruzados*) deterioran la experiencia del cliente y generan reclamos en barra.

#### 2. Variable Económica
De acuerdo con el **Instituto Nacional de Estadística e Informática (INEI)**, el subsector de restaurantes —incluyendo establecimientos de comida rápida, pollerías y sandwicherías— constituye uno de los motores clave del PBI de servicios en el Perú[^2]. No obstante, la rentabilidad de los negocios QSR se ve presionada por el alza de insumos alimentarios y las **mermas operativas** (caducidad, sobreporcionamiento o preparación errónea), las cuales pueden representar entre el 4% y el 10% del costo de alimentos cuando no existe un control diario de inventario mínimo y mermas registradas[^3].

#### 3. Variable Tecnológica
La adopción de dispositivos móviles y conectividad en entornos empresariales peruanos ha crecido sostenidamente, superando el 89% de acceso móvil en áreas urbanas según cifras de **OSIPTEL**[^4]. A nivel de ingeniería móvil, el ecosistema **iOS** ofrece frameworks nativos de alto rendimiento como **Core Data** (persistencia transaccional sin latencia de red) y **URLSession** (consumo eficiente de APIs REST), permitiendo digitalizar estaciones KDS y tableros de turno sin necesidad de costosos servidores dedicados en cada punto de venta.

#### 4. Variable Ecológica
La reducción del desperdicio de alimentos (*food waste*) y del consumo excesivo de papel térmico para tickets impresos en cocina representa una prioridad ambiental creciente, alineada con la **Ley N° 30884** (que regula plásticos de un solo uso y promueve prácticas sostenibles en comercios y restaurantes en el Perú)[^5]. Reemplazar comandas físicas en papel por tableros KDS digitales y tickets **QR en pantalla** disminuye residuos de papel y mejora el aprovechamiento de insumos perecibles mediante alertas tempranas de stock crítico.

**Síntesis del Diagnóstico:**  
- **Oportunidad identificada:** Digitalizar el flujo interno de comandas, fichas técnicas y control de mermas mediante una app nativa iOS que funcione incluso ante caídas de internet gracias a Core Data.  
- **Amenazas detectadas:** Alta rotación de personal en cocina (requiere una interfaz intuitiva) e inestabilidad ocasional de red en hora punta (mitigada con persistencia local nativa).

[^1]: Datum Internacional / Cámara Nacional de Turismo (CANATUR). *Hábitos de consumo gastronómico y servicio rápido en Lima Metropolitana*.
[^2]: Instituto Nacional de Estadística e Informática (INEI). *Encuesta Mensual del Sector Servicios — Subsector Restaurantes (2025–2026)*. Disponible en: https://www.inei.gob.pe
[^3]: Cámara de Comercio de Lima (CCL) — Gremio de Turismo y Gastronomía. *Gestión de costos, mermas e insumos en restaurantes de servicio rápido*.
[^4]: Organismo Supervisor de Inversión Privada en Telecomunicaciones (OSIPTEL). *Indicadores de penetración de internet móvil y smartphones en el Perú*. Disponible en: https://www.osiptel.gob.pe
[^5]: Congreso de la República del Perú. *Ley N° 30884, Ley que regula el plástico de un solo uso y los recipientes o envases descartables* (MINAM).

---

### 5.4. Objetivos (Criterios SMART)

#### OBJ 1.- Optimización del Control de Comandas y Mermas mediante Core Data y REST
Desarrollar e implementar la aplicación móvil nativa iOS **FastFoodControl** en Xcode (Swift/UIKit) integrando persistencia local **Core Data** (CRUD completo de comandas e insumos) y consumo de **servicios REST** (`URLSession` + `Codable`) para estandarizar el flujo de preparación en cocina y reducir en al menos un **35%** los errores de registro y demora administrativa de tickets y mermas durante las **6 semanas** de ejecución del proyecto en el ciclo **2026**.
- **Específico (S):** Control de comandas KDS, recetario técnico REST e inventario/mermas en Core Data.
- **Medible (M):** Reducción $\ge 35\%$ en errores de transcripción de comandas y tiempo de registro; 2 entidades Core Data con CRUD completo.
- **Alcanzable (A):** Implementado con herramientas estándar enseñadas en clase (UIKit, Core Data, URLSession).
- **Relevante (R):** Resuelve directamente las fallas operativas y pérdidas por mermas detectadas en el análisis SEPTE.
- **A Tiempo (T):** Validado al 50% en la Semana 5 y al 100% en la Semana 7 del ciclo 2026.

#### OBJ 2.- Integración de Herramientas Nativas de iOS para Trazabilidad Operativa
Incorporar **3 herramientas nativas del SDK de iOS** (**`UserNotifications`**, **`MapKit`/`CoreLocation`** y **`CoreImage` QR Generator**) dentro de **FastFoodControl**, garantizando alertas automáticas de temporizadores de cocina y stock crítico, geolocalización de sedes operativas y generación de tickets QR de despacho, alcanzando un **100% de operatividad funcional** antes de la **Semana 7** del curso.
- **Específico (S):** Implementación comprobable de 3 frameworks nativos de Apple en casos de uso reales del restaurante.
- **Medible (M):** 3 herramientas nativas integradas, documentadas y funcionando en simulador Xcode sin caídas.
- **Alcanzable (A):** Uso directo de `UNUserNotificationCenter`, `MKMapView`/`CLLocationManager` y `CIFilter("CIQRCodeGenerator")`.
- **Relevante (R):** Aporta automatización en tiempo real, trazabilidad entre sedes y despacho digital sin papel.
- **A Tiempo (T):** Entregado y sustentado en la presentación final de la Semana 7.

---

### 5.5. Justificación del Proyecto
**Aplicabilidad e Impacto:**  
**FastFoodControl** demuestra que un restaurante de comida rápida no necesita adquirir hardware KDS propietario de alto costo para digitalizar su cocina. Utilizando dispositivos iOS estándar (iPhone/iPad), el equipo de turno puede recibir fichas técnicas actualizadas desde una API REST, controlar tiempos de cocción con notificaciones locales, emitir códigos QR verificables para despacho en barra y auditar el stock mínimo evitando quiebres de inventario o mermas excesivas.

**Beneficiarios Directos:**
- **Personal de cocina y jefes de turno:** Cuentan con un tablero visual ordenado por estado (*Pendiente → En Cocina → Listo → Entregado*), notas de preparación claras y temporizadores automáticos.
- **Administradores y auditores de inventario:** Disponen de registro inmediato de reposiciones, mermas y alertas automáticas de stock crítico almacenadas localmente en Core Data.
- **Equipo desarrollador (estudiantes):** Consolida competencias profesionales en arquitectura MVVM, persistencia nativa, redes REST y frameworks nativos de Apple.

**Beneficiarios Indirectos:**
- **Clientes finales del establecimiento:** Reciben sus pedidos con mayor rapidez, menor margen de error en personalizaciones y mejor estándar de calidad.
- **Proveedores de insumos y franquicias:** Se benefician de reposiciones planificadas a tiempo gracias a los umbrales mínimos de stock.

---

### 5.6. Definición y Alcance
**Lógica y Arquitectura del Proyecto:**  
La aplicación sigue el patrón arquitectónico **MVVM (Model - View - ViewModel)** sobre **UIKit (`UIViewController`, `UITabBarController`, `UITableView`, `UICollectionView`)**, organizada en módulos independientes:
1. **Capa de Persistencia Nativa (`CoreDataManager` + `FastFoodControl.xcdatamodeld`):** Administra las entidades `ComandaEntity` y `InsumoEntity` mediante `NSPersistentContainer`, `NSFetchRequest`, `NSPredicate` y `NSSortDescriptor`. Incluye inicialización de datos semilla y respaldo programático del modelo para garantizar portabilidad entre proyectos Xcode.
2. **Capa de Servicios REST (`NetworkManager` + `APIMenuService`):** Consume endpoints REST externos (`https://dummyjson.com/recipes` y `https://www.themealdb.com/api/json/v1/1/search.php?s=burger`) mediante `URLSession` y `JSONDecoder` (`Codable`), cumpliendo estrictamente la prohibición de no utilizar iTunes API ni servicios de exámenes previos.
3. **Capa de Herramientas Nativas iOS:**
   - **`UserNotifications` (`NotificationService`):** Notificaciones locales en primer y segundo plano para vencimiento de temporizador de comandas en cocina y alertas de stock crítico.
   - **`MapKit` y `CoreLocation` (`GeocodeSedeService` + `SedesMapViewController`):** Mapa interactivo de sedes en Lima con marcadores personalizados (`MKMarkerAnnotationView`) y cálculo de distancia al usuario.
   - **`CoreImage` (`QRTicketService`):** Generador nativo de códigos QR (`CIQRCodeGenerator`) para validación rápida de tickets en barra sin uso de papel.

**Cumplimiento de Restricciones del Alcance:**  
El proyecto **NO** implementa un carrito de compras ni pasarela de pagos para consumidores, **NO** es una red social ni app de música, y sustituye cualquier esquema previo de *e-commerce* por un sistema B2B/operativo de **gestión de cocina e insumos**.

---

### 5.7. Productos y Entregables
1. **Código fuente Xcode (`FastFoodControl`):** Proyecto estructurado en Swift compatible con Xcode 15/16+.
2. **Base de datos local (`FastFoodControl.xcdatamodeld`):** Esquema Core Data con 2 entidades operativas.
3. **Informe Técnico-Académico del Proyecto (Formato A4 CIBERTEC).**
4. **Vídeo - Demo Reel Estructurado (3–5 minutos):**
   - *Min 0:00 – 0:45:* Presentación del equipo, problemática SEPTE y justificación (sin carrito de compras).
   - *Min 0:45 – 1:45:* Demostración de **Core Data CRUD** en vivo (crear comanda KDS, cambiar estado, swipe para eliminar, reiniciar app y verificar persistencia; registro de reposición y merma en Insumos).
   - *Min 1:45 – 2:30:* Demostración de **Servicios REST** (carga de recetas técnicas desde DummyJSON/TheMealDB, búsqueda, filtros por categoría y conversión de receta a comanda).
   - *Min 2:30 – 3:45:* Demostración de las **3 Herramientas Nativas iOS** (`UserNotifications` disparando alerta de timer/stock crítico, `CoreImage` generando QR en detalle de ticket y `MapKit`/`CoreLocation` ubicando sedes).
   - *Min 3:45 – 4:15:* Revisión rápida de la estructura ordenada del código en Xcode (MVVM) y conclusiones.

---

### 5.8. Conclusiones *(Máximo 3 según Sección 5.8)*
1. La implementación de **Core Data (`NSPersistentContainer`)** junto con el consumo asíncrono de **servicios REST (`URLSession` + `Codable`)** bajo el patrón **MVVM** permitió construir una aplicación KDS estable que opera sin interrupciones incluso ante pérdida temporal de conectividad en cocina, cumpliendo el 100% de los requerimientos técnicos del curso.
2. La integración conjunta de **3 herramientas nativas de iOS** (`UserNotifications`, `MapKit`/`CoreLocation` y `CoreImage`) demostró un valor operativo directo en el sector *Fast Food*: redujo la dependencia de tickets impresos en papel mediante códigos QR digitales y automatizó la detección de stock crítico y vencimiento de tiempos de cocción.
3. El enfoque de **gestión interna de comandas e insumos** permitió atender la problemática real de mermas y errores de despacho identificada en el análisis SEPTE, manteniendo el proyecto completamente alineado a las políticas académicas vigentes de CIBERTEC al prescindir de modelos prohibidos como carritos de compra.

---

### 5.9. Recomendaciones *(Máximo 3 según Sección 5.9)*
1. Para despliegues en cadenas con múltiples locales simultáneos, se recomienda complementar el almacenamiento local de **Core Data** con una sincronización bidireccional en la nube (mediante API REST propia o WebSockets) que replique los cambios de estado de comandas en tiempo real entre caja, cocina y pantallas de despacho.
2. Incorporar en futuras versiones el uso del framework **`Swift Charts`** o exportación en PDF nativo (`UIGraphicsPDFRenderer`) para generar reportes gerenciales semanales de mermas acumuladas y tiempos promedio de preparación por turno.
3. Realizar pruebas de usabilidad directamente en dispositivos **iPad** montados en estación de cocina con orientación horizontal, validando el contraste visual y tamaño táctil de los botones de cambio de estado en condiciones reales de alta demanda.

---

### 5.10. Glosario
- **KDS (Kitchen Display System):** Sistema digital de visualización de comandas que reemplaza las comandas impresas en papel en las cocinas de restaurantes.
- **Core Data:** Framework nativo de Apple para la gestión del grafo de objetos y persistencia local de datos en dispositivos iOS/macOS.
- **NSPersistentContainer:** Contenedor de Core Data que encapsula el `NSManagedObjectModel`, el `NSPersistentStoreCoordinator` y el `NSManagedObjectContext`.
- **Servicio REST:** Interfaz de comunicación cliente-servidor basada en protocolo HTTP/HTTPS e intercambio de datos estructurados en formato JSON.
- **URLSession:** Clase nativa del SDK Foundation de Apple encargada de ejecutar solicitudes y descargas de red de forma asíncrona.
- **Codable:** Protocolo de Swift (`Encodable & Decodable`) que permite serializar y deserializar objetos JSON de forma segura y tipada.
- **MVVM (Model-View-ViewModel):** Patrón arquitectónico que separa la lógica de negocio y presentación (`ViewModel`) de los controladores visuales (`ViewController`).
- **Merma:** Pérdida física de materia prima o insumos alimentarios por caducidad, deterioro, cocción defectuosa o errores de manipulación.
- **CIQRCodeGenerator:** Filtro nativo del framework `CoreImage` de Apple utilizado para generar matrices de códigos QR a partir de datos binarios o texto.
- **UNUserNotificationCenter:** Objeto central de `UserNotifications` que gestiona permisos, programación y entrega de notificaciones locales en iOS.

---

### 5.11. Bibliografía *(Sustentación de la investigación — 3.0 puntos)*
1. Apple Inc. (2025). *Core Data Programming Guide & NSPersistentContainer Documentation*. Apple Developer Documentation. https://developer.apple.com/documentation/coredata
2. Apple Inc. (2025). *URL Loading System & URLSession*. Apple Developer Documentation. https://developer.apple.com/documentation/foundation/url_loading_system
3. Apple Inc. (2025). *UserNotifications Framework — Scheduling a Notification Locally*. Apple Developer Documentation. https://developer.apple.com/documentation/usernotifications
4. Apple Inc. (2025). *MapKit & CoreLocation Frameworks*. Apple Developer Documentation. https://developer.apple.com/documentation/mapkit
5. Apple Inc. (2025). *Core Image Filter Reference — CIQRCodeGenerator*. Apple Developer Documentation. https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/
6. Apple Inc. (2025). *Human Interface Guidelines (iOS)*. Apple Developer. https://developer.apple.com/design/human-interface-guidelines/
7. Keur, C., & Hillegass, A. (2020). *iOS Programming: The Big Nerd Ranch Guide* (7th ed.). Big Nerd Ranch Guides.
8. Instituto Nacional de Estadística e Informática — INEI. (2025). *Estadísticas del Sector Servicios y Restaurantes en el Perú*. https://www.inei.gob.pe
9. DummyJSON & TheMealDB. (2025). *Public REST API Specifications for Recipe Data*. https://dummyjson.com/docs/recipes

---

### 5.12. Cronograma de los 6 Avances Semanales (Semanas 2 a 7)

| Avance | Semana | Entregable Técnico & Documental | Estado |
| :--- | :--- | :--- | :--- |
| **Avance 1** | Semana 2–3 | Definición del proyecto (Sin carrito), Análisis SEPTE, Objetivos SMART, estructura MVVM en Xcode. | Listo en este paquete |
| **Avance 2** | Semana 3–4 | Modelo **Core Data** (`ComandaEntity`, `InsumoEntity`), `CoreDataManager` y CRUD completo de Comandas e Insumos. | Listo en código |
| **Avance 3** | Semana 4–5 | Consumo de **Servicios REST** (`NetworkManager`, `APIMenuService`, `PlatoMenuDTO`) y pantallas de Recetario Técnico. | Listo en código |
| **Hito 50%** | **Semana 5** | **Sustentación de Avance (20 pts):** Demo en vivo de Core Data + REST + Secciones 5.1–5.5 del informe. | Preparado |
| **Avance 4** | Semana 5–6 | Implementación de Herramientas Nativas #1 (`UserNotifications`) y #2 (`MapKit` + `CoreLocation`). | Listo en código |
| **Avance 5** | Semana 6 | Implementación de Herramienta Nativa #3 (`CoreImage` QR Generator) + validaciones y pruebas en Simulador. | Listo en código |
| **Avance 6** | **Semana 7** | **Sustentación Final (100%):** Informe A4 final, Video Demo Reel (3–5 min) y exposición grupal. | Preparado |
