import 'package:express_bites/presentation/comun/estados.dart';
import 'package:express_bites/presentation/comun/formato.dart';
import 'package:express_bites/presentation/pedidos/pedidos_cliente_view_model.dart';
import 'package:express_bites/presentation/pedidos/ticket_pantalla.dart';
import 'package:flutter/material.dart';

class HistorialPantalla extends StatelessWidget {
  const HistorialPantalla({super.key, required this.seguimiento});

  final PedidosClienteViewModel seguimiento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos recientes')),
      body: ListenableBuilder(
        listenable: seguimiento,
        builder: (context, _) {
          final lista = seguimiento.lista;
          final error = seguimiento.error;
          if (lista == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (error != null && lista.isEmpty) {
            return EstadoMensaje(icono: Icons.cloud_off, texto: error);
          }
          if (lista.isEmpty) {
            return const EstadoMensaje(
                icono: Icons.history, texto: 'Todavía no tienes pedidos');
          }
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final p = lista[i];
              return ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text('${p.claimId} · ${formatoPrecio(p.total)}'),
                subtitle: Text('${formatoFecha(p.creado)} · recogida '
                    '${formatoHora(p.recogida)} · ${p.estado.etiqueta}'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TicketPantalla(inicial: p, seguimiento: seguimiento),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
