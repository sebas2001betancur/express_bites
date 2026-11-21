import 'package:express_bites/domain/entities/catalogo.dart';
import 'package:express_bites/domain/entities/producto.dart';

abstract interface class ProductosRepository {
  Stream<Catalogo> observar();
  Future<void> cambiarDisponible(String id, bool disponible);
  Future<void> cargarMenuInicial(List<Producto> productos);
}
