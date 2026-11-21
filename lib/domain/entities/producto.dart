class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.minutosPreparacion,
    this.disponible = true,
  });

  final String id;
  final String nombre;
  final String categoria;
  final int precio;
  final int minutosPreparacion;
  final bool disponible;

  Producto conDisponible(bool valor) => Producto(
        id: id,
        nombre: nombre,
        categoria: categoria,
        precio: precio,
        minutosPreparacion: minutosPreparacion,
        disponible: valor,
      );
}
