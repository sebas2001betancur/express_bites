import 'package:flutter/material.dart';

import '../models/producto.dart';
import 'ticket_digital.dart';

class PantallaCarrito extends StatefulWidget {
  final List<Producto> carrito;

  const PantallaCarrito({super.key, required this.carrito});

  @override
  State<PantallaCarrito> createState() => _PantallaCarritoState();
}

class _PantallaCarritoState extends State<PantallaCarrito> {
  TimeOfDay? _horaRecogida;

  double get _total => widget.carrito.fold(0, (suma, p) => suma + p.precio);

  Future<void> _elegirHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() => _horaRecogida = hora);
    }
  }

  void _confirmarPedido() {
    if (widget.carrito.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Tu carrito está vacío')));
      return;
    }
    if (_horaRecogida == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elige una franja de recogida (Pick&Go)')),
      );
      return;
    }

    final claimId = 'EB-${100 + widget.carrito.length}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDigital(
          claimId: claimId,
          franjaRecogida: _horaRecogida!.format(context),
          total: _total,
        ),
      ),
    ).then((_) {
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tu carrito')),
      body: widget.carrito.isEmpty
          ? const Center(child: Text('Todavía no has agregado productos'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.carrito.length,
                    itemBuilder: (context, index) {
                      final producto = widget.carrito[index];
                      return ListTile(
                        title: Text(producto.nombre),
                        trailing: Text(
                          '\$${producto.precio.toStringAsFixed(0)}',
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _elegirHora,
                        icon: const Icon(Icons.access_time),
                        label: Text(
                          _horaRecogida == null
                              ? 'Elegir franja de recogida (Pick&Go)'
                              : 'Recoger a las ${_horaRecogida!.format(context)}',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total'),
                          Text(
                            '\$${_total.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _confirmarPedido,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Confirmar pedido'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
