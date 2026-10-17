import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  bool enCarrito = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          width: enCarrito ? 280 : 220,
          padding: EdgeInsets.all(enCarrito ? 24 : 12),
          decoration: BoxDecoration(
            color: enCarrito ? Colors.green.shade100 : Colors.white,
            border: Border.all(
              color: enCarrito ? Colors.green : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(enCarrito ? 24 : 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                enCarrito ? Icons.check_circle : Icons.shopping_basket,
                size: 48,
                color: Colors.green,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tomate chonto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text('\$3.500 la libra'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    enCarrito = !enCarrito;
                  });
                },
                child: Text(
                  enCarrito ? 'Quitar del carrito' : 'Agregar al carrito',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
