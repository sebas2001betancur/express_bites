abstract interface class PreferenciasRepository {
  Future<String?> leerTema();
  Future<void> guardarTema(String tema);
}
