import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_bites/data/dtos/producto_dto.dart';
import 'package:express_bites/data/proteger.dart';
import 'package:express_bites/domain/entities/catalogo.dart';
import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/repositories/productos_repository.dart';

class FirestoreProductosRepository implements ProductosRepository {
  final _coleccion = FirebaseFirestore.instance.collection('productos');

  /// includeMetadataChanges hace que el stream avise también cuando se pierde
  /// o vuelve la conexión (isFromCache cambia).
  @override
  Stream<Catalogo> observar() => _coleccion
      .snapshots(includeMetadataChanges: true)
      .map(
        (datos) => Catalogo(
          datos.docs.map(ProductoDto.desdeFirestore).toList(),
          sinConexion: datos.metadata.isFromCache,
        ),
      );

  @override
  Future<void> cambiarDisponible(String id, bool disponible) =>
      proteger(() => _coleccion.doc(id).update({'disponible': disponible}));

  @override
  Future<void> cargarMenuInicial(List<Producto> productos) =>
      proteger(() async {
        for (final p in productos) {
          await _coleccion.doc(p.id).set(ProductoDto.aFirestore(p));
        }
      });
}
