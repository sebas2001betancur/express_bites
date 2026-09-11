import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../data/catalogo_datos.dart';
import '../models/producto.dart';

final catalogoProvider = Provider<List<Producto>>((ref) {
  return catalogoEjemplo;
});

final categoriaSeleccionadaProvider = StateProvider<String?>((ref) => null);

final catalogoFiltradoProvider = Provider<List<Producto>>((ref) {
  final categoria = ref.watch(categoriaSeleccionadaProvider);
  final catalogo = ref.watch(catalogoProvider);
  if (categoria == null) return catalogo;
  return catalogo.where((p) => p.categoria == categoria).toList();
});
