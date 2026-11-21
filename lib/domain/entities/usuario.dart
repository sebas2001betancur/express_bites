enum Rol {
  cliente,
  personal;

  static Rol desdeTexto(String? texto) =>
      texto == Rol.personal.name ? Rol.personal : Rol.cliente;
}

class Usuario {
  const Usuario({required this.uid, required this.correo, required this.rol});

  final String uid;
  final String correo;
  final Rol rol;
}
