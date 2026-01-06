import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:petadopt_prueba2_app/core/extensions/build_context_extensions.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';
import 'package:petadopt_prueba2_app/core/widgets/app_back_button.dart';

/// Página de login
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      context.showSnackBar('Por favor, completa todos los campos', isError: true);
      return;
    }

    context.read<AuthCubit>().login(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        leading: const AppBackButton(
          fallbackRoute: AppRoutes.selectRole,
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.showSnackBar('¡Bienvenido de vuelta, ${state.fullName}!');
            if (state.role == 'shelter') {
              context.replaceRoute(AppRoutes.shelterHome);
            } else {
              context.replaceRoute(AppRoutes.adopterHome);
            }
          } else if (state is AuthError) {
            context.showSnackBar(state.message, isError: true);
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Logo
                  const Icon(
                    Icons.pets,
                    size: 80,
                    color: Color(0xFF6B5FD4),
                  ),
                  const SizedBox(height: 20),
                  // Título
                  const Text(
                    'PetAdopt',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B5FD4),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email
                  TextField(
                    controller: _emailController,
                    enabled: state is! AuthLoading,
                    decoration: const InputDecoration(
                      hintText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  // Contraseña
                  TextField(
                    controller: _passwordController,
                    enabled: state is! AuthLoading,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(
                              () => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Botón de login
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text('Iniciar Sesión'),
                    ),
                  const SizedBox(height: 16),
                  // Enlace de registro
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          context.navigateTo(AppRoutes.selectRole),
                      child: const Text('¿No tienes cuenta? Regístrate aquí'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
