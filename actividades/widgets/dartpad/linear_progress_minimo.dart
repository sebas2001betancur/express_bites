import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatelessWidget {
  const Prueba({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: LinearProgressIndicator(value: 0.6),
        ),
      ),
    );
  }
}
