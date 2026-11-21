import 'package:express_bites/domain/entities/item_pedido.dart';
import 'package:express_bites/domain/failures/falla.dart';

const margenMinimo = Duration(minutes: 15);

/// Un pedido que todavía no existe. Su constructor aplica RN-03 y RN-04.
class NuevoPedido {
  NuevoPedido({
    required List<ItemPedido> items,
    required this.recogida,
    required DateTime ahora,
  }) : items = List.unmodifiable(items) {
    if (this.items.isEmpty) throw const Falla('carrito-vacio');
    if (recogida.isBefore(ahora.add(margenMinimo))) {
      throw const Falla('hora-invalida');
    }
  }

  final List<ItemPedido> items;
  final DateTime recogida;

  int get total => items.fold(0, (suma, item) => suma + item.subtotal);
}
