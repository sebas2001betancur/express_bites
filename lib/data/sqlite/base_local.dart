import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> abrirBaseLocal() async {
  final ruta = join(await getDatabasesPath(), 'express_bites.db');
  return openDatabase(
    ruta,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE productos(id TEXT PRIMARY KEY, nombre TEXT, categoria TEXT, '
        'precio INTEGER, minutosPreparacion INTEGER, disponible INTEGER)',
      );
      await db.execute(
        'CREATE TABLE pedidos(id TEXT PRIMARY KEY, uid TEXT, items TEXT, '
        'total INTEGER, recogida INTEGER, creado INTEGER, estado TEXT)',
      );
    },
  );
}
