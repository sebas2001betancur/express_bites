import 'package:express_bites/domain/repositories/preferencias_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasLocales implements PreferenciasRepository {
  final _prefs = SharedPreferencesAsync();

  @override
  Future<String?> leerTema() => _prefs.getString('tema');

  @override
  Future<void> guardarTema(String tema) => _prefs.setString('tema', tema);
}
