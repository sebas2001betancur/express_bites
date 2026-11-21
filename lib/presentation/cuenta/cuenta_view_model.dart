import 'dart:async';

import 'package:express_bites/domain/entities/usuario.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/domain/repositories/cuenta_repository.dart';
import 'package:express_bites/presentation/comun/mensajes.dart';
import 'package:flutter/foundation.dart';

class CuentaViewModel extends ChangeNotifier {
  CuentaViewModel(this._repository) {
    _suscripcion = _repository.sesion().listen(
      (u) {
        usuario = u;
        cargando = false;
        _notificar();
      },
      onError: (Object _) {
        usuario = null;
        cargando = false;
        error = 'No se pudo leer tu sesión. Revisa tu conexión';
        _notificar();
      },
    );
  }

  final CuentaRepository _repository;
  StreamSubscription<Usuario?>? _suscripcion;
  bool _cerrado = false;

  Usuario? usuario;
  bool cargando = true;
  bool enviando = false;
  String? error;

  Future<void> registrar(String correo, String clave, Rol rol) =>
      _ejecutar(() => _repository.registrar(correo.trim(), clave, rol));

  Future<void> iniciar(String correo, String clave) =>
      _ejecutar(() => _repository.iniciar(correo.trim(), clave));

  Future<void> salir() => _ejecutar(_repository.salir);

  Future<void> _ejecutar(Future<void> Function() accion) async {
    error = null;
    enviando = true;
    _notificar();
    try {
      await accion();
    } on Falla catch (f) {
      error = mensajeDe(f.codigo);
    }
    enviando = false;
    _notificar();
  }

  void _notificar() {
    if (!_cerrado) notifyListeners();
  }

  @override
  void dispose() {
    _cerrado = true;
    _suscripcion?.cancel();
    super.dispose();
  }
}
