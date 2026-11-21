import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/failures/falla.dart';

const recargoTamano = {'Pequeño': 0, 'Mediano': 1000, 'Grande': 2000};
const recargoLeche = {'Entera': 0, 'Deslactosada': 500, 'Almendras': 1000};
const recargoExtra = {'Extra de café': 1500, 'Canela': 500};

class ItemPedido {
  const ItemPedido({
    required this.productoId,
    required this.nombre,
    required this.tamano,
    this.leche,
    this.extras = const [],
    this.notas = '',
    required this.precioUnitario,
    this.cantidad = 1,
  });

  final String productoId;
  final String nombre;
  final String tamano;
  final String? leche;
  final List<String> extras;
  final String notas;
  final int precioUnitario;
  final int cantidad;

  int get subtotal => precioUnitario * cantidad;

  String get descripcion =>
      [tamano, if (leche != null) 'leche $leche', ...extras].join(', ');

  ItemPedido conCantidad(int nueva) => ItemPedido(
        productoId: productoId,
        nombre: nombre,
        tamano: tamano,
        leche: leche,
        extras: extras,
        notas: notas,
        precioUnitario: precioUnitario,
        cantidad: nueva,
      );
}

/// RN-02: el precio se recalcula con cada opción.
int precioPersonalizado(
  Producto producto, {
  String? tamano,
  String? leche,
  List<String> extras = const [],
}) =>
    producto.precio +
    (recargoTamano[tamano] ?? 0) +
    (recargoLeche[leche] ?? 0) +
    extras.fold(0, (suma, extra) => suma + (recargoExtra[extra] ?? 0));

/// RN-01: sin tamaño no hay ítem.
ItemPedido armarItem(
  Producto producto, {
  String? tamano,
  String? leche,
  List<String> extras = const [],
  String notas = '',
}) {
  if (tamano == null) throw const Falla('tamano-requerido');
  return ItemPedido(
    productoId: producto.id,
    nombre: producto.nombre,
    tamano: tamano,
    leche: leche,
    extras: List.unmodifiable(extras),
    notas: notas.trim(),
    precioUnitario: precioPersonalizado(producto,
        tamano: tamano, leche: leche, extras: extras),
  );
}
