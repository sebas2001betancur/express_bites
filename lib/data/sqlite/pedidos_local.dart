import 'package:express_bites/data/dtos/pedido_dto.dart';
import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:sqflite/sqflite.dart';

/// Copia de los pedidos del cliente para ver el ticket y el historial sin internet.
class PedidosLocal {
  PedidosLocal(this._db);

  final Database _db;

  Future<List<Pedido>> leerMios(String uid) async {
    try {
      final filas = await _db.query(
        'pedidos',
        where: 'uid = ?',
        whereArgs: [uid],
        orderBy: 'creado DESC',
      );
      return filas.map(PedidoDto.desdeFila).toList();
    } on DatabaseException {
      throw const Falla('base-local');
    }
  }

  Future<void> guardar(Pedido pedido) async {
    try {
      await _db.insert(
        'pedidos',
        PedidoDto.aFila(pedido),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on DatabaseException {
      throw const Falla('base-local');
    }
  }

  Future<void> reemplazarMios(String uid, List<Pedido> pedidos) async {
    try {
      await _db.transaction((txn) async {
        final lote = txn.batch();
        lote.delete('pedidos', where: 'uid = ?', whereArgs: [uid]);
        for (final p in pedidos) {
          lote.insert('pedidos', PedidoDto.aFila(p));
        }
        await lote.commit(noResult: true);
      });
    } on DatabaseException {
      throw const Falla('base-local');
    }
  }
}
