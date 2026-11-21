import 'package:express_bites/domain/entities/producto.dart';

/// Lo que la app sabe del menú en un momento dado.
/// [sinConexion] es true cuando los datos salen de la copia del teléfono.
class Catalogo {
  const Catalogo(this.productos, {this.sinConexion = false});

  final List<Producto> productos;
  final bool sinConexion;
}
