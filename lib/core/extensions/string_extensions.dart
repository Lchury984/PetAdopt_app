/// Extensiones útiles para String
extension StringExtensions on String {
  /// Capitalizar la primera letra
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Validar email
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  /// Validar contraseña (mínimo 8 caracteres)
  bool get isValidPassword {
    return length >= 8;
  }

  /// Eliminar espacios en blanco
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }
}
