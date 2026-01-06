import 'package:flutter/material.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';

/// Botón de retroceso reutilizable con ruta de respaldo
class AppBackButton extends StatelessWidget {
  final String fallbackRoute;
  final Object? arguments;

  const AppBackButton({
    Key? key,
    this.fallbackRoute = AppRoutes.login,
    this.arguments,
  }) : super(key: key);

  void _handleBack(BuildContext context) {
    final navigator = Navigator.of(context);

    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    navigator.pushReplacementNamed(fallbackRoute, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => _handleBack(context),
    );
  }
}
