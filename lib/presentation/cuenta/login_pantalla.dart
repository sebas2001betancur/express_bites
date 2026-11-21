import 'package:express_bites/domain/entities/usuario.dart';
import 'package:express_bites/presentation/cuenta/cuenta_view_model.dart';
import 'package:flutter/material.dart';

class LoginPantalla extends StatefulWidget {
  const LoginPantalla({super.key, required this.viewModel});

  final CuentaViewModel viewModel;

  @override
  State<LoginPantalla> createState() => _LoginPantallaState();
}

class _LoginPantallaState extends State<LoginPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  bool _registro = false;
  Rol _rol = Rol.cliente;

  CuentaViewModel get vm => widget.viewModel;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _enviar() {
    if (!_formKey.currentState!.validate()) return;
    if (_registro) {
      vm.registrar(_correo.text, _clave.text, _rol);
    } else {
      vm.iniciar(_correo.text, _clave.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: ListenableBuilder(
                listenable: vm,
                builder: (context, _) => Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.local_cafe,
                        size: 84,
                        color: tema.colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'ExpressBites',
                        textAlign: TextAlign.center,
                        style: tema.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pick & Go',
                        textAlign: TextAlign.center,
                        style: tema.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: false, label: Text('Ingresar')),
                          ButtonSegment(
                            value: true,
                            label: Text('Crear cuenta'),
                          ),
                        ],
                        selected: {_registro},
                        onSelectionChanged: (s) =>
                            setState(() => _registro = s.first),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _correo,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Ingresa tu correo';
                          if (!v.contains('@') || !v.contains('.')) {
                            return 'El correo no tiene un formato válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _clave,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Ingresa tu contraseña';
                          if (v.length < 6) {
                            return 'La contraseña necesita al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      if (_registro) ...[
                        const SizedBox(height: 20),
                        Text(
                          'Tipo de cuenta',
                          style: tema.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label: const Text('Cliente'),
                              selected: _rol == Rol.cliente,
                              onSelected: (_) =>
                                  setState(() => _rol = Rol.cliente),
                            ),
                            ChoiceChip(
                              label: const Text('Personal de barra'),
                              selected: _rol == Rol.personal,
                              onSelected: (_) =>
                                  setState(() => _rol = Rol.personal),
                            ),
                          ],
                        ),
                      ],
                      if (vm.error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          vm.error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: tema.colorScheme.error),
                        ),
                      ],
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: vm.enviando ? null : _enviar,
                        icon: const Icon(Icons.login),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            vm.enviando
                                ? 'Un momento...'
                                : (_registro ? 'Crear cuenta' : 'Ingresar'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
