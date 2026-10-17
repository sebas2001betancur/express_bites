import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  bool grande = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          width: grande ? 200 : 100,
          height: grande ? 200 : 100,
          color: grande ? Colors.green : Colors.orange,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            grande = !grande;
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
