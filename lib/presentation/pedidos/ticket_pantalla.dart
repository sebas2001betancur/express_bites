import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/presentation/comun/formato.dart';
import 'package:express_bites/presentation/pedidos/pedidos_cliente_view_model.dart';
import 'package:flutter/material.dart';

class TicketPantalla extends StatelessWidget {
  const TicketPantalla({
    super.key,
    required this.inicial,
    required this.seguimiento,
  });

  final Pedido inicial;
  final PedidosClienteViewModel seguimiento;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return ListenableBuilder(
      listenable: seguimiento,
      builder: (context, _) {
        final pedido = seguimiento.buscar(inicial.id) ?? inicial;
        final listo = pedido.estado == EstadoPedido.listo;
        return Scaffold(
          appBar: AppBar(title: const Text('Ticket digital')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        listo ? Icons.notifications_active : Icons.check_circle,
                        color: Colors.green,
                        size: 56,
                      ),
                      const SizedBox(height: 12),
                      const Text('Claim ID'),
                      SelectableText(
                        pedido.claimId,
                        style: tema.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Chip(label: Text(pedido.estado.etiqueta)),
                      if (pedido.pendiente)
                        const Text('Pendiente de enviar al servidor'),
                      const SizedBox(height: 8),
                      Text(
                        'Recogida: ${formatoHora(pedido.recogida)} · '
                        '${formatoFecha(pedido.recogida)}',
                      ),
                      const Divider(height: 32),
                      for (final item in pedido.items)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text('${item.cantidad} × ${item.nombre}'),
                          subtitle: Text(
                            [
                              item.descripcion,
                              if (item.notas.isNotEmpty) 'Notas: ${item.notas}',
                            ].join('\n'),
                          ),
                          trailing: Text(formatoPrecio(item.subtotal)),
                        ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total'),
                          Text(
                            formatoPrecio(pedido.total),
                            style: tema.textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Muestra este código en la barra. El ticket queda guardado en tu '
                'teléfono y puedes abrirlo sin internet.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
