import 'package:express_bites/domain/entities/clima.dart';
import 'package:express_bites/presentation/catalogo/catalogo_view_model.dart';
import 'package:flutter/material.dart';

class ClimaTarjeta extends StatelessWidget {
  const ClimaTarjeta({super.key, required this.viewModel});

  final CatalogoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final Widget contenido = switch (viewModel.estadoClima) {
      EstadoClima.cargando => const ListTile(
          leading: SizedBox(
              width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
          title: Text('Consultando el clima del campus...'),
        ),
      EstadoClima.error => ListTile(
          leading: const Icon(Icons.cloud_off),
          title: Text(viewModel.errorClima ?? 'No se pudo consultar el clima'),
          trailing: TextButton(
              onPressed: viewModel.cargarClima, child: const Text('Reintentar')),
        ),
      EstadoClima.listo => _listo(viewModel.clima!),
    };
    return Card(margin: const EdgeInsets.fromLTRB(12, 8, 12, 4), child: contenido);
  }

  Widget _listo(Clima clima) => ListTile(
        leading: const Icon(Icons.wb_sunny_outlined),
        title: Text('${clima.temperatura.toStringAsFixed(1)} °C · '
            'lluvia ${clima.lluvia.toStringAsFixed(1)} mm'),
        subtitle: Text('Hoy te recomendamos: ${clima.categoriaSugerida}'),
        trailing: TextButton(
          onPressed: () => viewModel.filtrar(clima.categoriaSugerida),
          child: const Text('Ver'),
        ),
      );
}
