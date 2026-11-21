class Clima {
  const Clima({required this.temperatura, required this.lluvia});

  final double temperatura;
  final double lluvia;

  String get categoriaSugerida =>
      (lluvia > 0 || temperatura < 20) ? 'Bebidas calientes' : 'Bebidas frías';
}
