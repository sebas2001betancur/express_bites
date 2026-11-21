import 'package:express_bites/domain/entities/usuario.dart';
import 'package:express_bites/presentation/catalogo/catalogo_pantalla.dart';
import 'package:express_bites/presentation/cuenta/cuenta_view_model.dart';
import 'package:express_bites/presentation/cuenta/login_pantalla.dart';
import 'package:express_bites/presentation/dependencias.dart';
import 'package:express_bites/presentation/personal/pedidos_personal_pantalla.dart';
import 'package:express_bites/presentation/tema/tema_view_model.dart';
import 'package:flutter/material.dart';

class RaizPantalla extends StatefulWidget {
  const RaizPantalla({
    super.key,
    required this.dependencias,
    required this.tema,
  });

  final Dependencias dependencias;
  final TemaViewModel tema;

  @override
  State<RaizPantalla> createState() => _RaizPantallaState();
}

class _RaizPantallaState extends State<RaizPantalla> {
  late final cuenta = CuentaViewModel(widget.dependencias.cuenta);

  @override
  void dispose() {
    cuenta.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cuenta,
      builder: (context, _) {
        if (cuenta.cargando) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final usuario = cuenta.usuario;
        if (usuario == null) return LoginPantalla(viewModel: cuenta);
        return switch (usuario.rol) {
          Rol.cliente => CatalogoPantalla(
            key: ValueKey(usuario.uid),
            usuario: usuario,
            dependencias: widget.dependencias,
            cuenta: cuenta,
            tema: widget.tema,
          ),
          Rol.personal => PedidosPersonalPantalla(
            key: ValueKey(usuario.uid),
            usuario: usuario,
            dependencias: widget.dependencias,
            cuenta: cuenta,
            tema: widget.tema,
          ),
        };
      },
    );
  }
}
