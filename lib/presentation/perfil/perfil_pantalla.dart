import 'package:express_bites/domain/entities/usuario.dart';
import 'package:express_bites/presentation/cuenta/cuenta_view_model.dart';
import 'package:express_bites/presentation/pedidos/historial_pantalla.dart';
import 'package:express_bites/presentation/pedidos/pedidos_cliente_view_model.dart';
import 'package:express_bites/presentation/tema/tema_view_model.dart';
import 'package:flutter/material.dart';

class PerfilPantalla extends StatelessWidget {
  const PerfilPantalla({
    super.key,
    required this.usuario,
    required this.cuenta,
    required this.tema,
    this.seguimiento,
  });

  final Usuario usuario;
  final CuentaViewModel cuenta;
  final TemaViewModel tema;
  final PedidosClienteViewModel? seguimiento;

  @override
  Widget build(BuildContext context) {
    final historial = seguimiento;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: ListenableBuilder(
        listenable: tema,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 48)),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Correo electrónico'),
                    subtitle: Text(usuario.correo),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('Tipo de cuenta'),
                    subtitle: Text(usuario.rol == Rol.cliente ? 'Cliente' : 'Personal de barra'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Tema de la app', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.light, label: Text('Claro'), icon: Icon(Icons.light_mode)),
                ButtonSegment(value: ThemeMode.system, label: Text('Sistema')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Oscuro'), icon: Icon(Icons.dark_mode)),
              ],
              selected: {tema.modo},
              onSelectionChanged: (s) => tema.cambiar(s.first),
            ),
            const SizedBox(height: 24),
            if (historial != null)
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HistorialPantalla(seguimiento: historial)),
                ),
                icon: const Icon(Icons.history),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Pedidos recientes'),
                ),
              ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                // Primero cerrar las pantallas abiertas; la raíz muestra el login.
                Navigator.popUntil(context, (ruta) => ruta.isFirst);
                cuenta.salir();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
