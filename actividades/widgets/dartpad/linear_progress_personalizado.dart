import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  // Cada etapa del pedido suma un 25 % a la barra.
  final List<String> etapas = [
    'Pedido recibido',
    'Alistando productos',
    'En camino',
    'Entregado',
  ];
  double progreso = 0.25;

  void avanzar() {
    setState(() {
      progreso = progreso >= 1.0 ? 0.25 : progreso + 0.25;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int etapa = (progreso * 4).round() - 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                etapas[etapa],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progreso,
                minHeight: 14,
                color: Colors.green,
                backgroundColor: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 8),
              Text('${(progreso * 100).round()} %'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: avanzar,
                child: const Text('Avanzar pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
