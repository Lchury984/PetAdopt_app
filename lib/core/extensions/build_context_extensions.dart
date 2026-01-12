import 'package:flutter/material.dart';

/// Extensiones útiles para BuildContext
extension BuildContextExtensions on BuildContext {
  /// Obtener el tamaño de la pantalla
  Size get screenSize => MediaQuery.of(this).size;

  /// Obtener el ancho de la pantalla
  double get screenWidth => screenSize.width;

  /// Obtener el alto de la pantalla
  double get screenHeight => screenSize.height;

  /// Verificar si es modo landscape
  bool get isLandscape => screenSize.width > screenSize.height;

  /// Verificar si es dispositivo móvil (pequeño)
  bool get isMobile => screenWidth < 600;

  /// Verificar si es tablet
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Mostrar SnackBar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Navegar a una ruta
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  /// Reemplazar la ruta actual
  Future<T?> replaceRoute<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Pop la ruta actual
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
}
