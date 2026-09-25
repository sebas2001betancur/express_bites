import 'package:flutter/material.dart';

import '../data/catalogo_datos.dart';
import '../models/producto.dart';
import '../widgets/producto_card.dart';
import 'detalle_producto.dart';
import 'pantalla_carrito.dart';
import 'ticket_offline.dart';

class PantallaCatalogo extends StatefulWidget {
  const PantallaCatalogo({super.key});

  @override
  State<PantallaCatalogo> createState() => _PantallaCatalogoState();
}

class _PantallaCatalogoState extends State<PantallaCatalogo> {
  String? _categoriaSeleccionada;
  final List<Producto> _carrito = [];

  Future<void> _abrirDetalle(Producto producto) async {
    final agregado = await Navigator.push<Producto>(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleProducto(producto: producto),
      ),
    );
    if (agregado != null) {
      setState(() => _carrito.add(agregado));
    }
  }

  Future<void> _abrirCarrito() async {
    final confirmado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaCarrito(carrito: _carrito),
      ),
    );
    if (confirmado == true) {
      setState(() => _carrito.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorias = catalogoEjemplo.map((p) => p.categoria).toSet().toList();
    final productos = _categoriaSeleccionada == null
        ? catalogoEjemplo
        : catalogoEjemplo
              .where((p) => p.categoria == _categoriaSeleccionada)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpressBites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Ticket activo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TicketOffline(
                    claimId: 'EB-000',
                    franjaRecogida: 'Todavía no tienes un pedido confirmado',
                  ),
                ),
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                tooltip: 'Carrito',
                onPressed: _abrirCarrito,
              ),
              if (_carrito.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Theme.of(context).colorScheme.error,
                    child: Text(
                      '${_carrito.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: const Text('Todas'),
                      selected: _categoriaSeleccionada == null,
                      onSelected: (_) =>
                          setState(() => _categoriaSeleccionada = null),
                    ),
                  ),
                  ...categorias.map(
                    (categoria) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(categoria),
                        selected: _categoriaSeleccionada == categoria,
                        onSelected: (_) =>
                            setState(() => _categoriaSeleccionada = categoria),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${productos.length} productos disponibles',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: productos.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48),
                          SizedBox(height: 8),
                          Text('No hay productos disponibles'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        return ProductoCard(
                          producto: producto,
                          onVerDetalle: () => _abrirDetalle(producto),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
