// ignore_for_file: prefer_initializing_formals
import 'package:express_bites/domain/entities/item_pedido.dart';
import 'package:express_bites/domain/entities/nuevo_pedido.dart';
import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/domain/repositories/pedidos_repository.dart';
import 'package:express_bites/presentation/comun/mensajes.dart';
import 'package:flutter/foundation.dart';

class CarritoViewModel extends ChangeNotifier {
  CarritoViewModel({
    required PedidosRepository pedidos,
    required String uid,
    DateTime Function()? reloj,
  })  : _pedidos = pedidos,
        _uid = uid,
        _reloj = reloj ?? DateTime.now;

  final PedidosRepository _pedidos;
  final String _uid;
  final DateTime Function() _reloj;
  final List<ItemPedido> _items = [];
  bool _cerrado = false;

  /// Id del pedido en curso: se reutiliza al reintentar para no duplicar.
  String? _idEnCurso;

  Duration? atajo;
  DateTime? horaFija;
  bool enviando = false;
  String? error;

  List<ItemPedido> get items => List.unmodifiable(_items);
  int get total => _items.fold(0, (s, i) => s + i.subtotal);
  int get cantidadTotal => _items.fold(0, (s, i) => s + i.cantidad);

  void agregar(ItemPedido item) {
    _items.add(item);
    _idEnCurso = null;
    error = null;
    _notificar();
  }

  void cambiarCantidad(int indice, int delta) {
    final nueva = _items[indice].cantidad + delta;
    if (nueva <= 0) {
      _items.removeAt(indice);
    } else {
      _items[indice] = _items[indice].conCantidad(nueva);
    }
    _idEnCurso = null;
    _notificar();
  }

  void elegirAtajo(Duration duracion) {
    atajo = duracion;
    horaFija = null;
    error = null;
    _notificar();
  }

  void elegirHora(DateTime hora) {
    horaFija = hora;
    atajo = null;
    error = null;
    _notificar();
  }

  Future<Pedido?> confirmar() async {
    final ahora = _reloj();
    if (_items.isEmpty) return _fallar('carrito-vacio');
    final recogida = atajo != null ? ahora.add(atajo!) : horaFija;
    if (recogida == null) {
      error = 'Elige una franja de recogida';
      _notificar();
      return null;
    }
    final NuevoPedido nuevo;
    try {
      nuevo = NuevoPedido(items: _items, recogida: recogida, ahora: ahora);
    } on Falla catch (f) {
      return _fallar(f.codigo);
    }

    final id = _idEnCurso ??= _pedidos.nuevoId();
    enviando = true;
    error = null;
    _notificar();
    try {
      final pedido = await _pedidos.crear(id, _uid, nuevo);
      _items.clear();
      atajo = null;
      horaFija = null;
      _idEnCurso = null;
      return pedido;
    } on Falla catch (f) {
      error = mensajeDe(f.codigo); // el carrito se conserva
      return null;
    } finally {
      enviando = false;
      _notificar();
    }
  }

  Pedido? _fallar(String codigo) {
    error = mensajeDe(codigo);
    _notificar();
    return null;
  }

  void _notificar() {
    if (!_cerrado) notifyListeners();
  }

  @override
  void dispose() {
    _cerrado = true;
    super.dispose();
  }
}
