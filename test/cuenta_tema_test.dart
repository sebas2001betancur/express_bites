import 'package:express_bites/domain/entities/usuario.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/presentation/cuenta/cuenta_view_model.dart';
import 'package:express_bites/presentation/tema/tema_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  group('CuentaViewModel', () {
    late CuentaFalsa repo;
    late CuentaViewModel vm;

    setUp(() {
      repo = CuentaFalsa();
      vm = CuentaViewModel(repo);
    });
    tearDown(() => vm.dispose());

    test('empieza cargando y queda sin usuario', () async {
      expect(vm.cargando, isTrue);
      repo.emitir(null);
      await esperar();
      expect(vm.cargando, isFalse);
      expect(vm.usuario, isNull);
    });

    test('muestra el usuario con su rol', () async {
      repo.emitir(const Usuario(uid: 'u1', correo: 'a@b.co', rol: Rol.personal));
      await esperar();
      expect(vm.usuario?.rol, Rol.personal);
    });

    test('registrar envía el correo recortado y el rol', () async {
      await vm.registrar('  ana@iue.edu.co ', '123456', Rol.personal);
      expect(repo.registros.single, ('ana@iue.edu.co', Rol.personal));
      expect(vm.error, isNull);
    });

    test('traduce los códigos de Firebase', () async {
      repo.fallo = const Falla('invalid-credential');
      await vm.iniciar('a@b.co', 'malaclave');
      expect(vm.error, 'Correo o contraseña incorrectos');
      expect(vm.enviando, isFalse);
    });
  });

  test('TemaViewModel lee el tema guardado y guarda el nuevo', () async {
    final prefs = PreferenciasEnMemoria()..tema = 'dark';
    final vm = TemaViewModel(prefs);
    await vm.cargar();
    expect(vm.modo, ThemeMode.dark);
    await vm.cambiar(ThemeMode.light);
    expect(prefs.tema, 'light');
    expect(vm.modo, ThemeMode.light);
    vm.dispose();
  });
}
