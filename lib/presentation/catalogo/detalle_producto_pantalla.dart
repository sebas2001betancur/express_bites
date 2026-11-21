import 'package:express_bites/domain/entities/item_pedido.dart';
import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/presentation/comun/formato.dart';
import 'package:express_bites/presentation/comun/mensajes.dart';
import 'package:flutter/material.dart';

class DetalleProductoPantalla extends StatefulWidget {
  const DetalleProductoPantalla({super.key, required this.producto});

  final Producto producto;

  @override
  State<DetalleProductoPantalla> createState() =>
      _DetalleProductoPantallaState();
}

class _DetalleProductoPantallaState extends State<DetalleProductoPantalla> {
  String? _tamano;
  String? _leche;
  final Set<String> _extras = {};
  final _notas = TextEditingController();

  int get _precio => precioPersonalizado(
    widget.producto,
    tamano: _tamano,
    leche: _leche,
    extras: _extras.toList(),
  );

  @override
  void dispose() {
    _notas.dispose();
    super.dispose();
  }

  void _agregar() {
    try {
      final item = armarItem(
        widget.producto,
        tamano: _tamano,
        leche: _leche,
        extras: _extras.toList(),
        notas: _notas.text,
      );
      Navigator.pop(context, item);
    } on Falla catch (f) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensajeDe(f.codigo))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del producto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: tema.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.restaurant, size: 90),
          ),
          const SizedBox(height: 20),
          Text(producto.nombre, style: tema.textTheme.headlineSmall),
          Text(producto.categoria, style: tema.textTheme.bodyMedium),
          Text(
            formatoPrecio(producto.precio),
            style: tema.textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Text('Tamaño *', style: tema.textTheme.titleMedium),
          RadioGroup<String>(
            groupValue: _tamano,
            onChanged: (v) => setState(() => _tamano = v),
            child: Column(
              children: [
                for (final e in recargoTamano.entries)
                  RadioListTile<String>(
                    value: e.key,
                    title: Text(
                      e.value == 0
                          ? e.key
                          : '${e.key} (+${formatoPrecio(e.value)})',
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('Tipo de leche', style: tema.textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _leche,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Selecciona una opción',
            ),
            items: [
              for (final e in recargoLeche.entries)
                DropdownMenuItem(
                  value: e.key,
                  child: Text(
                    e.value == 0
                        ? e.key
                        : '${e.key} (+${formatoPrecio(e.value)})',
                  ),
                ),
            ],
            onChanged: (v) => setState(() => _leche = v),
          ),
          const SizedBox(height: 12),
          for (final e in recargoExtra.entries)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e.key),
              subtitle: Text('+${formatoPrecio(e.value)}'),
              value: _extras.contains(e.key),
              onChanged: (v) => setState(
                () => v == true ? _extras.add(e.key) : _extras.remove(e.key),
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _notas,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Notas del pedido',
              hintText: 'Ej. poca azúcar',
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _agregar,
            icon: const Icon(Icons.add_shopping_cart),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('Agregar · ${formatoPrecio(_precio)}'),
            ),
          ),
        ),
      ),
    );
  }
}
