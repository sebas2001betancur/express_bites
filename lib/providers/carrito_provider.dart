import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/producto.dart';

final carritoProvider = StateProvider<List<Producto>>((ref) => []);

final totalCarritoProvider = Provider<double>((ref) {
  final carrito = ref.watch(carritoProvider);
  return carrito.fold(0.0, (total, p) => total + p.precio);
});
