import 'package:express_bites/domain/entities/item_pedido.dart';
import 'package:express_bites/domain/entities/producto.dart';
import 'package:express_bites/domain/entities/usuario.dart';
import 'package:express_bites/presentation/carrito/carrito_pantalla.dart';
import 'package:express_bites/presentation/carrito/carrito_view_model.dart';
import 'package:express_bites/presentation/catalogo/catalogo_view_model.dart';
import 'package:express_bites/presentation/catalogo/clima_tarjeta.dart';
import 'package:express_bites/presentation/catalogo/detalle_producto_pantalla.dart';
import 'package:express_bites/presentation/catalogo/producto_card.dart';
import 'package:express_bites/presentation/comun/estados.dart';
import 'package:express_bites/presentation/cuenta/cuenta_view_model.dart';
import 'package:express_bites/presentation/dependencias.dart';
import 'package:express_bites/presentation/pedidos/pedidos_cliente_view_model.dart';
import 'package:express_bites/presentation/pedidos/ticket_pantalla.dart';
import 'package:express_bites/presentation/perfil/perfil_pantalla.dart';
import 'package:express_bites/presentation/tema/tema_view_model.dart';
import 'package:flutter/material.dart';

class CatalogoPantalla extends StatefulWidget {
  const CatalogoPantalla({
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
  State<CatalogoPantalla> createState() => _CatalogoPantallaState();
}

class _CatalogoPantallaState extends State<CatalogoPantalla> {
  late final CatalogoViewModel catalogo;
  late final CarritoViewModel carrito;
  late final PedidosClienteViewModel misPedidos;

  @override
  void initState() {
    super.initState();
    final d = widget.dependencias;
    catalogo = CatalogoViewModel(productos: d.productos, clima: d.clima);
    carrito = CarritoViewModel(pedidos: d.pedidos, uid: widget.usuario.uid);
    misPedidos = PedidosClienteViewModel(
        pedidos: d.pedidos, uid: widget.usuario.uid, avisar: d.avisarPedidoListo);
  }

  @override
  void dispose() {
    catalogo.dispose();
    carrito.dispose();
    misPedidos.dispose();
    super.dispose();
  }

  void _abrir(Widget pantalla) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));

  Future<void> _abrirDetalle(Producto producto) async {
    final item = await Navigator.push<ItemPedido>(
      context,
      MaterialPageRoute(builder: (_) => DetalleProductoPantalla(producto: producto)),
    );
    if (item != null) carrito.agregar(item);
  }

  void _abrirTicketActivo() {
    final activo = misPedidos.activo;
    if (activo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No tienes un pedido en curso')));
      return;
    }
    _abrir(TicketPantalla(inicial: activo, seguimiento: misPedidos));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([catalogo, carrito]),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('ExpressBites'),
          actions: [
            IconButton(
              icon: const Icon(Icons.receipt_long),
              tooltip: 'Ticket activo',
              onPressed: _abrirTicketActivo,
            ),
            IconButton(
              tooltip: 'Carrito',
              onPressed: () => _abrir(CarritoPantalla(
                  carrito: carrito, catalogo: catalogo, seguimiento: misPedidos)),
              icon: Badge(
                isLabelVisible: carrito.cantidadTotal > 0,
                label: Text('${carrito.cantidadTotal}'),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Mi perfil',
              onPressed: () => _abrir(PerfilPantalla(
                usuario: widget.usuario,
                cuenta: widget.cuenta,
                tema: widget.tema,
                seguimiento: misPedidos,
              )),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (catalogo.sinConexion) const AvisoSinConexion(),
              ClimaTarjeta(viewModel: catalogo),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar producto',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: catalogo.buscar,
                ),
              ),
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: const Text('Todas'),
                        selected: catalogo.categoria == null,
                        onSelected: (_) => catalogo.filtrar(null),
                      ),
                    ),
                    for (final c in catalogo.categorias)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: catalogo.categoria == c,
                          onSelected: (_) => catalogo.filtrar(c),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(child: _lista()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lista() {
    if (catalogo.cargando) return const Center(child: CircularProgressIndicator());
    final error = catalogo.error;
    if (error != null && catalogo.todos.isEmpty) {
      return EstadoMensaje(icono: Icons.cloud_off, texto: error);
    }
    final productos = catalogo.visibles;
    if (productos.isEmpty) {
      return const EstadoMensaje(
          icono: Icons.search_off, texto: 'No hay productos disponibles');
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: productos.length,
      itemBuilder: (context, i) => ProductoCard(
        producto: productos[i],
        onVerDetalle: () => _abrirDetalle(productos[i]),
      ),
    );
  }
}
