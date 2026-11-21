import 'package:express_bites/domain/entities/usuario.dart';

abstract interface class CuentaRepository {
  Stream<Usuario?> sesion();
  Future<void> registrar(String correo, String clave, Rol rol);
  Future<void> iniciar(String correo, String clave);
  Future<void> salir();
}
