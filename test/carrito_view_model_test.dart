import 'package:express_bites/domain/entities/item_pedido.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/presentation/carrito/carrito_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  final ahora = DateTime(2026, 11, 20, 10, 0);
  final item = armarItem(cafe, tamano: 'Pequeño');
  late PedidosEnMemoria pedidos;
  late CarritoViewModel vm;

  setUp(() {
    pedidos = PedidosEnMemoria();
    vm = CarritoViewModel(pedidos: pedidos, uid: 'u1', reloj: () => ahora);
  });
  tearDown(() => vm.dispose());

  test('no confirma con el carrito vacío (RN-03)', () async {
    vm.elegirAtajo(const Duration(minutes: 15));
    expect(await vm.confirmar(), isNull);
    expect(vm.error, 'Tu carrito está vacío');
    expect(pedidos.pedidos, isEmpty);
  });

  test('pide elegir una franja de recogida', () async {
    vm.agregar(item);
    expect(await vm.confirmar(), isNull);
    expect(vm.error, 'Elige una franja de recogida');
  });

  test('rechaza una hora a menos de 15 minutos (RN-04)', () async {
    vm.agregar(item);
    vm.elegirHora(ahora.add(const Duration(minutes: 10)));
    expect(await vm.confirmar(), isNull);
    expect(vm.error, 'La recogida debe ser al menos 15 minutos después de ahora');
  });

  test('las cantidades suman y quitan ítems', () {
    vm.agregar(item);
    vm.cambiarCantidad(0, 2);
    expect(vm.cantidadTotal, 3);
    expect(vm.total, 4500 * 3);
    vm.cambiarCantidad(0, -3);
    expect(vm.items, isEmpty);
  });

  test('confirma, limpia el carrito y devuelve el pedido', () async {
    vm.agregar(item);
    vm.elegirAtajo(const Duration(minutes: 30));
    final pedido = await vm.confirmar();
    expect(pedido, isNotNull);
    expect(pedido!.recogida, ahora.add(const Duration(minutes: 30)));
    expect(pedido.uid, 'u1');
    expect(vm.items, isEmpty);
    expect(vm.error, isNull);
  });

  test('sin conexión conserva el carrito y reintenta con el mismo id', () async {
    vm.agregar(item);
    vm.elegirAtajo(const Duration(minutes: 15));
    pedidos.falloAlCrear = const Falla('sin-conexion');

    expect(await vm.confirmar(), isNull);
    expect(vm.items, hasLength(1));
    expect(vm.error, 'Sin conexión: revisa tu internet');

    expect(await vm.confirmar(), isNotNull);
    expect(pedidos.idsUsados, hasLength(2));
    expect(pedidos.idsUsados.toSet(), hasLength(1));
  });
}
