import 'package:express_bites/domain/entities/nuevo_pedido.dart';
import 'package:express_bites/domain/entities/pedido.dart';

abstract interface class PedidosRepository {
  /// Id para un pedido nuevo. Reutilizarlo al reintentar evita duplicados.
  String nuevoId();
  Future<Pedido> crear(String id, String uid, NuevoPedido nuevo);
  Stream<List<Pedido>> observarMios(String uid);
  Stream<List<Pedido>> observarActivos();
  Future<void> cambiarEstado(String id, EstadoPedido estado);
}
