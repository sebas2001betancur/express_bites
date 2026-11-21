import 'package:express_bites/data/sqlite/sqlite_productos_repository.dart';
import 'package:express_bites/domain/entities/catalogo.dart';
import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/repositories/productos_repository.dart';

class ProductosConRespaldo implements ProductosRepository {
  ProductosConRespaldo({required this._nube, required this._local});

  final ProductosRepository _nube;
  final SqliteProductosRepository _local;

  @override
  Stream<Catalogo> observar() async* {
    try {
      await for (final catalogo in _nube.observar()) {
        if (catalogo.sinConexion && catalogo.productos.isEmpty) {
          // Sin red y sin caché de Firestore: lo último guardado en SQLite.
          yield Catalogo(await _local.leer(), sinConexion: true);
        } else {
          // Solo se copia lo que viene del servidor.
          if (!catalogo.sinConexion) await _local.guardarCopia(catalogo.productos);
          yield catalogo;
        }
      }
    } catch (_) {
      yield Catalogo(await _local.leer(), sinConexion: true);
    }
  }

  @override
  Future<void> cambiarDisponible(String id, bool disponible) =>
      _nube.cambiarDisponible(id, disponible);

  @override
  Future<void> cargarMenuInicial(List<Producto> productos) =>
      _nube.cargarMenuInicial(productos);
}
