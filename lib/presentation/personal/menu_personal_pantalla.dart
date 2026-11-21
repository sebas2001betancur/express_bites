import 'package:express_bites/presentation/catalogo/catalogo_view_model.dart';
import 'package:express_bites/presentation/comun/estados.dart';
import 'package:express_bites/presentation/comun/formato.dart';
import 'package:express_bites/presentation/dependencias.dart';
import 'package:flutter/material.dart';

class MenuPersonalPantalla extends StatefulWidget {
  const MenuPersonalPantalla({super.key, required this.dependencias});

  final Dependencias dependencias;

  @override
  State<MenuPersonalPantalla> createState() => _MenuPersonalPantallaState();
}

class _MenuPersonalPantallaState extends State<MenuPersonalPantalla> {
  late final vm = CatalogoViewModel(productos: widget.dependencias.productos);

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú del día')),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          if (vm.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          final productos = vm.todos;
          final error = vm.error;
          return Column(
            children: [
              if (vm.sinConexion) const AvisoSinConexion(),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              Expanded(
                child: productos.isEmpty
                    ? EstadoMensaje(
                        icono: Icons.restaurant_menu,
                        texto: 'El menú está vacío',
                        accion: 'Cargar menú de ejemplo',
                        alPresionar: () => vm.cargarMenuInicial(
                          widget.dependencias.menuInicial,
                        ),
                      )
                    : ListView(
                        children: [
                          for (final p in productos)
                            SwitchListTile(
                              title: Text(p.nombre),
                              subtitle: Text(
                                '${p.categoria} · ${formatoPrecio(p.precio)}',
                              ),
                              value: p.disponible,
                              onChanged: (v) => vm.cambiarDisponible(p.id, v),
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
