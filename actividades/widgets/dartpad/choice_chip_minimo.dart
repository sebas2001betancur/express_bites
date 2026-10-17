import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  bool seleccionado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: Center(
        child: ChoiceChip(
          label: const Text('Frutas'),
          selected: seleccionado,
          onSelected: (valor) {
            setState(() {
              seleccionado = valor;
            });
          },
        ),
      ),
    );
  }
}
