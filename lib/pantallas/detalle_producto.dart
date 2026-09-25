import 'package:flutter/material.dart';

import '../models/producto.dart';

class DetalleProducto extends StatefulWidget {
  final Producto producto;

  const DetalleProducto({super.key, required this.producto});

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  String? _tamanoSeleccionado;
  String? _lecheSeleccionada;
  bool _extraCafe = false;
  bool _extraCanela = false;
  final TextEditingController _notasController = TextEditingController();

  double get _precioFinal {
    double precio = widget.producto.precio;
    if (_tamanoSeleccionado == 'Grande') precio += 2000;
    if (_tamanoSeleccionado == 'Mediano') precio += 1000;
    if (_extraCafe) precio += 1500;
    if (_extraCanela) precio += 500;
    return precio;
  }

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  void _agregarAlCarrito() {
    if (_tamanoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un tamaño antes de continuar'),
        ),
      );
      return;
    }

    final extras = [
      if (_extraCafe) 'extra café',
      if (_extraCanela) 'canela',
    ].join(', ');

    final productoPersonalizado = Producto(
      id: widget.producto.id,
      nombre:
          '${widget.producto.nombre} ($_tamanoSeleccionado${extras.isNotEmpty ? ', $extras' : ''})',
      categoria: widget.producto.categoria,
      precio: _precioFinal,
      minutosPreparacion: widget.producto.minutosPreparacion,
    );

    Navigator.pop(context, productoPersonalizado);
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del producto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.restaurant, size: 90),
            ),
            const SizedBox(height: 20),
            Text(
              producto.nombre,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              producto.categoria,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${producto.precio.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Text('Tamaño', style: Theme.of(context).textTheme.titleMedium),
            RadioGroup<String>(
              groupValue: _tamanoSeleccionado,
              onChanged: (value) => setState(() => _tamanoSeleccionado = value),
              child: const Column(
                children: [
                  RadioListTile<String>(
                    title: Text('Pequeño'),
                    value: 'Pequeño',
                  ),
                  RadioListTile<String>(
                    title: Text('Mediano (+\$1.000)'),
                    value: 'Mediano',
                  ),
                  RadioListTile<String>(
                    title: Text('Grande (+\$2.000)'),
                    value: 'Grande',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tipo de leche',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            DropdownButtonFormField<String>(
              value: _lecheSeleccionada,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Selecciona una opción',
              ),
              items: const [
                DropdownMenuItem(value: 'Entera', child: Text('Entera')),
                DropdownMenuItem(
                  value: 'Deslactosada',
                  child: Text('Deslactosada'),
                ),
                DropdownMenuItem(value: 'Almendras', child: Text('Almendras')),
              ],
              onChanged: (value) => setState(() => _lecheSeleccionada = value),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Extra de café'),
              subtitle: const Text('+\$1.500'),
              value: _extraCafe,
              onChanged: (value) => setState(() => _extraCafe = value ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Canela'),
              subtitle: const Text('+\$500'),
              value: _extraCanela,
              onChanged: (value) =>
                  setState(() => _extraCanela = value ?? false),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notasController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Notas del pedido',
                hintText: 'Ej. poca azúcar',
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Precio total'),
                    Text(
                      '\$${_precioFinal.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _agregarAlCarrito,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al carrito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
