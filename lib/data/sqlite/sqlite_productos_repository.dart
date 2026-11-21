import 'package:express_bites/data/dtos/producto_dto.dart';
import 'package:express_bites/domain/entities/catalogo.dart';
import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/domain/repositories/productos_repository.dart';
import 'package:sqflite/sqflite.dart';

/// Fuente local de productos. También sirve sola: cambiarla en main.dart
/// muestra que la presentación no depende de dónde vienen los datos.
class SqliteProductosRepository implements ProductosRepository {
  SqliteProductosRepository(this._db);

  final Database _db;

  Future<List<Producto>> leer() async {
    try {
      final filas = await _db.query('productos', orderBy: 'categoria, nombre');
      return filas.map(ProductoDto.desdeFila).toList();
    } on DatabaseException {
      throw const Falla('base-local');
    }
  }

  /// Borra y vuelve a insertar: el servidor manda (semana 08).
  Future<void> guardarCopia(List<Producto> productos) async {
    try {
      await _db.transaction((txn) async {
        final lote = txn.batch();
        lote.delete('productos');
        for (final p in productos) {
          lote.insert('productos', ProductoDto.aFila(p));
        }
        await lote.commit(noResult: true);
      });
    } on DatabaseException {
      throw const Falla('base-local');
    }
  }

  @override
  Stream<Catalogo> observar() async* {
    yield Catalogo(await leer(), sinConexion: true);
  }

  @override
  Future<void> cambiarDisponible(String id, bool disponible) async {
    throw const Falla('requiere-conexion');
  }

  @override
  Future<void> cargarMenuInicial(List<Producto> productos) =>
      guardarCopia(productos);
}
