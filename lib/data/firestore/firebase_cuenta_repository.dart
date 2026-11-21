import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_bites/data/local/sesion_segura.dart';
import 'package:express_bites/data/proteger.dart';
import 'package:express_bites/domain/entities/usuario.dart';
import 'package:express_bites/domain/repositories/cuenta_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCuentaRepository implements CuentaRepository {
  FirebaseCuentaRepository(this._sesion);

  final SesionSegura _sesion;
  final _auth = FirebaseAuth.instance;
  final _usuarios = FirebaseFirestore.instance.collection('usuarios');

  /// Rol elegido en un registro en curso: authStateChanges puede avisar antes
  /// de que el documento usuarios/{uid} exista.
  Rol? _rolDeRegistro;

  @override
  Stream<Usuario?> sesion() => _auth.authStateChanges().asyncMap((user) async {
    if (user == null) {
      await _sesion.borrar();
      return null;
    }
    final guardado = await _sesion.leer();
    final rolPendiente = _rolDeRegistro;
    final Usuario usuario;
    if (rolPendiente != null) {
      usuario = Usuario(
        uid: user.uid,
        correo: user.email ?? '',
        rol: rolPendiente,
      );
    } else if (guardado != null && guardado.uid == user.uid) {
      return guardado; // sin red también funciona
    } else {
      final doc = await proteger(() => _usuarios.doc(user.uid).get());
      usuario = Usuario(
        uid: user.uid,
        correo: user.email ?? '',
        rol: Rol.desdeTexto(doc.data()?['rol'] as String?),
      );
    }
    await _sesion.guardar(usuario);
    return usuario;
  });

  @override
  Future<void> registrar(String correo, String clave, Rol rol) async {
    _rolDeRegistro = rol;
    try {
      final credencial = await proteger(
        () => _auth.createUserWithEmailAndPassword(
          email: correo,
          password: clave,
        ),
      );
      final uid = credencial.user!.uid;
      await proteger(
        () => _usuarios.doc(uid).set({'correo': correo, 'rol': rol.name}),
      );
    } finally {
      _rolDeRegistro = null;
    }
  }

  @override
  Future<void> iniciar(String correo, String clave) => proteger(
    () => _auth.signInWithEmailAndPassword(email: correo, password: clave),
  );

  @override
  Future<void> salir() async {
    await _sesion.borrar();
    await proteger(_auth.signOut);
  }
}
