// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:express_bites/domain/entities/catalogo.dart';
import 'package:express_bites/domain/entities/clima.dart';
import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/domain/repositories/clima_repository.dart';
import 'package:express_bites/domain/repositories/productos_repository.dart';
import 'package:express_bites/presentation/comun/mensajes.dart';
import 'package:flutter/foundation.dart';

enum EstadoClima { cargando, listo, error }

class CatalogoViewModel extends ChangeNotifier {
  CatalogoViewModel({
    required ProductosRepository productos,
    ClimaRepository? clima,
  }) : _productos = productos,
       _clima = clima {
    _suscripcion = _productos.observar().listen(
      _alRecibir,
      onError: (Object _) {
        _todos = const [];
        error = 'No se pudo cargar el catálogo';
        _notificar();
      },
    );
    if (_clima != null) unawaited(cargarClima());
  }

  final ProductosRepository _productos;
  final ClimaRepository? _clima;
  StreamSubscription<Catalogo>? _suscripcion;
  bool _cerrado = false;

  List<Producto>? _todos;
  bool sinConexion = false;
  String? error;
  String? categoria;
  String busqueda = '';

  EstadoClima estadoClima = EstadoClima.cargando;
  Clima? clima;
  String? errorClima;

  bool get cargando => _todos == null;
  List<Producto> get todos => _todos ?? const [];
  List<String> get categorias =>
      <String>{for (final p in todos) p.categoria}.toList();

  List<Producto> get visibles {
    final texto = busqueda.trim().toLowerCase();
    return todos
        .where(
          (p) =>
              p.disponible &&
              (categoria == null || p.categoria == categoria) &&
              p.nombre.toLowerCase().contains(texto),
        )
        .toList();
  }

  void _alRecibir(Catalogo catalogo) {
    _todos = catalogo.productos;
    sinConexion = catalogo.sinConexion;
    error = null;
    _notificar();
  }

  void filtrar(String? nueva) {
    categoria = nueva;
    _notificar();
  }

  void buscar(String texto) {
    busqueda = texto;
    _notificar();
  }

  /// Semana 07: primero "cargando", así Reintentar vuelve a mostrar el indicador.
  Future<void> cargarClima() async {
    final fuente = _clima;
    if (fuente == null) return;
    estadoClima = EstadoClima.cargando;
    errorClima = null;
    _notificar();
    try {
      clima = await fuente.actual();
      estadoClima = EstadoClima.listo;
    } on Falla catch (f) {
      errorClima = mensajeDe(f.codigo);
      estadoClima = EstadoClima.error;
    }
    _notificar();
  }

  Future<void> cambiarDisponible(String id, bool disponible) =>
      _ejecutar(() => _productos.cambiarDisponible(id, disponible));

  Future<void> cargarMenuInicial(List<Producto> menu) =>
      _ejecutar(() => _productos.cargarMenuInicial(menu));

  Future<void> _ejecutar(Future<void> Function() accion) async {
    error = null;
    _notificar();
    try {
      await accion();
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
