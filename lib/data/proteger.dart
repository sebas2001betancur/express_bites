import 'package:express_bites/domain/failures/falla.dart';
import 'package:firebase_core/firebase_core.dart';

/// Convierte los errores de Firebase en Falla para que el dominio no dependa de Firebase.
Future<T> proteger<T>(Future<T> Function() accion) async {
  try {
    return await accion();
  } on FirebaseException catch (e) {
    throw Falla(e.code);
  }
}
