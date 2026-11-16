# Guía de Instalación y Prueba en Xcode (macOS) — FastFoodControl

Esta guía te explica cómo ejecutar el proyecto **`FastFoodControl`** en una Mac con **Xcode** (por ejemplo, partiendo de la plantilla `clase_03` que mostraste en tu captura de pantalla).

---

## Paso 1: Crear o abrir el proyecto en Xcode
1. En tu Mac, abre **Xcode** → **Create New Project...** → **iOS** → **App**.
2. Configura los datos así:
   - **Product Name:** `FastFoodControl`
   - **Interface:** `Storyboard`
   - **Language:** `Swift`
   - **Storage:** `Core Data` *(opcional marcarlo, porque `CoreDataManager.swift` incluye también respaldo programático seguro).*
3. Guarda el proyecto en tu escritorio o carpeta de trabajo.

---

## Paso 2: Copiar las carpetas de código al proyecto Xcode
1. Copia toda la carpeta `FastFoodControl\FastFoodControl\` generada en:
   `C:\Users\USER\.gemini\antigravity\scratch\FastFoodControl\FastFoodControl`
   hacia tu Mac (por USB, Google Drive o Git).
2. En el navegador izquierdo de Xcode (**Project Navigator**):
   - Arrastra las carpetas **`App`**, **`Data`**, **`Extensions`**, **`Models`**, **`Services`**, **`Utilities`**, **`ViewModels`**, **`Views`** y **`ViewControllers`** dentro de la carpeta azul de tu proyecto.
   - En la ventana emergente de Xcode:
     - Marca **Copy items if needed** (Copiar elementos si es necesario).
     - Selecciona **Create groups**.
     - Verifica que esté marcado tu **Target** (`FastFoodControl`).
3. **Evitar duplicados (¡ANTES de arrastrar!):** Primero elimina (**Move to Trash**) el `AppDelegate.swift` y `SceneDelegate.swift` de la plantilla que están **sueltos** en la raíz del proyecto. Recién después arrastra las carpetas. **Nunca borres los archivos dentro de la carpeta `App/`**: son los únicos `AppDelegate` y `SceneDelegate` de la app.
   - Si aparece el error *"Cannot find 'SceneDelegate' in scope"* o la app abre en negro: selecciona `App/AppDelegate` y `App/SceneDelegate` → panel derecho → **Target Membership** → marca tu target.
   - Si Xcode crea copias como `Info 2` o `Base 2.lproj`, elimínalas.
4. Reemplaza el contenido de **`Info.plist`** (o agrega en el *Info* del Target las claves `NSLocationWhenInUseUsageDescription` y `NSAppTransportSecurity -> Allow Arbitrary Loads = YES`).

---

## Paso 3: Configurar `FastFoodControl.xcdatamodeld` en Xcode (Recomendado)
Aunque `CoreDataManager.swift` crea el esquema Core Data automáticamente en memoria si no encuentra el `.momd` compilado, incluir el archivo visual `Data/FastFoodControl.xcdatamodeld` en tu Target de Xcode te permite mostrar las entidades **visualmente** durante tu sustentación ante el profesor:
1. Asegúrate de que `FastFoodControl.xcdatamodeld` aparezca en el navegador izquierdo de Xcode.
2. Haz clic en él para mostrar el diagrama de entidades **`ComandaEntity`** e **`InsumoEntity`** en tu video Demo Reel y exposición.
3. En el panel derecho (*File Inspector*), verifica que **Target Membership** esté marcado para `FastFoodControl`.

---

## Paso 4: Verificar compilación y probar en el Simulador iPhone
Presiona **`Cmd + R`** en Xcode. El flujo de prueba completo para tu sustentación es:

1. **Splash & Login de Turno:**
   - Aparece `SplashViewController` con animación y pasa a `LoginViewController`.
   - Ingresa un nombre y PIN (ya vienen precargados por defecto) y presiona **Iniciar Turno Operativo**.
2. **Pestaña 1 — Cocina KDS (Core Data CRUD + UserNotifications):**
   - Visualiza los KPIs superiores (*Pendientes, En Cocina, Listas*).
   - Toca **Iniciar Cocina** en una comanda: el estado cambia en Core Data y en **5 segundos** aparecerá una notificación nativa arriba (*UserNotifications*).
   - Toca el botón **`+`** arriba a la derecha para registrar una nueva comanda en Core Data.
   - Desliza una fila hacia la izquierda (*Swipe to delete*) para eliminarla de Core Data.
   - Toca cualquier comanda para ver **`ComandaDetailViewController`** con el **Ticket QR generado con `CoreImage`**.
   - Cierra y vuelve a abrir la app para demostrar al profesor que los datos persisten en **Core Data**.
3. **Pestaña 2 — Recetario REST (`URLSession` + `Codable`):**
   - Muestra las recetas reales descargadas desde `dummyjson.com/recipes` y `themealdb.com`.
   - Usa la barra de búsqueda y las píldoras horizontales de categoría (*Burgers, Pizzas, Pollo Crispy, Wraps*).
   - Toca cualquier plato para ver ingredientes y pasos de cocina, y presiona **Generar Comanda en Cocina (Core Data)** para enviar la receta al tablero KDS.
4. **Pestaña 3 — Insumos y Mermas (Core Data + Alertas Críticas):**
   - Revisa la barra de progreso de cada ingrediente y su merma acumulada.
   - Presiona **`- Merma`** en un insumo hasta bajar de su stock mínimo para comprobar la alerta de **Stock Crítico** vía `UserNotifications`.
5. **Pestaña 4 — Sedes Mapa (`MapKit` + `CoreLocation`):**
   - Explora las 5 sedes operativas en Lima con pines rojos personalizados (`MKMarkerAnnotationView`), carga de comandas activas y cálculo de distancia en kilómetros.
   - *(Tip en Simulador Xcode)*: En el menú superior del Mac ve a **Features → Location → Custom Location...** e ingresa `-12.1211`, `-77.0293` (Miraflores, Lima) para que el punto azul del usuario aparezca en Lima.
