import 'package:express_bites/domain/repositories/preferencias_repository.dart';
import 'package:flutter/material.dart';

class TemaViewModel extends ChangeNotifier {
  TemaViewModel(this._preferencias);

  final PreferenciasRepository _preferencias;
  ThemeMode modo = ThemeMode.system;

  Future<void> cargar() async {
    final guardado = await _preferencias.leerTema();
    modo = ThemeMode.values.firstWhere(
      (m) => m.name == guardado,
      orElse: () => ThemeMode.system,
    );
    notifyListeners();
  }

  Future<void> cambiar(ThemeMode nuevo) async {
    modo = nuevo;
    notifyListeners();
    await _preferencias.guardarTema(nuevo.name);
  }
}
