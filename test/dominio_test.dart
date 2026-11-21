import 'package:express_bites/domain/entities/clima.dart';
import 'package:express_bites/domain/entities/item_pedido.dart';
import 'package:express_bites/domain/entities/nuevo_pedido.dart';
import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:flutter_test/flutter_test.dart';

const cafe = Producto(
  id: 'p1',
  nombre: 'Cappuccino',
  categoria: 'Bebidas calientes',
  precio: 4500,
  minutosPreparacion: 5,
);

Matcher fallaCon(String codigo) =>
    isA<Falla>().having((f) => f.codigo, 'codigo', codigo);

void main() {
  group('Personalización (RN-01, RN-02)', () {
    test('sin tamaño no se puede armar el ítem', () {
      expect(() => armarItem(cafe), throwsA(fallaCon('tamano-requerido')));
    });

    test('el precio suma tamaño, leche y extras', () {
      expect(
        precioPersonalizado(
          cafe,
          tamano: 'Grande',
          leche: 'Almendras',
          extras: ['Extra de café', 'Canela'],
        ),
        4500 + 2000 + 1000 + 1500 + 500,
      );
    });

    test('el ítem guarda leche y notas recortadas', () {
      final item = armarItem(
        cafe,
        tamano: 'Mediano',
        leche: 'Deslactosada',
        notas: '  poca azúcar ',
      );
      expect(item.leche, 'Deslactosada');
      expect(item.notas, 'poca azúcar');
      expect(item.precioUnitario, 4500 + 1000 + 500);
      expect(item.descripcion, 'Mediano, leche Deslactosada');
    });

    test('la cantidad multiplica el subtotal', () {
      final item = armarItem(cafe, tamano: 'Pequeño').conCantidad(3);
      expect(item.subtotal, 4500 * 3);
    });
  });

  group('NuevoPedido (RN-03, RN-04)', () {
    final ahora = DateTime(2026, 11, 20, 10, 0);
    final item = armarItem(cafe, tamano: 'Pequeño');

    test('rechaza un carrito vacío', () {
      expect(
        () => NuevoPedido(
          items: const [],
          recogida: ahora.add(const Duration(minutes: 30)),
          ahora: ahora,
        ),
        throwsA(fallaCon('carrito-vacio')),
      );
    });

    test('rechaza una recogida a menos de 15 minutos', () {
      expect(
        () => NuevoPedido(
          items: [item],
          recogida: ahora.add(const Duration(minutes: 14)),
          ahora: ahora,
        ),
        throwsA(fallaCon('hora-invalida')),
      );
    });

    test('acepta exactamente 15 minutos y calcula el total', () {
      final pedido = NuevoPedido(
        items: [item, item.conCantidad(2)],
        recogida: ahora.add(const Duration(minutes: 15)),
        ahora: ahora,
      );
      expect(pedido.total, 4500 * 3);
    });
  });

  group('Pedido (RN-05)', () {
    test('el Claim ID sale del id del documento', () {
      expect(claimIdDe('a1b2c3d4e5f6'), 'EB-A1B2C3D4');
    });

    test('ids distintos dan Claim ID distintos', () {
      expect(claimIdDe('abcdefgh123'), isNot(claimIdDe('abcdefgi123')));
    });

    test('lee el estado desde su código', () {
      expect(EstadoPedido.desdeCodigo('listo'), EstadoPedido.listo);
      expect(EstadoPedido.desdeCodigo('raro'), EstadoPedido.enPreparacion);
    });
  });

  test('Clima sugiere bebidas según temperatura y lluvia', () {
    expect(
      const Clima(temperatura: 26, lluvia: 0).categoriaSugerida,
      'Bebidas frías',
    );
    expect(
      const Clima(temperatura: 26, lluvia: 1.2).categoriaSugerida,
      'Bebidas calientes',
    );
    expect(
      const Clima(temperatura: 17, lluvia: 0).categoriaSugerida,
      'Bebidas calientes',
    );
  });
}
