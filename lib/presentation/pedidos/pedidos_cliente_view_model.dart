// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/domain/repositories/pedidos_repository.dart';
import 'package:flutter/foundation.dart';

/// Pedidos del cliente: historial, ticket activo y aviso cuando uno queda listo.
class PedidosClienteViewModel extends ChangeNotifier {
  PedidosClienteViewModel({
    required PedidosRepository pedidos,
    required String uid,
    required Future<void> Function(String claimId) avisar,
  }) : _avisar = avisar {
    _suscripcion = pedidos.observarMios(uid).listen(
      _alRecibir,
      onError: (Object _) {
        lista ??= const [];
        error = 'No se pudieron leer tus pedidos';
        _notificar();
      },
    );
  }

  final Future<void> Function(String claimId) _avisar;
  final Map<String, EstadoPedido> _estados = {};
  StreamSubscription<List<Pedido>>? _suscripcion;
  bool _cerrado = false;

  List<Pedido>? lista;
  String? error;

  Pedido? get activo {
    for (final p in lista ?? const <Pedido>[]) {
      if (p.estado != EstadoPedido.entregado) return p;
    }
    return null;
  }

  Pedido? buscar(String id) {
    for (final p in lista ?? const <Pedido>[]) {
      if (p.id == id) return p;
    }
    return null;
  }

  void _alRecibir(List<Pedido> nuevos) {
    for (final p in nuevos) {
      final antes = _estados[p.id];
      if (antes != null &&
          antes != EstadoPedido.listo &&
          p.estado == EstadoPedido.listo) {
        unawaited(_avisar(p.claimId));
      }
      _estados[p.id] = p.estado;
    }
    lista = nuevos;
    error = null;
    _notificar();
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
