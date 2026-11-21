import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_bites/domain/entities/item_pedido.dart';
import 'package:express_bites/domain/entities/pedido.dart';

abstract final class PedidoDto {
  static Map<String, Object?> itemAMapa(ItemPedido i) => {
    'productoId': i.productoId,
    'nombre': i.nombre,
    'tamano': i.tamano,
    'leche': i.leche,
    'extras': i.extras,
    'notas': i.notas,
    'precioUnitario': i.precioUnitario,
    'cantidad': i.cantidad,
  };

  static ItemPedido itemDesdeMapa(Map<String, Object?> m) => ItemPedido(
    productoId: m['productoId'] as String,
    nombre: m['nombre'] as String,
    tamano: m['tamano'] as String,
    leche: m['leche'] as String?,
    extras: List<String>.from(m['extras'] as List? ?? const []),
    notas: m['notas'] as String? ?? '',
    precioUnitario: (m['precioUnitario'] as num).toInt(),
    cantidad: (m['cantidad'] as num).toInt(),
  );

  /// Las fechas se guardan como milisegundos (entero) en la nube y en el teléfono.
  static Map<String, Object?> aFirestore(Pedido p) => {
    'uid': p.uid,
    'items': p.items.map(itemAMapa).toList(),
    'total': p.total,
    'recogida': p.recogida.millisecondsSinceEpoch,
    'creado': p.creado.millisecondsSinceEpoch,
    'estado': p.estado.codigo,
  };

  static Pedido desdeMapa(
    String id,
    Map<String, Object?> m, {
    bool pendiente = false,
  }) => Pedido(
    id: id,
    uid: m['uid'] as String,
    items: (m['items'] as List)
        .map((e) => itemDesdeMapa(Map<String, Object?>.from(e as Map)))
        .toList(),
    total: (m['total'] as num).toInt(),
    recogida: DateTime.fromMillisecondsSinceEpoch(
      (m['recogida'] as num).toInt(),
    ),
    creado: DateTime.fromMillisecondsSinceEpoch((m['creado'] as num).toInt()),
    estado: EstadoPedido.desdeCodigo(m['estado'] as String),
    pendiente: pendiente,
  );

  static Pedido desdeFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      desdeMapa(doc.id, doc.data()!, pendiente: doc.metadata.hasPendingWrites);

  /// En SQLite los ítems van como texto JSON (jsonEncode, semana 07).
  static Map<String, Object?> aFila(Pedido p) => {
    'id': p.id,
    ...aFirestore(p),
    'items': jsonEncode(p.items.map(itemAMapa).toList()),
  };

  static Pedido desdeFila(Map<String, Object?> fila) => desdeMapa(
    fila['id'] as String,
    <String, Object?>{...fila, 'items': jsonDecode(fila['items'] as String)},
  );
}
