String formatoPrecio(int valor) {
  final texto = valor.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < texto.length; i++) {
    if (i > 0 && (texto.length - i) % 3 == 0) buffer.write('.');
    buffer.write(texto[i]);
  }
  return '\$$buffer';
}

String _dos(int n) => n.toString().padLeft(2, '0');

String formatoHora(DateTime t) => '${_dos(t.hour)}:${_dos(t.minute)}';

String formatoFecha(DateTime t) => '${_dos(t.day)}/${_dos(t.month)}/${t.year}';
