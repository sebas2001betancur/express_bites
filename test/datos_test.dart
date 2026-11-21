import 'dart:io';

import 'package:express_bites/data/api/open_meteo_clima_repository.dart';
import 'package:express_bites/data/dtos/pedido_dto.dart';
import 'package:express_bites/data/dtos/producto_dto.dart';
import 'package:express_bites/domain/entities/item_pedido.dart';
import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Matcher fallaCon(String codigo) =>
    isA<Falla>().having((f) => f.codigo, 'codigo', codigo);

void main() {
  test('ProductoDto: ida y vuelta por una fila de SQLite', () {
    const producto = Producto(
      id: 'p9',
      nombre: 'Croissant',
      categoria: 'Repostería',
      precio: 3000,
      minutosPreparacion: 2,
      disponible: false,
    );
    final fila = ProductoDto.aFila(producto);
    expect(fila['disponible'], 0);

    final vuelta = ProductoDto.desdeFila(fila);
    expect(vuelta.id, 'p9');
    expect(vuelta.precio, 3000);
    expect(vuelta.disponible, isFalse);
  });

  test('PedidoDto: ida y vuelta por SQLite conserva ítems y estado', () {
    final pedido = Pedido(
      id: 'abcdefgh12',
      uid: 'u1',
      items: const [
        ItemPedido(
          productoId: 'p1',
          nombre: 'Cappuccino',
          tamano: 'Grande',
          leche: 'Almendras',
          extras: ['Canela'],
          notas: 'sin azúcar',
          precioUnitario: 7500,
          cantidad: 2,
        ),
      ],
      total: 15000,
      recogida: DateTime(2026, 11, 20, 10, 30),
      creado: DateTime(2026, 11, 20, 10, 0),
      estado: EstadoPedido.listo,
    );

    final vuelta = PedidoDto.desdeFila(PedidoDto.aFila(pedido));

    expect(vuelta.claimId, 'EB-ABCDEFGH');
    expect(vuelta.estado, EstadoPedido.listo);
    expect(vuelta.recogida, pedido.recogida);
    expect(vuelta.items.single.extras, ['Canela']);
    expect(vuelta.items.single.leche, 'Almendras');
    expect(vuelta.items.single.subtotal, 15000);
  });

  group('OpenMeteoClimaRepository', () {
    test('convierte el JSON a Clima', () async {
      final api = OpenMeteoClimaRepository(MockClient((_) async => http.Response(
          '{"current":{"temperature_2m":24,"precipitation":0.4}}', 200)));
      final clima = await api.actual();
      expect(clima.temperatura, 24.0);
      expect(clima.lluvia, 0.4);
    });

    test('un código distinto de 200 es una Falla del servidor', () async {
      final api = OpenMeteoClimaRepository(
          MockClient((_) async => http.Response('caído', 503)));
      await expectLater(api.actual(), throwsA(fallaCon('servidor-503')));
    });

    test('sin red es una Falla sin-conexion', () async {
      final api = OpenMeteoClimaRepository(
          MockClient((_) async => throw const SocketException('sin red')));
      await expectLater(api.actual(), throwsA(fallaCon('sin-conexion')));
    });

    test('un error inesperado del cliente es una Falla sin-conexion', () async {
      final api = OpenMeteoClimaRepository(
          MockClient((_) async => throw const HandshakeException('tls')));
      await expectLater(api.actual(), throwsA(fallaCon('sin-conexion')));
    });

    test('un JSON roto es una Falla respuesta-invalida', () async {
      final api = OpenMeteoClimaRepository(
          MockClient((_) async => http.Response('{"otra":1}', 200)));
      await expectLater(api.actual(), throwsA(fallaCon('respuesta-invalida')));
    });
  });
}
