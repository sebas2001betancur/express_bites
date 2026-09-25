## Ficha Técnica y Arquitectura de Navegación

**Stack tecnológico:** Flutter y Dart. Sin paquetes de manejo de estado ni de
navegación — solo el SDK de Flutter.

**Manejo de estado:** Cada pantalla que necesita recordar algo (la categoría
filtrada, el carrito, la hora elegida) lo hace con su propio `StatefulWidget` y
`setState`. No hay un estado global ni un árbol de providers: los datos que una
pantalla necesita de otra se pasan como parámetros del constructor al navegar
hacia adelante, y como valor de retorno al hacer `Navigator.pop()` hacia atrás.

**Navegación:** Todas las transiciones usan `Navigator.push` (para avanzar) y
`Navigator.pop` (para volver), con `MaterialPageRoute`. No se usan rutas
nombradas ni paquetes de navegación.

| De → A | Qué viaja | Cómo |
|---|---|---|
| Catálogo → Detalle | El `Producto` tocado | Parámetro del constructor |
| Detalle → Catálogo | El `Producto` personalizado (tamaño y extras ya aplicados al precio) | Valor de retorno de `Navigator.pop(context, producto)` |
| Catálogo → Carrito | La lista de productos agregados | Parámetro del constructor |
| Carrito → Catálogo | Confirmación (`true`) de que el pedido se envió, para vaciar el carrito | Valor de retorno de `Navigator.pop(context, true)` |
| Carrito → Ticket digital | Claim ID, franja de recogida y total | Parámetros del constructor |