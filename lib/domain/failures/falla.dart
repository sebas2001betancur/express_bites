/// Error del dominio. Solo lleva un código; el mensaje lo decide la presentación.
class Falla implements Exception {
  const Falla(this.codigo);

  final String codigo;

  @override
  String toString() => 'Falla($codigo)';
}
