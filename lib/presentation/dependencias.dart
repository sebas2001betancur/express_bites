import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/repositories/clima_repository.dart';
import 'package:express_bites/domain/repositories/cuenta_repository.dart';
import 'package:express_bites/domain/repositories/pedidos_repository.dart';
import 'package:express_bites/domain/repositories/preferencias_repository.dart';
import 'package:express_bites/domain/repositories/productos_repository.dart';

class Dependencias {
  const Dependencias({
    required this.cuenta,
    required this.productos,
    required this.pedidos,
    required this.clima,
    required this.preferencias,
    required this.avisarPedidoListo,
    required this.menuInicial,
  });

  final CuentaRepository cuenta;
  final ProductosRepository productos;
  final PedidosRepository pedidos;
  final ClimaRepository clima;
  final PreferenciasRepository preferencias;
  final Future<void> Function(String claimId) avisarPedidoListo;
  final List<Producto> menuInicial;
}
