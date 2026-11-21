import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  final List<String> categorias = [
    'Todas',
    'Frutas',
    'Verduras',
    'Lácteos',
    'Granos',
  ];
  String seleccionada = 'Todas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de widget')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categorias.map((categoria) {
                  return ChoiceChip(
                    label: Text(categoria),
                    avatar: const Icon(Icons.eco),
                    selected: seleccionada == categoria,
                    onSelected: (_) {
                      setState(() {
                        seleccionada = categoria;
                      });
                    },
                    selectedColor: Colors.green.shade300,
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                'Mostrando: $seleccionada',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
