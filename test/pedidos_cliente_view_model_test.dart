import 'package:express_bites/domain/entities/item_pedido.dart';
import 'package:express_bites/domain/entities/nuevo_pedido.dart';
import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/presentation/pedidos/pedidos_cliente_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

NuevoPedido nuevoDePrueba() => NuevoPedido(
      items: [armarItem(cafe, tamano: 'Pequeño')],
      recogida: DateTime(2026, 11, 20, 11),
      ahora: DateTime(2026, 11, 20, 10),
    );

void main() {
  late PedidosEnMemoria pedidos;
  late List<String> avisados;
  late PedidosClienteViewModel vm;

  setUp(() {
    pedidos = PedidosEnMemoria();
    avisados = [];
    vm = PedidosClienteViewModel(
      pedidos: pedidos,
      uid: 'u1',
      avisar: (claimId) async => avisados.add(claimId),
    );
  });
  tearDown(() => vm.dispose());

  test('mientras carga la lista es null', () {
    expect(vm.lista, isNull);
  });

  test('sin pedidos la lista queda vacía y no hay activo', () async {
    pedidos.emitir();
    await esperar();
    expect(vm.lista, isEmpty);
    expect(vm.activo, isNull);
  });

  test('el pedido sin entregar es el activo', () async {
    final p = await pedidos.crear(pedidos.nuevoId(), 'u1', nuevoDePrueba());
    await esperar();
    expect(vm.activo?.id, p.id);
    expect(vm.buscar(p.id)?.claimId, p.claimId);
  });

  test('avisa una sola vez cuando el pedido pasa a listo', () async {
    final p = await pedidos.crear(pedidos.nuevoId(), 'u1', nuevoDePrueba());
    await esperar();
    await pedidos.cambiarEstado(p.id, EstadoPedido.listo);
    await esperar();
    await pedidos.cambiarEstado(p.id, EstadoPedido.listo);
    await esperar();
    expect(avisados, [p.claimId]);
  });

  test('avisa si al abrir la app el pedido pasa de en preparación a listo', () async {
    final otros = PedidosEnMemoria();
    final p = await otros.crear(otros.nuevoId(), 'u1', nuevoDePrueba());
    await otros.cambiarEstado(p.id, EstadoPedido.listo);
    final otrosAvisos = <String>[];
    final otroVm = PedidosClienteViewModel(
      pedidos: otros,
      uid: 'u1',
      avisar: (c) async => otrosAvisos.add(c),
    );
    // El fake ya tenía dos eventos en cola; el segundo trae el pedido listo.
    await esperar();
    expect(otroVm.lista!.single.estado, EstadoPedido.listo);
    expect(otrosAvisos, [p.claimId]);
    otroVm.dispose();
  });
}
