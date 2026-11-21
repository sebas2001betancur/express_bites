/// Traduce los códigos de Falla a mensajes para la persona usuaria.
String mensajeDe(String codigo) => switch (codigo) {
      'email-already-in-use' => 'Ese correo ya tiene una cuenta',
      'weak-password' => 'La contraseña es muy corta: usa al menos 6 caracteres',
      'invalid-email' => 'El correo no tiene un formato válido',
      'invalid-credential' => 'Correo o contraseña incorrectos',
      'network-request-failed' ||
      'sin-conexion' ||
      'unavailable' =>
        'Sin conexión: revisa tu internet',
      'tiempo-agotado' => 'La respuesta tardó demasiado. Intenta de nuevo',
      'permission-denied' => 'Tu cuenta no tiene permiso para esta acción',
      'tamano-requerido' => 'Selecciona un tamaño antes de continuar',
      'carrito-vacio' => 'Tu carrito está vacío',
      'hora-invalida' =>
        'La recogida debe ser al menos 15 minutos después de ahora',
      'requiere-conexion' => 'Esta acción necesita internet',
      'base-local' => 'No se pudo leer la copia guardada en el teléfono',
      'respuesta-invalida' => 'El servicio respondió algo que no entendemos',
      _ => 'Error: $codigo',
    };
