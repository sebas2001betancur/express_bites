import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/presentation/comun/formato.dart';
import 'package:flutter/material.dart';

class ProductoCard extends StatelessWidget {
  const ProductoCard({super.key, required this.producto, required this.onVerDetalle});

  final Producto producto;
  final VoidCallback onVerDetalle;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onVerDetalle,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: tema.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.restaurant, size: 36, color: tema.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(producto.nombre,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tema.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(producto.categoria, style: tema.textTheme.bodySmall),
                    Text('${producto.minutosPreparacion} min',
                        style: tema.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(formatoPrecio(producto.precio), style: tema.textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
