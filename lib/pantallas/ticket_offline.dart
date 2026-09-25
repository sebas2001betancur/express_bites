import 'package:flutter/material.dart';

class TicketOffline extends StatelessWidget {
  final String claimId;
  final String franjaRecogida;

  const TicketOffline({
    super.key,
    required this.claimId,
    required this.franjaRecogida,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket activo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.wifi_off, size: 50),
                    const SizedBox(height: 12),
                    const Text('Modo sin conexión'),
                    const SizedBox(height: 20),
                    const Text('Claim ID'),
                    const SizedBox(height: 8),
                    Text(
                      claimId,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    Text('Recogida: $franjaRecogida'),
                    const SizedBox(height: 12),
                    const Text('Estado: En preparación'),
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Volver al ticket'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
