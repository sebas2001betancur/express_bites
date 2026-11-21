import 'package:express_bites/domain/entities/item_pedido.dart';

enum EstadoPedido {
  enPreparacion('en_preparacion', 'En preparación'),
  listo('listo', 'Listo para recoger'),
  entregado('entregado', 'Entregado');

  const EstadoPedido(this.codigo, this.etiqueta);

  final String codigo;
  final String etiqueta;

  static EstadoPedido desdeCodigo(String codigo) => values.firstWhere(
        (estado) => estado.codigo == codigo,
        orElse: () => EstadoPedido.enPreparacion,
      );
}

/// RN-05: el Claim ID sale del id del documento (aleatorio de Firestore),
/// así que no se repite.
String claimIdDe(String id) {
  final base = id.length >= 8 ? id.substring(0, 8) : id;
  return 'EB-${base.toUpperCase()}';
}

class Pedido {
  const Pedido({
    required this.id,
    required this.uid,
    required this.items,
    required this.total,
    required this.recogida,
    required this.creado,
    this.estado = EstadoPedido.enPreparacion,
    this.pendiente = false,
  });

  final String id;
  final String uid;
  final List<ItemPedido> items;
  final int total;
  final DateTime recogida;
  final DateTime creado;
  final EstadoPedido estado;

  /// true mientras la escritura no llega al servidor (hasPendingWrites).
  final bool pendiente;

  String get claimId => claimIdDe(id);

  Pedido conEstado(EstadoPedido nuevo) => Pedido(
        id: id,
        uid: uid,
        items: items,
        total: total,
        recogida: recogida,
        creado: creado,
        estado: nuevo,
        pendiente: pendiente,
      );
}
