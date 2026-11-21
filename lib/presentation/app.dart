import 'package:express_bites/presentation/dependencias.dart';
import 'package:express_bites/presentation/raiz_pantalla.dart';
import 'package:express_bites/presentation/tema/tema_view_model.dart';
import 'package:flutter/material.dart';

class ExpressBitesApp extends StatelessWidget {
  const ExpressBitesApp({super.key, required this.dependencias, required this.tema});

  final Dependencias dependencias;
  final TemaViewModel tema;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: tema,
      builder: (context, _) => MaterialApp(
        title: 'ExpressBites',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepOrange, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        themeMode: tema.modo,
        home: RaizPantalla(dependencias: dependencias, tema: tema),
      ),
    );
  }
}
