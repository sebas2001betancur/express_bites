import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_bites/data/dtos/pedido_dto.dart';
import 'package:express_bites/data/proteger.dart';
import 'package:express_bites/domain/entities/nuevo_pedido.dart';
import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/domain/repositories/pedidos_repository.dart';

class FirestorePedidosRepository implements PedidosRepository {
  final _coleccion = FirebaseFirestore.instance.collection('pedidos');

  @override
  String nuevoId() => _coleccion.doc().id;

  @override
  Future<Pedido> crear(String id, String uid, NuevoPedido nuevo) async {
    final pedido = Pedido(
      id: id,
      uid: uid,
      items: nuevo.items,
      total: nuevo.total,
      recogida: nuevo.recogida,
      creado: DateTime.now(),
    );
    // set con un id fijo: si se reintenta, se escribe el mismo documento.
    await proteger(() => _coleccion
        .doc(id)
        .set(PedidoDto.aFirestore(pedido))
        .timeout(const Duration(seconds: 8),
            onTimeout: () => throw const Falla('sin-conexion')));
    return pedido;
  }

  // Se ordena en el teléfono para no necesitar índices compuestos.
  @override
  Stream<List<Pedido>> observarMios(String uid) => _coleccion
      .where('uid', isEqualTo: uid)
      .snapshots()
      .map((datos) => datos.docs.map(PedidoDto.desdeFirestore).toList()
        ..sort((a, b) => b.creado.compareTo(a.creado)));

  @override
  Stream<List<Pedido>> observarActivos() => _coleccion
      .where('estado', whereIn: [
        EstadoPedido.enPreparacion.codigo,
        EstadoPedido.listo.codigo,
      ])
      .snapshots()
      .map((datos) => datos.docs.map(PedidoDto.desdeFirestore).toList()
        ..sort((a, b) => a.recogida.compareTo(b.recogida)));

  @override
  Future<void> cambiarEstado(String id, EstadoPedido estado) =>
      proteger(() => _coleccion.doc(id).update({'estado': estado.codigo}));
}
