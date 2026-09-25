import 'package:flutter/material.dart';

class PantallaPedidosPersonal extends StatelessWidget {
  const PantallaPedidosPersonal({super.key});

  @override
  Widget build(BuildContext context) {
    final pedidosEjemplo = [
      {
        'claimId': 'EB-101',
        'producto': 'Cappuccino (Grande)',
        'franja': '10:15 a. m.',
      },
      {'claimId': 'EB-102', 'producto': 'Croissant', 'franja': '10:20 a. m.'},
      {
        'claimId': 'EB-103',
        'producto': 'Combo Desayuno',
        'franja': '10:30 a. m.',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos entrantes')),
      body: ListView.builder(
        itemCount: pedidosEjemplo.length,
        itemBuilder: (context, index) {
          final pedido = pedidosEjemplo[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text(pedido['producto']!),
              subtitle: Text(
                'Claim ID: ${pedido['claimId']} · Recogida: ${pedido['franja']}',
              ),
              trailing: OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pedido validado'),
                      content: Text(
                        'Claim ID ${pedido['claimId']} entregado correctamente.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Validar'),
              ),
            ),
          );
        },
      ),
    );
  }
}
