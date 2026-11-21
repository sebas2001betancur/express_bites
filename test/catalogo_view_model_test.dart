import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/presentation/catalogo/catalogo_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  late ProductosEnMemoria productos;
  late ClimaFalso clima;
  late CatalogoViewModel vm;

  setUp(() {
    productos = ProductosEnMemoria(menuDePrueba);
    clima = ClimaFalso();
    vm = CatalogoViewModel(productos: productos, clima: clima);
  });
  tearDown(() => vm.dispose());

  test('empieza cargando y luego muestra solo los disponibles', () async {
    final recienCreado = CatalogoViewModel(
      productos: ProductosEnMemoria(menuDePrueba),
    );
    addTearDown(recienCreado.dispose);
    expect(recienCreado.cargando, isTrue);
    await esperar();
    expect(vm.cargando, isFalse);
    expect(vm.visibles.map((p) => p.id), ['p1', 'p2']);
  });

  test('filtra por categoría y por texto', () async {
    await esperar();
    vm.filtrar('Bebidas frías');
    expect(vm.visibles.single.id, 'p2');
    vm.filtrar(null);
    vm.buscar('AMERI');
    expect(vm.visibles.single.id, 'p1');
  });

  test(
    'marca sin conexión cuando los datos vienen de la copia local',
    () async {
      await esperar();
      productos.sinConexion = true;
      productos.emitir();
      await esperar();
      expect(vm.sinConexion, isTrue);
    },
  );

  test('un error de lectura muestra un mensaje', () async {
    await esperar();
    productos.emitirError();
    await esperar();
    expect(vm.error, 'No se pudo cargar el catálogo');
  });

  test('clima: listo, luego error y reintento', () async {
    await esperar();
    expect(vm.estadoClima, EstadoClima.listo);
    expect(vm.clima!.categoriaSugerida, 'Bebidas frías');

    clima.fallo = const Falla('sin-conexion');
    await vm.cargarClima();
    expect(vm.estadoClima, EstadoClima.error);
    expect(vm.errorClima, 'Sin conexión: revisa tu internet');

    clima.fallo = null;
    await vm.cargarClima();
    expect(vm.estadoClima, EstadoClima.listo);
  });

  test('cambiar disponibilidad sin permiso muestra el error', () async {
    await esperar();
    productos.fallo = const Falla('permission-denied');
    await vm.cambiarDisponible('p1', false);
    expect(vm.error, 'Tu cuenta no tiene permiso para esta acción');
  });
}
