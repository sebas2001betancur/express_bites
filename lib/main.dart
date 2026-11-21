import 'package:express_bites/data/api/open_meteo_clima_repository.dart';
import 'package:express_bites/data/avisos/avisos_locales.dart';
import 'package:express_bites/data/firestore/firebase_cuenta_repository.dart';
import 'package:express_bites/data/firestore/firestore_pedidos_repository.dart';
import 'package:express_bites/data/firestore/firestore_productos_repository.dart';
import 'package:express_bites/data/local/preferencias_locales.dart';
import 'package:express_bites/data/local/sesion_segura.dart';
import 'package:express_bites/data/menu_inicial.dart';
import 'package:express_bites/data/respaldo/pedidos_con_respaldo.dart';
import 'package:express_bites/data/respaldo/productos_con_respaldo.dart';
import 'package:express_bites/data/sqlite/base_local.dart';
import 'package:express_bites/data/sqlite/pedidos_local.dart';
import 'package:express_bites/data/sqlite/sqlite_productos_repository.dart';
import 'package:express_bites/firebase_options.dart';
import 'package:express_bites/presentation/app.dart';
import 'package:express_bites/presentation/dependencias.dart';
import 'package:express_bites/presentation/tema/tema_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await iniciarAvisos();
  final db = await abrirBaseLocal();

  // Fuente de productos intercambiable: para la demo de arquitectura se puede
  // poner FirestoreProductosRepository() o SqliteProductosRepository(db) y la
  // presentación no cambia.
  final productos = ProductosConRespaldo(
    nube: FirestoreProductosRepository(),
    local: SqliteProductosRepository(db),
  );

  final dependencias = Dependencias(
    cuenta: FirebaseCuentaRepository(const SesionSegura()),
    productos: productos,
    pedidos: PedidosConRespaldo(
      nube: FirestorePedidosRepository(),
      local: PedidosLocal(db),
    ),
    clima: OpenMeteoClimaRepository(),
    preferencias: PreferenciasLocales(),
    avisarPedidoListo: avisarPedidoListo,
    menuInicial: menuInicial,
  );

  final tema = TemaViewModel(dependencias.preferencias);
  await tema.cargar();

  runApp(ExpressBitesApp(dependencias: dependencias, tema: tema));
}
