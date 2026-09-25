import 'package:flutter/material.dart';

class PantallaPerfil extends StatefulWidget {
  final String correo;
  final String contrasena;

  const PantallaPerfil({
    super.key,
    required this.correo,
    required this.contrasena,
  });

  @override
  State<PantallaPerfil> createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  bool _mostrarContrasena = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            CircleAvatar(radius: 44, child: const Icon(Icons.person, size: 48)),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Correo electrónico'),
                    subtitle: Text(widget.correo),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Contraseña'),
                    subtitle: Text(
                      _mostrarContrasena
                          ? widget.contrasena
                          : '•' * widget.contrasena.length,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        _mostrarContrasena
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      tooltip: _mostrarContrasena ? 'Ocultar' : 'Mostrar',
                      onPressed: () => setState(
                        () => _mostrarContrasena = !_mostrarContrasena,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.history),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Pedidos recientes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
