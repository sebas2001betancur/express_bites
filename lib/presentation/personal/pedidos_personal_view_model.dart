import 'dart:async';

import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/domain/repositories/pedidos_repository.dart';
import 'package:express_bites/presentation/comun/mensajes.dart';
import 'package:flutter/foundation.dart';

class PedidosPersonalViewModel extends ChangeNotifier {
  PedidosPersonalViewModel(this._pedidos) {
    _suscripcion = _pedidos.observarActivos().listen(
      (activos) {
        lista = activos;
        error = null;
        _notificar();
      },
      onError: (Object _) {
        lista ??= const [];
        error = 'No se pudieron leer los pedidos. Revisa tu conexión';
        _notificar();
      },
    );
  }

  final PedidosRepository _pedidos;
  StreamSubscription<List<Pedido>>? _suscripcion;
  bool _cerrado = false;

  List<Pedido>? lista;
  String? error;

  /// Sin await (como la guía): sin internet Firestore deja la escritura en cola.
  void marcarListo(Pedido pedido) =>
      unawaited(_cambiar(pedido.id, EstadoPedido.listo));

  /// HU-06: null si se entregó; si no, el motivo.
  Future<String?> entregarPorCodigo(String codigo) async {
    final buscado = codigo.trim().toUpperCase();
    for (final p in lista ?? const <Pedido>[]) {
      if (p.claimId == buscado) {
        if (p.estado != EstadoPedido.listo) {
          return 'El pedido ${p.claimId} aún no está listo';
        }
        unawaited(_cambiar(p.id, EstadoPedido.entregado));
        return null;
      }
    }
    return 'No hay un pedido activo con el código $buscado '
        '(no existe o ya se entregó)';
  }

  Future<void> _cambiar(String id, EstadoPedido estado) async {
    error = null;
    _notificar();
    try {
      await _pedidos.cambiarEstado(id, estado);
    } on Falla catch (f) {
      error = mensajeDe(f.codigo);
      _notificar();
    }
  }

  void _notificar() {
    if (!_cerrado) notifyListeners();
  }

  @override
  void dispose() {
    _cerrado = true;
    _suscripcion?.cancel();
    super.dispose();
  }
}
