import 'package:express_bites/domain/entities/producto.dart';

/// Menú de ejemplo que el personal carga una vez en Firestore.
const menuInicial = [
  Producto(id: 'p1', nombre: 'Café Americano', categoria: 'Bebidas calientes', precio: 3500, minutosPreparacion: 3),
  Producto(id: 'p2', nombre: 'Cappuccino', categoria: 'Bebidas calientes', precio: 4500, minutosPreparacion: 5),
  Producto(id: 'p3', nombre: 'Jugo de Mora', categoria: 'Bebidas frías', precio: 4000, minutosPreparacion: 4),
  Producto(id: 'p4', nombre: 'Limonada de Coco', categoria: 'Bebidas frías', precio: 5500, minutosPreparacion: 4),
  Producto(id: 'p5', nombre: 'Croissant', categoria: 'Repostería', precio: 3000, minutosPreparacion: 2),
  Producto(id: 'p6', nombre: 'Combo Desayuno', categoria: 'Combos', precio: 9000, minutosPreparacion: 8),
  Producto(id: 'p7', nombre: 'Arepa de Chócolo con Queso', categoria: 'Especiales del día', precio: 6000, minutosPreparacion: 7),
];
