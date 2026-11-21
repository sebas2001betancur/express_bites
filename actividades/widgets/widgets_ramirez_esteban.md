# Investigación de widgets de Flutter

**Nombre del estudiante:** Esteban Ramirez
**Grupo:** 601
**Fecha:** 17 de octubre de 2026

**Mis widgets:** LinearProgressIndicator, ChoiceChip, AnimatedContainer

## 1. LinearProgressIndicator

### Qué es y para qué sirve

Es una barra horizontal que muestra el avance de una tarea. Tiene dos modos:

- **Determinado:** cuando le doy un value entre 0.0 y 1.0, la barra se llena hasta ese porcentaje
- **Indeterminado:** si no le doy value (o le paso null), la barra se mueve sin parar. 

Resuelve el problema de que el usuario no sepa si la app está trabajando o se quedó pegada. Sin este widget tendría que construir la barra a mano con un Container y calcular los anchos manualmente.

### Cuándo usarlo y cuándo no

- **Usarlo:** cuando quiero mostrar el avance de un proceso con pasos o porcentaje, como el estado de un pedido o una carga de datos
- **No usarlo:** cuando el espacio es pequeño o cuadrado, por ejemplo dentro de un botón o en el centro de una pantalla de carga

### Ejemplo mínimo

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatelessWidget {
  const Prueba({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: LinearProgressIndicator(value: 0.6),
        ),
      ),
    );
  }
}
```

### Explicación del ejemplo

- LinearProgressIndicator(value: 0.6) dibuja la barra llena al 60 %. Es lo único que se necesita para que funcione.
- La barra ocupa todo el ancho disponible, por eso la metí en un Padding de 24 para que no quede pegada a los bordes.
- Es un StatelessWidget porque el valor no cambia. Si borro value, la barra pasa a modo indeterminado y se queda animándose.

### Propiedades importantes

| Propiedad | Qué hace | Ejemplo de valor |
|---|---|---|
| value | Cuánto está lleno, de 0.0 a 1.0. Si es null, la barra se anima sin parar (indeterminada). | 0.6 |
| minHeight | El grosor de la barra en píxeles. Por defecto es 4. | 14 |
| color | El color de la parte llena. | Colors.green |
| backgroundColor | El color de la parte que falta por llenar. | Colors.green.shade100 |
| borderRadius | Redondea los bordes de la barra. | BorderRadius.circular(8) |

### Ejemplo personalizado

Simula el seguimiento de un pedido del mercado. Cada vez que se pulsa el botón, el pedido pasa a la siguiente etapa y la barra avanza un 25 %. Al llegar a "Entregado" vuelve a empezar.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  // Cada etapa del pedido suma un 25 % a la barra.
  final List<String> etapas = [
    'Pedido recibido',
    'Alistando productos',
    'En camino',
    'Entregado',
  ];
  double progreso = 0.25;

  void avanzar() {
    setState(() {
      progreso = progreso >= 1.0 ? 0.25 : progreso + 0.25;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int etapa = (progreso * 4).round() - 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                etapas[etapa],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progreso,
                minHeight: 14,
                color: Colors.green,
                backgroundColor: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 8),
              Text('${(progreso * 100).round()} %'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: avanzar,
                child: const Text('Avanzar pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Dónde lo usarías en Mercado Campesino

En la pantalla de **seguimiento del pedido**, después de pagar el carrito. El cliente ve en qué etapa va su compra (recibido, alistando, en camino, entregado), con la barra llenándose en cada paso. También usaría la versión indeterminada debajo del AppBar mientras se carga la lista de productos del mercado, porque ahí no se sabe cuánto va a tardar.

### Fuentes y ayudas usadas

- Documentación oficial: <https://api.flutter.dev/flutter/material/LinearProgressIndicator-class.html>
- Catálogo de widgets: <https://docs.flutter.dev/ui/widgets>
- DartPad (<https://dartpad.dev>) para ejecutar y modificar los ejemplos.
- IA: usé Claude como facilitador de ejemplos claros y explicación más detallada del widget con sus propiedades y usos.

---

## 2. ChoiceChip

### Qué es y para qué sirve

Es una "pastilla" con texto que se puede marcar o desmarcar. Se usa en grupo para que el usuario elija **una sola opción** entre varias. Por ejemplo, la categoría de productos que quiere ver.

El chip por sí solo no recuerda si está seleccionado. Yo le digo si lo está con selected, y cuando el usuario lo toca se llama onSelected, donde actualizo mi variable con setState. Resuelve el problema de mostrar opciones cortas de forma compacta y visual, sin abrir un menú.

### Cuándo usarlo y cuándo no

- **Usarlo:** cuando hay pocas opciones cortas, se elige solo una y quiero que todas se vean a la vez, como un filtro de categorías.
- **No usarlo:**
  - Si el usuario puede marcar **varias** opciones a la vez.
  - Si hay muchas opciones 
  - Para un simple sí/no.

### Ejemplo mínimo

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  bool seleccionado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: Center(
        child: ChoiceChip(
          label: const Text('Frutas'),
          selected: seleccionado,
          onSelected: (valor) {
            setState(() {
              seleccionado = valor;
            });
          },
        ),
      ),
    );
  }
}
```

### Explicación del ejemplo

- Es un StatefulWidget porque necesito guardar si el chip está marcado o no, en la variable seleccionado.
- label es el texto que se ve en el chip.
- selected: seleccionado le dice al chip cómo debe verse: marcado o sin marcar.
- onSelected se ejecuta al tocar el chip y recibe el nuevo valor (true o false). Dentro hago setState para guardar el valor y redibujar la pantalla.
- Si quito el setState, el chip no cambia al tocarlo, porque la variable nunca se actualiza. Si quito onSelected, el chip queda deshabilitado (gris).

### Propiedades importantes

| Propiedad | Qué hace | Ejemplo de valor |
|---|---|---|
| label | El contenido del chip, normalmente un Text. Es obligatorio. | Text('Frutas') |
| selected | Si el chip se ve marcado o no. Es obligatorio. | seleccionada == 'Frutas' |
| onSelected | Función que se llama al tocarlo. Si es null, el chip queda deshabilitado. | (valor) { setState(...); } |
| selectedColor | Color de fondo cuando está marcado. | Colors.green.shade300 |
| showCheckmark | Si muestra el ✓ al estar marcado. Por defecto es true. | false |
| avatar | Un ícono o imagen pequeña a la izquierda del texto. | Icon(Icons.eco) |

### Ejemplo personalizado

Un filtro de categorías del mercado. Solo puede haber una categoría elegida, y el texto de abajo muestra cuál es.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  final List<String> categorias = [
    'Todas',
    'Frutas',
    'Verduras',
    'Lácteos',
    'Granos',
  ];
  String seleccionada = 'Todas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categorias.map((categoria) {
                  return ChoiceChip(
                    label: Text(categoria),
                    avatar: const Icon(Icons.eco),
                    selected: seleccionada == categoria,
                    onSelected: (_) {
                      setState(() {
                        seleccionada = categoria;
                      });
                    },
                    selectedColor: Colors.green.shade300,
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                'Mostrando: $seleccionada',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Aquí ya no guardo un bool por chip, sino un solo String con la categoría elegida. Cada chip está marcado si seleccionada == categoria. Así es imposible que haya dos marcados a la vez. Uso Wrap para que los chips pasen a la siguiente línea si no caben.

### Dónde lo usarías en Mercado Campesino

En la **pantalla de la lista de productos**, arriba, como filtro de categorías (Todas, Frutas, Verduras, Lácteos, Granos). Al tocar una categoría, la lista muestra solo esos productos. Encaja con ChoiceChip porque se ve una categoría a la vez y son pocas opciones cortas.

### Fuentes y ayudas usadas

- Documentación oficial: <https://api.flutter.dev/flutter/material/ChoiceChip-class.html>
- Comparación con FilterChip: <https://api.flutter.dev/flutter/material/FilterChip-class.html>
- DartPad (<https://dartpad.dev>) para ejecutar y modificar los ejemplos.
- IA: usé Claude como facilitador de ejemplos claros y explicación más detallada del widget con sus propiedades y usos.

---

## 3. AnimatedContainer

### Qué es y para qué sirve

Es un Container que se anima solo. Cuando cambio alguna de sus propiedades (ancho, alto, color, bordes, padding…) y hago setState, no salta de golpe al valor nuevo: pasa poco a poco del valor viejo al nuevo durante el tiempo que yo indique en duration.

Resuelve el problema de hacer animaciones simples sin tener que crear un AnimationController, que es más complicado. Yo solo digo cómo quiero que se vea al final, y Flutter se encarga de animar el cambio.

### Cuándo usarlo y cuándo no

- **Usarlo:** para cambios de tamaño, color o forma que pasan como respuesta a una acción del usuario. Por ejemplo, resaltar una tarjeta cuando se agrega al carrito.
- **No usarlo:**
  - Si solo quiero que algo aparezca o desaparezca suavemente, es más directo AnimatedOpacity.
  - Si la animación debe repetirse sola sin parar (como un ícono latiendo), necesito un AnimationController, porque AnimatedContainer solo se anima cuando cambia un valor.
  - Si no hace falta animar nada, un Container normal basta.

### Ejemplo mínimo

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  bool grande = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          width: grande ? 200 : 100,
          height: grande ? 200 : 100,
          color: grande ? Colors.green : Colors.orange,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            grande = !grande;
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
```

### Explicación del ejemplo

- La variable grande decide cómo se ve el cuadro: 100×100 naranja o 200×200 verde.
- El botón flotante invierte grande dentro de setState, lo que hace que la pantalla se redibuje con los valores nuevos.
- Como es AnimatedContainer y no Container, el cambio de tamaño y de color dura 1 segundo (duration) en vez de ser instantáneo.
- duration es obligatoria: sin ella el código no compila.

### Propiedades importantes

| Propiedad | Qué hace | Ejemplo de valor |
|---|---|---|
| duration | Cuánto tarda la animación. Es obligatoria. | Duration(milliseconds: 600) |
| curve | La "forma" de la animación: constante, que frena al final, que rebota… Por defecto es Curves.linear. | Curves.easeInOut, Curves.bounceOut |
| width / height | Tamaño del contenedor. Al cambiarlos se anima el crecimiento. | grande ? 200 : 100 |
| color | Color de fondo. No se puede usar junto con decoration. | Colors.orange |
| decoration | Fondo más completo: color, bordes, esquinas redondeadas, sombra. Todo eso también se anima. | BoxDecoration(borderRadius: BorderRadius.circular(24)) |
| padding | Espacio interno. También se anima. | EdgeInsets.all(24) |

### Ejemplo personalizado

Una tarjeta de producto del mercado. Al pulsar "Agregar al carrito", la tarjeta se hace más ancha, se pone verde, redondea sus esquinas y cambia el ícono. Todo animado en 0,6 segundos con una curva suave.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  bool enCarrito = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          width: enCarrito ? 280 : 220,
          padding: EdgeInsets.all(enCarrito ? 24 : 12),
          decoration: BoxDecoration(
            color: enCarrito ? Colors.green.shade100 : Colors.white,
            border: Border.all(
              color: enCarrito ? Colors.green : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(enCarrito ? 24 : 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                enCarrito ? Icons.check_circle : Icons.shopping_basket,
                size: 48,
                color: Colors.green,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tomate chonto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text('\$3.500 la libra'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    enCarrito = !enCarrito;
                  });
                },
                child: Text(
                  enCarrito ? 'Quitar del carrito' : 'Agregar al carrito',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Aquí uso decoration en lugar de color, porque quiero también borde y esquinas redondeadas. El color va dentro del BoxDecoration. Si pusiera color y decoration al mismo tiempo, Flutter lanza un error. El ícono cambia de golpe (no está animado) porque es un Icon normal: solo se animan las propiedades del AnimatedContainer.

### Dónde lo usarías en Mercado Campesino

En la **tarjeta de cada producto** de la lista o en la pantalla de **detalle del producto**. Cuando el usuario pulsa "Agregar al carrito", la tarjeta cambia de color y forma con una animación corta. Así el usuario confirma que su acción funcionó, sin necesidad de un mensaje aparte.

### Fuentes y ayudas usadas

- Documentación oficial: <https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html>
- Guía de animaciones implícitas: <https://docs.flutter.dev/ui/animations/implicit-animations>
- Curvas disponibles: <https://api.flutter.dev/flutter/animation/Curves-class.html>
- DartPad (<https://dartpad.dev>) para ejecutar y modificar los ejemplos.
- IA: usé Claude como facilitador de ejemplos claros y explicación más detallada del widget con sus propiedades y usos.
