import 'package:flutter/material.dart';

class TicketDigital extends StatelessWidget {
  final String claimId;
  final String franjaRecogida;
  final double total;

  const TicketDigital({
    super.key,
    required this.claimId,
    required this.franjaRecogida,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedido confirmado')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '¡Tu pedido quedó confirmado!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    const Text('Claim ID'),
                    const SizedBox(height: 8),
                    Text(
                      claimId,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    Text('Recogida: $franjaRecogida'),
                    const SizedBox(height: 8),
                    Text('Total: \$${total.toStringAsFixed(0)}'),
                    const SizedBox(height: 12),
                    const Text(
                      'Muestra este Claim ID en el mostrador para recibir tu pedido.',
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Volver al catálogo'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
