import 'package:express_bites/domain/entities/item_pedido.dart';
import 'package:express_bites/domain/entities/nuevo_pedido.dart';
import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/presentation/personal/pedidos_personal_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  late PedidosEnMemoria pedidos;
  late PedidosPersonalViewModel vm;

  Future<Pedido> crear() => pedidos.crear(
    pedidos.nuevoId(),
    'cliente1',
    NuevoPedido(
      items: [armarItem(cafe, tamano: 'Grande')],
      recogida: DateTime(2026, 11, 20, 11),
      ahora: DateTime(2026, 11, 20, 10),
    ),
  );

  setUp(() {
    pedidos = PedidosEnMemoria();
    vm = PedidosPersonalViewModel(pedidos);
  });
  tearDown(() => vm.dispose());

  test('marcar listo cambia el estado (HU-05)', () async {
    final p = await crear();
    await esperar();
    vm.marcarListo(p);
    await esperar();
    expect(vm.lista!.single.estado, EstadoPedido.listo);
  });

  test('un código que no existe devuelve un mensaje (HU-06)', () async {
    await crear();
    await esperar();
    expect(
      await vm.entregarPorCodigo('EB-NOEXISTE'),
      contains('No hay un pedido activo'),
    );
  });

  test('el código correcto entrega y no permite doble despacho', () async {
    final p = await crear();
    await esperar();
    vm.marcarListo(p);
    await esperar();
    expect(await vm.entregarPorCodigo(' ${p.claimId.toLowerCase()} '), isNull);
    await esperar();
    expect(vm.lista, isEmpty);
    expect(
      await vm.entregarPorCodigo(p.claimId),
      contains('No hay un pedido activo'),
    );
  });

  test('no entrega un pedido que aún está en preparación', () async {
    final p = await crear();
    await esperar();
    expect(
      await vm.entregarPorCodigo(p.claimId),
      contains('aún no está listo'),
    );
    await esperar();
    expect(vm.lista, hasLength(1));
  });
}
