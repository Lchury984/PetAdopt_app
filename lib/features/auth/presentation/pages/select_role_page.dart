import 'package:flutter/material.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/pages/register_page.dart';
import 'package:petadopt_prueba2_app/core/extensions/build_context_extensions.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';

/// Página para seleccionar el rol (adoptante o refugio)
class SelectRolePage extends StatelessWidget {
  const SelectRolePage({Key? key}) : super(key: key);

  void _selectRole(BuildContext context, String role) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterPage(role: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige tu rol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¿Quién eres?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            // Opción: Adoptante
            GestureDetector(
              onTap: () => _selectRole(context, 'adopter'),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 64,
                        color: Color(0xFF6B5FD4),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Soy un Adoptante',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Busco una mascota para adoptar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _selectRole(context, 'adopter'),
                        child: const Text('Continuar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Opción: Refugio
            GestureDetector(
              onTap: () => _selectRole(context, 'shelter'),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.home_work,
                        size: 64,
                        color: Color(0xFF6B5FD4),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Soy un Refugio',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tengo mascotas disponibles para adoptar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _selectRole(context, 'shelter'),
                        child: const Text('Continuar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => context.navigateTo(AppRoutes.login),
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
