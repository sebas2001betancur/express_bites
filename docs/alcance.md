# Especificaciones del proyecto: ExpressBites (Pick & Go)

## Problema

En universidades o edificios corporativos los estudiantes, docentes y trabajadores pueden disponer de ventanas de tiempo reducidas y estrictas (descansos de 15 a 30 minutos o lapsos breves entre clases y actividades laborales). Durante las horas de mayor afluencia en establecimientos de comida y cafeterías universitarias o corporativas (8:00 a.m. a 11:00 a.m. y 12:00 m. a 2:00 p.m.), una persona debe hacer filas presenciales de 15 a 20 minutos solo para ordenar en caja y esperar el turno de preparación de sus alimentos.

Hoy en día, el usuario se ve obligado a perder la totalidad de su tiempo de descanso en la fila o en la espera de su alimento, llegar tarde a sus compromisos o resignarse a comprar productos ultraprocesados en cafeterías o máquinas expendedoras. Por su parte, el personal del mostrador y cocina enfrenta picos excesivos de estrés, congestión en barra, y frecuentes errores al tomar pedidos personalizados de forma verbal, generando retrasos y mermas sin posibilidad de prever la demanda anticipada.

---

## Stakeholders

* **El cliente (estudiante / docente / oficinista):** Interesado en optimizar al máximo su tiempo libre, evitar filas y tiempos de espera, recibir su pedido recién preparado y asegurar que sus personalizaciones alimenticias se cumplan con exactitud (como lo haría pidiendo en persona).
* **El personal de cocina:** No operan la app del cliente, pero se benefician directamente de recibir comandas secuenciadas con antelación, reduciendo el caos en horas pico.
* **El cajero y personal de entrega en mostrador:** Interesados en descongestionar la fila física, validar rápidamente las entregas mediante códigos únicos y minimizar confusiones en caja.
* **La administración de la cafetería:** Interesada en elevar el flujo de atención por minuto, incrementar las ventas totales al capturar clientes que antes evitaban comprar por la fila y mejorar la fidelización.

---

## Actores

* **Cliente (Actor Principal):** Usuario final que interactúa directamente con la aplicación móvil Flutter para explorar categorías, configurar productos, agendar la hora de recogida, confirmar el pedido y presentar su ticket digital.
* **Personal de Caja / Despachador en Barra (Actor Operativo):** Usuario/rol del establecimiento que interactúa con el sistema para consultar los pedidos entrantes programados, validar el identificador único (**Claim ID**) o código del ticket que presenta el cliente en el mostrador y gestionar la entrega del pedido finalizado.
* **Gestor de Estado Local / Reactivo (Riverpod):** Subsistema dentro de la aplicación móvil encargado del flujo de estado desacoplado, computación dinámica del carrito y sincronización de estados asíncronos.
* **Servicio Backend / Persistencia en la Nube (Sistema Externo):** Plataforma backend (Firebase Firestore / Auth o API REST) que almacena el catálogo centralizado y registra las órdenes emitidas.
* **Motor de Almacenamiento Local (Sistema Local):** Base de datos embebida (*Hive* / *shared_preferences*) encargada de persistir el ticket activo del pedido y la caché del catálogo para disponibilidad offline.

---

## Objetivo y métricas de éxito

**Objetivo:** Permitir que un cliente explore el catálogo de la cafetería, personalice los ingredientes de sus productos, programe una franja de recogida y genere su ticket digital con código único en menos de 2 minutos desde su celular, reduciendo el tiempo de espera físico en el establecimiento a menos de 1 minuto.

| Métrica | Situación Actual | Objetivo del Proyecto |
|---|---|---|
| **Tiempo total de orden y recogida** | 15 a 20 minutos (fila física en caja + espera de preparación) | Menos de 2 min en la app + entrega inmediata (menor a 1 min en mostrador) |
| **Tasa de error en pedidos personalizados** | Alta (confusiones verbales por ruido ambiental y prisa en caja) | Baja (la app deja las especificaciones claras) |
| **Previsibilidad del tiempo de descanso** | Nula (sujeta a la longitud aleatoria de la fila física) | 99% predecible (franja horaria de entrega seleccionada por el usuario) |

---

## Restricciones

### Fijas e innegociables

* **Tecnología:** Desarrollo exclusivo en Flutter y lenguaje Dart.
* **Gestión de Estado:** Implementación obligatoria mediante **Riverpod** (`flutter_riverpod` / `hooks_riverpod`).
* **Tiempo:** 17 semanas académicas del curso semestral.
* **Equipo de desarrollo:** Grupos de trabajo de 3 integrantes.

### Técnicas y de negocio

* **Pagos:** Sin integración de pasarelas de pago bancario real en esta etapa; el checkout se maneja de forma simulada con validación o pago presencial contra ticket.
* **Conectividad:** La aplicación debe permitir la lectura del ticket activo del pedido y del catálogo previo en caché ante caídas de red o falta de datos móviles.
* **Plataforma objetivo:** Dispositivos móviles (smartphones Android). No entra iOS.

---

## Alcance

### Incluye

* Catálogo visual categorizado (Bebidas calientes/frías, Repostería, Combos, Especiales del día).
* Modificador y personalizador de productos interactivo (tamaños, tipo de leche, endulzantes, agregados y notas) con actualización reactiva inmediata de precio vía Riverpod.
* Carrito de compras reactivo con modificación de cantidades y desglose de subtotales.
* Selector programable de franja horaria de recogida (*Pick & Go Slots*: "En 15 minutos", "En 30 minutos", o selección de hora específica).
* Checkout simulado con generación de **Ticket Digital** (ID único de reclamo alfanumérico/QR y resumen detallado).
* Persistencia local del **Ticket Digital activo** para consulta y visualización garantizada sin conexión a internet.

### No incluye

* Pasarelas de pago bancarias con dinero real (PSE, Stripe, tarjetas de crédito).
* Servicios de delivery o geolocalización de repartidores (el modelo es exclusivamente *Pick & Go* presencial en punto).
* Módulo de chat en vivo con cocina.
* Panel administrativo web completo para gestión de inventarios (la app se centra en la parte del cliente, no se enfocará a la vista del local).

---

## Conceptos del dominio

* **Cliente:** Persona que realiza un pedido programado desde su dispositivo móvil.
* **Producto:** Alimento o bebida disponible en el menú de la cafetería.
* **Categoría:** Agrupación taxonómica de los productos (ej. Bebidas, Repostería, Desayunos).
* **Variante / Modificador:** Opción de configuración de un producto (tamaño, tipo de leche, adición de shot de café) que altera su composición y/o su precio.
* **Carrito de Compra:** Estructura temporal que almacena los productos configurados antes de la confirmación final.
* **Franja de Recogida:** Hora programada por el cliente para presentarse a retirar su pedido.
* **Ticket Digital:** Documento electrónico emitido tras la confirmación, identificado con un código único irrepetible, fecha, hora programada, desglose de ítems y estado.
* **Ejemplo de flujo:** Un **Cliente** selecciona y personaliza **Productos** pertenecientes a una **Categoría** agregando **Variantes** según sus preferencias, los reúne en el **Carrito**, define una **Franja de Recogida** y confirma la orden para generar un **Ticket Digital** para reclamar su pedido.

---

## Reglas de negocio

* **RN-01.** Un producto con opciones obligatorias (ej. tamaño o presentación) no puede agregarse al carrito sin que el usuario haya seleccionado una alternativa válida.
* **RN-02.** Cualquier modificación o adición seleccionada debe recalcular y reflejar el costo total del producto en pantalla de forma instantánea (por ejemplo, leche normal, deslactosada o de almendras).
* **RN-03.** El usuario no puede avanzar a la programación de recogida ni confirmar una orden si el carrito se encuentra vacío.
* **RN-04.** La hora de recogida programada debe ser estrictamente posterior a la hora actual más el margen mínimo de preparación del local (mínimo 15 minutos en el futuro).
* **RN-05.** Todo pedido confirmado debe generar un identificador alfanumérico irrepetible (**Claim ID**) para que el mostrador valide y despache la comanda sin duplicidades.

---

## Historias de usuario

### HU-01: Exploración del menú por categorías

* **Como** cliente con poco tiempo disponible,  
* **Quiero** filtrar los alimentos y bebidas por categorías visuales claras,  
* **Para** encontrar de forma rápida lo que deseo consumir sin revisar listas largas.  
* **Criterios de aceptación:**
  * La pantalla principal muestra selector de categorías dinámico.
  * Al seleccionar una categoría, los productos se filtran instantáneamente.
  * Cada tarjeta de producto muestra nombre, foto referencial y precio base.

### HU-02: Personalización de producto con cálculo reactivo

* **Como** cliente con preferencias y restricciones alimentarias específicas,  
* **Quiero** elegir variantes (tipo de leche, tamaño, toppings y agregados),  
* **Para** armar mi producto a la medida y conocer el costo exacto antes de ordenar.  
* **Criterios de aceptación:**
  * Al marcar un ingrediente adicional con costo, el precio mostrado en el botón de agregar se actualiza en tiempo real.
  * Los modificadores obligatorios son validados antes de permitir la inserción en el carrito.

### HU-03: Programación de hora de recogida (*Pick & Go*)

* **Como** estudiante con horarios ajustados de clase,  
* **Quiero** definir la hora exacta en la que pasaré por mi pedido a la cafetería,  
* **Para** asegurar que mi comida esté lista al llegar y no perder mi tiempo de descanso.  
* **Criterios de aceptación:**
  * Se ofrecen atajos inmediatos ("En 15 min", "En 30 min") y un selector de hora fija.
  * El sistema no permite programar horas pasadas o con un margen inferior a 15 minutos.

### HU-04: Generación y visualización del Ticket Digital

* **Como** cliente que ha confirmado su orden de compra,  
* **Quiero** recibir un ticket digital con código único de reclamo y resumen del pedido,  
* **Para** presentarlo en la barra de despacho al momento de retirar mis alimentos.  
* **Criterios de aceptación:**
  * La pantalla final muestra el código alfanumérico en tipografía grande y legible.
  * El ticket queda registrado localmente para que el cliente pueda abrirlo y mostrarlo sin depender de conexión a internet.

### HU-05: Gestión de pedidos entrantes por franja horaria (Personal del local)

* **Como** personal del local / despachador en barra,  
* **Quiero** visualizar los pedidos programados organizados cronológicamente por su franja de recogida,  
* **Para** saber qué alimentos cocinar primero y tenerlos listos justo a tiempo para la llegada del cliente.  
* **Criterios de aceptación:**
  * La lista presenta las comandas agrupadas por horario de recogida.
  * Cada comanda especifica el detalle de variantes, notas de preparación y estado actual.
  * Permite actualizar el estado de la comanda a "Listo para recogida".

### HU-06: Verificación de ticket y entrega de pedido (Personal del local)

* **Como** personal de barra / despachador en mostrador,  
* **Quiero** validar el código de reclamo del ticket presentado por el cliente,  
* **Para** entregar los productos exactos a la persona correcta y finalizar la orden.  
* **Criterios de aceptación:**
  * Permite cotejar el código del ticket presentado por el cliente contra las órdenes activas.
  * Al confirmar la entrega, la orden cambia a estado "Entregado" y queda inhabilitada para nuevos reclamos.

### HU-07: Consulta del ticket activo sin conexión (Modo offline)

* **Como** cliente que realizó un pedido en la oficina o salón,  
* **Quiero** visualizar mi ticket de pedido actual en cualquier momento sin depender de datos móviles o conexión a internet,  
* **Para** poder mostrarlo en la barra al recoger mi orden y evitar contratiempos o errores.  
* **Criterios de aceptación:**
  * La aplicación permite abrir y consultar el ticket del pedido en curso sin acceso a red.
  * Muestra el código de reclamo (**Claim ID**), la franja horaria, el desglose de productos y el total.
  * Lee la información directamente desde el almacenamiento local (*Hive* / *shared_preferences*).

---

## Casos de uso

### Caso de uso: Explorar menú y filtrar por categorías

* **Actor.** Cliente.
* **Precondición.** El cliente tiene abierta la pantalla principal de la aplicación.
* **Flujo principal.**
  1. El cliente selecciona una categoría del catálogo (ej. Bebidas, Repostería, Combos).
  2. La aplicación filtra los productos correspondientes a la categoría seleccionada.
  3. La aplicación presenta la lista de productos disponibles con su nombre, imagen y precio base.
* **Excepción.** Si la categoría no contiene productos activos en el momento, la aplicación muestra un aviso indicando que no hay productos disponibles en esa sección.

### Caso de uso: Personalizar un producto

* **Actor.** Cliente.
* **Precondición.** El cliente seleccionó un producto del catálogo.
* **Flujo principal.**
  1. El cliente elige las opciones deseadas (tamaño, tipo de leche, agregados o notas especiales).
  2. La aplicación actualiza reactivamente el costo total del producto en pantalla con Riverpod.
  3. El cliente presiona el botón para añadir el ítem al carrito.
  4. La aplicación guarda el producto con sus personalizaciones en el carrito de compras.
* **Excepción.** Si falta una opción obligatoria por seleccionar, la aplicación no permite agregar el producto y resalta la opción requerida.

### Caso de uso: Programar franja horaria de recogida

* **Actor.** Cliente.
* **Precondición.** El cliente tiene al menos un producto en el carrito de compras.
* **Flujo principal.**
  1. El cliente ingresa a la pantalla del carrito de compras.
  2. El cliente selecciona una franja horaria ("En 15 min", "En 30 min" o selector de hora específica).
  3. La aplicación valida que el horario cumpla con el tiempo mínimo de preparación y lo asocia al pedido.
* **Excepción.** Si el cliente selecciona una hora anterior a la hora actual más el margen de 15 minutos, la aplicación muestra una advertencia y solicita un horario válido.

### Caso de uso: Confirmar pedido y generar ticket digital

* **Actor.** Cliente.
* **Precondición.** El cliente tiene productos en el carrito y definió una franja horaria válida.
* **Flujo principal.**
  1. El cliente presiona el botón de confirmación de pedido.
  2. La aplicación envía la comanda al backend y genera un código único de reclamo (**Claim ID**).
  3. La aplicación guarda el ticket generado en el almacenamiento local del dispositivo.
  4. La aplicación muestra la pantalla de confirmación con el ticket digital activo.
* **Excepción.** Si ocurre un error de comunicación con el backend, la aplicación notifica el fallo y mantiene los productos en el carrito para reintentar la confirmación.

### Caso de uso: Consultar y gestionar pedidos programados por horario

* **Actor.** Personal del local / Despachador en barra.
* **Precondición.** El personal se encuentra en el módulo de recepción de comandas del establecimiento.
* **Flujo principal.**
  1. El personal consulta la lista de pedidos activos organizados por franja horaria de recogida.
  2. El personal revisa el detalle de personalizaciones y coordina los tiempos de preparación con cocina.
  3. El personal cambia el estado de la comanda a "Listo para recogida" cuando el pedido está empaquetado.
* **Excepción.** Si un pedido no se reclama pasado el tiempo límite de su franja horaria, el sistema permite marcarlo como comanda en espera o retrasada.

### Caso de uso: Validar ticket y despachar pedido en mostrador

* **Actor.** Personal del local / Despachador en barra.
* **Precondición.** El cliente presenta el código de su ticket digital en el punto de entrega.
* **Flujo principal.**
  1. El despachador consulta el código de reclamo (**Claim ID**) presentado por el cliente.
  2. El sistema valida la existencia de la orden y muestra el detalle de los productos empaquetados.
  3. El despachador entrega el pedido físico al cliente.
  4. El despachador marca el ticket como "Entregado" en el sistema.
* **Excepción.** Si el código ingresado no existe o el ticket ya fue marcado como "Entregado" previamente, el sistema emite una alerta impidiendo el doble despacho.

### Caso de uso: Consultar ticket activo sin conexión

* **Actor.** Cliente.
* **Precondición.** El cliente ha confirmado un pedido y el ticket se encuentra guardado en el dispositivo.
* **Flujo principal.**
  1. El cliente abre la aplicación o accede a la sección de su ticket de pedido (sin conexión a internet o datos).
  2. La aplicación lee los datos del ticket activo desde el almacenamiento local (*Hive* / *shared_preferences*).
  3. La aplicación muestra el ticket con su código de reclamo (**Claim ID**), hora programada, desglose del pedido y estado actual.
* **Excepción.** Si no existe ningún ticket de pedido activo almacenado en el dispositivo, la aplicación muestra una pantalla indicando que no hay órdenes en curso.

---

## Flujo de pantallas

```
[ 1. Home / Catálogo ]
       │
       ├──► [ 2. Detalle y Personalización de Producto ]
       │            │
       │            └── (Agrega con Riverpod y regresa al catálogo)
       │
       ├──► [ 3. Carrito de Compras & Selección de Franja ]
       │            │
       │            └──► [ 4. Confirmación & Ticket Digital Activo ]
       │                         │
       │                         └── (Volver al Inicio)
       │
       └──► [ 5. Visualización de Ticket Activo (Offline) ]
```

1. **Pantalla Principal (Home / Catálogo):** Header con buscador y badge reactivo del carrito; carrusel horizontal de categorías; grid de productos con imagen, título y precio base; acceso directo al ticket activo.
2. **Pantalla de Detalle y Personalización:** Fotografía ampliada, selección de opciones (radio buttons para variantes únicas, chips para adiciones) y barra inferior fija con precio total calculado en tiempo real.
3. **Pantalla de Carrito de Compras:** Lista de ítems con botones (+ / -), campo de notas, selector de horario de recogida (*Time Slots*) y botón de confirmación (*Checkout*).
4. **Pantalla de Ticket Digital:** Tarjeta central destacada con código alfanumérico/QR de reclamo, hora pactada de entrega, estado ("En preparación" / "Listo") y desglose.
5. **Pantalla de Ticket Activo (Offline):** Vista accesible sin conexión que carga desde la persistencia local (*Hive* / *shared_preferences*) el ticket del pedido en curso para mostrarlo en el mostrador.

---

## Propuestas de diseño y mockups

### Lineamientos UI/UX

* **Paleta de Color:**
  * Primario: Terracota / Naranja cálido (`#E65100` / `#FF6F00`), estimulante del apetito y asociado a dinamismo y servicio rápido.
  * Fondos y Neutros: Tonos arena claro y blanco pulcro (`#FAFAFA`, `#FFFFFF`) con tarjetas en relieve suave (`#F5F5F5`).
  * Textos y Contrastes: Gris grafito oscuro (`#1F2937`) para alta legibilidad bajo luz natural.
* **Ergonomía Móvil:**
  * Uso de *Sticky Bottom Action Bars* para botones de agregar y confirmar pedido, accesibles al pulgar con una sola mano.
* **Feedback Visual y Microinteracciones:**
  * Transiciones reactivas inmediatas en el contador del carrito al interactuar con Riverpod.
  * Animación de confirmación exitosa al generar el Ticket Digital.
  * Indicador sutil de modo sin conexión en la vista del ticket activo.

---

## Ficha Técnica y Arquitectura de Estado (Riverpod)

| Componente | Tecnología Seleccionada | Justificación Técnica |
|---|---|---|
| **Frontend Framework** | Flutter & Dart | Desarrollo multiplataforma nativo con alto rendimiento de renderizado. |
| **Gestión de Estado** | **Riverpod (StateNotifier / NotifierProvider)** | Gestión de estado reactiva, inmutable, testeable, sin dependencia directa del `BuildContext` y libre de errores de Provider clásico. |
| **Persistencia / Backend** | Firebase (Firestore + Auth) / REST API | Sincronización en tiempo real del catálogo de productos y comandas. |
| **Almacenamiento Local** | Hive / shared_preferences | Persistencia ultrarrápida key-value del ticket activo accesible sin conexión. |

### Arquitectura de Providers en Riverpod

* `catalogProvider`: Maneja la lista de categorías y productos cargados desde el backend/caché.
* `productCustomizationProvider`: Maneja el estado temporal de variantes y agregados del ítem seleccionado, calculando el precio en tiempo real.
* `cartNotifierProvider`: Maneja la lista inmutable de productos agregados al carrito, sumatoria de totales y franja horaria elegida.
* `activeTicketLocalProvider`: Maneja la persistencia y lectura del ticket de pedido activo guardado en el almacenamiento local para consulta offline inmediata.
