import 'package:express_bites/domain/entities/usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Guarda la sesión (uid, correo y rol) cifrada con Keystore.
/// Nunca guarda la contraseña.
class SesionSegura {
  const SesionSegura([this._almacen = const FlutterSecureStorage()]);

  final FlutterSecureStorage _almacen;

  Future<void> guardar(Usuario usuario) async {
    await _almacen.write(key: 'uid', value: usuario.uid);
    await _almacen.write(key: 'correo', value: usuario.correo);
    await _almacen.write(key: 'rol', value: usuario.rol.name);
  }

  Future<Usuario?> leer() async {
    final uid = await _almacen.read(key: 'uid');
    if (uid == null) return null;
    return Usuario(
      uid: uid,
      correo: await _almacen.read(key: 'correo') ?? '',
      rol: Rol.desdeTexto(await _almacen.read(key: 'rol')),
    );
  }

  Future<void> borrar() async {
    for (final clave in const ['uid', 'correo', 'rol']) {
      await _almacen.delete(key: clave);
    }
  }
}
