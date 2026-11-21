import 'package:flutter/material.dart';

class EstadoMensaje extends StatelessWidget {
  const EstadoMensaje({
    super.key,
    required this.icono,
    required this.texto,
    this.accion,
    this.alPresionar,
  });

  final IconData icono;
  final String texto;
  final String? accion;
  final VoidCallback? alPresionar;

  @override
  Widget build(BuildContext context) {
    final etiqueta = accion;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56),
            const SizedBox(height: 12),
            Text(texto, textAlign: TextAlign.center),
            if (etiqueta != null) ...[
              const SizedBox(height: 12),
              FilledButton(onPressed: alPresionar, child: Text(etiqueta)),
            ],
          ],
        ),
      ),
    );
  }
}

class AvisoSinConexion extends StatelessWidget {
  const AvisoSinConexion({
    super.key,
    this.texto = 'Sin conexión: mostrando lo último guardado en el teléfono',
  });

  final String texto;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colores.errorContainer,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(Icons.wifi_off, size: 18, color: colores.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(texto, style: TextStyle(color: colores.onErrorContainer)),
          ),
        ],
      ),
    );
  }
}
