import 'package:express_bites/domain/entities/pedido.dart';
import 'package:express_bites/domain/entities/usuario.dart';
import 'package:express_bites/presentation/comun/estados.dart';
import 'package:express_bites/presentation/comun/formato.dart';
import 'package:express_bites/presentation/cuenta/cuenta_view_model.dart';
import 'package:express_bites/presentation/dependencias.dart';
import 'package:express_bites/presentation/perfil/perfil_pantalla.dart';
import 'package:express_bites/presentation/personal/menu_personal_pantalla.dart';
import 'package:express_bites/presentation/personal/pedidos_personal_view_model.dart';
import 'package:express_bites/presentation/tema/tema_view_model.dart';
import 'package:flutter/material.dart';

class PedidosPersonalPantalla extends StatefulWidget {
  const PedidosPersonalPantalla({
    super.key,
    required this.usuario,
    required this.dependencias,
    required this.cuenta,
    required this.tema,
  });

  final Usuario usuario;
  final Dependencias dependencias;
  final CuentaViewModel cuenta;
  final TemaViewModel tema;

  @override
  State<PedidosPersonalPantalla> createState() =>
      _PedidosPersonalPantallaState();
}

class _PedidosPersonalPantallaState extends State<PedidosPersonalPantalla> {
  late final vm = PedidosPersonalViewModel(widget.dependencias.pedidos);
  final _codigo = TextEditingController();

  @override
  void dispose() {
    vm.dispose();
    _codigo.dispose();
    super.dispose();
  }

  Future<void> _validarCodigo() async {
    _codigo.clear();
    final codigo = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validar Claim ID'),
        content: TextField(
          controller: _codigo,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(hintText: 'EB-XXXXXXXX'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, _codigo.text),
            child: const Text('Entregar'),
          ),
        ],
      ),
    );
    if (codigo == null || codigo.trim().isEmpty) return;
    final problema = await vm.entregarPorCodigo(codigo);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          problema ?? 'Pedido ${codigo.trim().toUpperCase()} entregado',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos entrantes'),
        actions: [
          IconButton(
            tooltip: 'Menú',
            icon: const Icon(Icons.restaurant_menu),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MenuPersonalPantalla(dependencias: widget.dependencias),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Mi perfil',
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PerfilPantalla(
                  usuario: widget.usuario,
                  cuenta: widget.cuenta,
                  tema: widget.tema,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _validarCodigo,
        icon: const Icon(Icons.qr_code_2),
        label: const Text('Validar código'),
      ),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          final lista = vm.lista;
          final error = vm.error;
          if (lista == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
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
                child: lista.isEmpty
                    ? const EstadoMensaje(
                        icono: Icons.inbox_outlined,
                        texto: 'No hay pedidos activos',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 88),
                        itemCount: lista.length,
                        itemBuilder: (context, i) => _tarjeta(lista[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tarjeta(Pedido p) {
    final enPreparacion = p.estado == EstadoPedido.enPreparacion;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${formatoHora(p.recogida)} · ${p.claimId}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(label: Text(p.estado.etiqueta)),
              ],
            ),
            for (final item in p.items)
              Text(
                '${item.cantidad} × ${item.nombre} (${item.descripcion})'
                '${item.notas.isEmpty ? '' : ' · ${item.notas}'}',
              ),
            if (p.pendiente) const Text('(sin enviar)'),
            Align(
              alignment: Alignment.centerRight,
              child: enPreparacion
                  ? FilledButton(
                      onPressed: () => vm.marcarListo(p),
                      child: const Text('Marcar listo'),
                    )
                  : OutlinedButton(
                      onPressed: _validarCodigo,
                      child: const Text('Entregar con código'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
