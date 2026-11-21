import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_bites/domain/entities/producto.dart';

abstract final class ProductoDto {
  static Producto desdeMapa(String id, Map<String, Object?> mapa) => Producto(
        id: id,
        nombre: mapa['nombre'] as String,
        categoria: mapa['categoria'] as String,
        precio: (mapa['precio'] as num).toInt(),
        minutosPreparacion: (mapa['minutosPreparacion'] as num).toInt(),
        disponible: mapa['disponible'] == true || mapa['disponible'] == 1,
      );

  static Producto desdeFirestore(
          QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
      desdeMapa(doc.id, doc.data());

  static Producto desdeFila(Map<String, Object?> fila) =>
      desdeMapa(fila['id'] as String, fila);

  static Map<String, Object?> aFirestore(Producto p) => {
        'nombre': p.nombre,
        'categoria': p.categoria,
        'precio': p.precio,
        'minutosPreparacion': p.minutosPreparacion,
        'disponible': p.disponible,
      };

  /// SQLite no tiene bool: se guarda 1 o 0 (semana 08).
  static Map<String, Object?> aFila(Producto p) =>
      {'id': p.id, ...aFirestore(p), 'disponible': p.disponible ? 1 : 0};
}
