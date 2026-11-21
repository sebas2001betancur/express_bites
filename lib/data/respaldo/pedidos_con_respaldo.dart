import 'package:express_bites/data/sqlite/pedidos_local.dart';
import 'package:express_bites/domain/entities/nuevo_pedido.dart';
import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/domain/repositories/pedidos_repository.dart';

class PedidosConRespaldo implements PedidosRepository {
  PedidosConRespaldo({required this._nube, required this._local});

  final PedidosRepository _nube;
  final PedidosLocal _local;

  @override
  String nuevoId() => _nube.nuevoId();

  @override
  Future<Pedido> crear(String id, String uid, NuevoPedido nuevo) async {
    final pedido = await _nube.crear(id, uid, nuevo);
    try {
      await _local.guardar(
        pedido,
      ); // el ticket queda en el teléfono (HU-04, HU-07)
    } on Falla {
      // best-effort: el pedido ya existe en la nube
    }
    return pedido;
  }

  /// Primero lo guardado en el teléfono (sirve sin internet), luego la nube.
  @override
  Stream<List<Pedido>> observarMios(String uid) async* {
    yield await _local.leerMios(uid);
    try {
      await for (final lista in _nube.observarMios(uid)) {
        if (lista.isEmpty) {
          yield await _local.leerMios(uid);
        } else {
          try {
            await _local.reemplazarMios(uid, lista);
          } on Falla {
            // la copia local es best-effort
          }
          yield lista;
        }
      }
    } catch (_) {
      // Sin nube: la copia local ya se mostró.
    }
  }

  @override
  Stream<List<Pedido>> observarActivos() => _nube.observarActivos();

  @override
  Future<void> cambiarEstado(String id, EstadoPedido estado) =>
      _nube.cambiarEstado(id, estado);
}
