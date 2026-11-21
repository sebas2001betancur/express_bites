import 'package:express_bites/presentation/carrito/carrito_view_model.dart';
import 'package:express_bites/presentation/catalogo/catalogo_view_model.dart';
import 'package:express_bites/presentation/comun/estados.dart';
import 'package:express_bites/presentation/comun/formato.dart';
import 'package:express_bites/presentation/pedidos/pedidos_cliente_view_model.dart';
import 'package:express_bites/presentation/pedidos/ticket_pantalla.dart';
import 'package:flutter/material.dart';

class CarritoPantalla extends StatelessWidget {
  const CarritoPantalla({
    super.key,
    required this.carrito,
    required this.catalogo,
    required this.seguimiento,
  });

  final CarritoViewModel carrito;
  final CatalogoViewModel catalogo;
  final PedidosClienteViewModel seguimiento;

  static const _quince = Duration(minutes: 15);
  static const _treinta = Duration(minutes: 30);

  Future<void> _elegirHora(BuildContext context) async {
    final elegida = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 20))),
    );
    if (elegida == null) return;
    final hoy = DateTime.now();
    carrito.elegirHora(
        DateTime(hoy.year, hoy.month, hoy.day, elegida.hour, elegida.minute));
  }

  Future<void> _confirmar(BuildContext context) async {
    final pedido = await carrito.confirmar();
    if (pedido == null || !context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TicketPantalla(inicial: pedido, seguimiento: seguimiento),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([carrito, catalogo]),
      builder: (context, _) {
        final items = carrito.items;
        return Scaffold(
          appBar: AppBar(title: const Text('Tu carrito')),
          body: items.isEmpty
              ? const EstadoMensaje(
                  icono: Icons.shopping_cart_outlined,
                  texto: 'Todavía no has agregado productos')
              : Column(
                  children: [
                    if (catalogo.sinConexion)
                      const AvisoSinConexion(
                          texto: 'Sin conexión: tu carrito se conserva, pero '
                              'confirmar el pedido necesita internet'),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final item = items[i];
                          return ListTile(
                            title: Text(item.nombre),
                            subtitle: Text([
                              item.descripcion,
                              if (item.notas.isNotEmpty) 'Notas: ${item.notas}',
                              formatoPrecio(item.subtotal),
                            ].join('\n')),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Quitar uno',
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => carrito.cambiarCantidad(i, -1),
                                ),
                                Text('${item.cantidad}'),
                                IconButton(
                                  tooltip: 'Agregar uno',
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => carrito.cambiarCantidad(i, 1),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    _resumen(context),
                  ],
                ),
        );
      },
    );
  }

  Widget _resumen(BuildContext context) {
    final tema = Theme.of(context);
    final hora = carrito.horaFija;
    final error = carrito.error;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Franja de recogida (Pick & Go)', style: tema.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('En 15 min'),
                  selected: carrito.atajo == _quince,
                  onSelected: (_) => carrito.elegirAtajo(_quince),
                ),
                ChoiceChip(
                  label: const Text('En 30 min'),
                  selected: carrito.atajo == _treinta,
                  onSelected: (_) => carrito.elegirAtajo(_treinta),
                ),
                ActionChip(
                  avatar: const Icon(Icons.access_time),
                  label: Text(hora == null ? 'Otra hora' : 'A las ${formatoHora(hora)}'),
                  onPressed: () => _elegirHora(context),
                ),
              ],
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error, style: TextStyle(color: tema.colorScheme.error)),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text(formatoPrecio(carrito.total), style: tema.textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: catalogo.sinConexion || carrito.enviando
                  ? null
                  : () => _confirmar(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(carrito.enviando ? 'Enviando...' : 'Confirmar pedido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
