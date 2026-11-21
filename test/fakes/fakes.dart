import 'dart:async';

import 'package:express_bites/domain/entities/catalogo.dart';
import 'package:express_bites/domain/entities/clima.dart';
import 'package:express_bites/domain/entities/nuevo_pedido.dart';
import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/entities/usuario.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/domain/repositories/clima_repository.dart';
import 'package:express_bites/domain/repositories/cuenta_repository.dart';
import 'package:express_bites/domain/repositories/pedidos_repository.dart';
import 'package:express_bites/domain/repositories/preferencias_repository.dart';
import 'package:express_bites/domain/repositories/productos_repository.dart';

/// Deja correr los eventos pendientes de los streams.
Future<void> esperar() => Future<void>.delayed(Duration.zero);

const cafe = Producto(
  id: 'p1',
  nombre: 'Café Americano',
  categoria: 'Bebidas calientes',
  precio: 4500,
  minutosPreparacion: 3,
);

const menuDePrueba = [
  cafe,
  Producto(
    id: 'p2',
    nombre: 'Jugo de Mora',
    categoria: 'Bebidas frías',
    precio: 4000,
    minutosPreparacion: 4,
  ),
  Producto(
    id: 'p3',
    nombre: 'Croissant',
    categoria: 'Repostería',
    precio: 3000,
    minutosPreparacion: 2,
    disponible: false,
  ),
];

class ProductosEnMemoria implements ProductosRepository {
  ProductosEnMemoria([List<Producto> iniciales = const []])
    : _productos = [...iniciales] {
    emitir();
  }

  final List<Producto> _productos;
  final _salida = StreamController<Catalogo>();
  bool sinConexion = false;
  Falla? fallo;

  void emitir() =>
      _salida.add(Catalogo(List.of(_productos), sinConexion: sinConexion));

  void emitirError() => _salida.addError(const Falla('unavailable'));

  @override
  Stream<Catalogo> observar() => _salida.stream;

  @override
  Future<void> cambiarDisponible(String id, bool disponible) async {
    if (fallo != null) throw fallo!;
    final i = _productos.indexWhere((p) => p.id == id);
    _productos[i] = _productos[i].conDisponible(disponible);
    emitir();
  }

  @override
  Future<void> cargarMenuInicial(List<Producto> productos) async {
    if (fallo != null) throw fallo!;
    _productos
      ..clear()
      ..addAll(productos);
    emitir();
  }
}

class PedidosEnMemoria implements PedidosRepository {
  final List<Pedido> pedidos = [];
  final List<String> idsUsados = [];
  final _mios = StreamController<List<Pedido>>();
  final _activos = StreamController<List<Pedido>>();
  int _siguiente = 1;
  Falla? falloAlCrear;

  void emitir() {
    _mios.add(List.of(pedidos));
    _activos.add(
      pedidos.where((p) => p.estado != EstadoPedido.entregado).toList(),
    );
  }

  @override
  String nuevoId() => '${_siguiente++}abcdefgh';

  @override
  Future<Pedido> crear(String id, String uid, NuevoPedido nuevo) async {
    idsUsados.add(id);
    final fallo = falloAlCrear;
    if (fallo != null) {
      falloAlCrear = null;
      throw fallo;
    }
    final pedido = Pedido(
      id: id,
      uid: uid,
      items: nuevo.items,
      total: nuevo.total,
      recogida: nuevo.recogida,
      creado: DateTime(2026, 11, 20, 9),
    );
    pedidos.add(pedido);
    emitir();
    return pedido;
  }

  @override
  Stream<List<Pedido>> observarMios(String uid) => _mios.stream;

  @override
  Stream<List<Pedido>> observarActivos() => _activos.stream;

  @override
  Future<void> cambiarEstado(String id, EstadoPedido estado) async {
    final i = pedidos.indexWhere((p) => p.id == id);
    pedidos[i] = pedidos[i].conEstado(estado);
    emitir();
  }
}

class ClimaFalso implements ClimaRepository {
  Clima respuesta = const Clima(temperatura: 25, lluvia: 0);
  Falla? fallo;

  @override
  Future<Clima> actual() async {
    if (fallo != null) throw fallo!;
    return respuesta;
  }
}

class CuentaFalsa implements CuentaRepository {
  final _sesion = StreamController<Usuario?>();
  final registros = <(String, Rol)>[];
  Falla? fallo;

  void emitir(Usuario? usuario) => _sesion.add(usuario);

  @override
  Stream<Usuario?> sesion() => _sesion.stream;

  @override
  Future<void> registrar(String correo, String clave, Rol rol) async {
    if (fallo != null) throw fallo!;
    registros.add((correo, rol));
  }

  @override
  Future<void> iniciar(String correo, String clave) async {
    if (fallo != null) throw fallo!;
  }

  @override
  Future<void> salir() async {}
}

class PreferenciasEnMemoria implements PreferenciasRepository {
  String? tema;

  @override
  Future<String?> leerTema() async => tema;

  @override
  Future<void> guardarTema(String nuevo) async => tema = nuevo;
}
