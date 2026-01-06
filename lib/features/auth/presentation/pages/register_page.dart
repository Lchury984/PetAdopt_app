import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:petadopt_prueba2_app/core/extensions/build_context_extensions.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';
import 'package:petadopt_prueba2_app/core/widgets/app_back_button.dart';

/// Página de registro
class RegisterPage extends StatefulWidget {
  final String role; // 'adopter' o 'shelter'

  const RegisterPage({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final fullName = _fullNameController.text.trim();

    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      context.showSnackBar('Por favor, completa todos los campos', isError: true);
      return;
    }

    if (password != confirmPassword) {
      context.showSnackBar('Las contraseñas no coinciden', isError: true);
      return;
    }

    if (password.length < 8) {
      context.showSnackBar(
        'La contraseña debe tener al menos 8 caracteres',
        isError: true,
      );
      return;
    }

    context.read<AuthCubit>().register(
          email: email,
          password: password,
          fullName: fullName,
          role: widget.role,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        leading: const AppBackButton(
          fallbackRoute: AppRoutes.selectRole,
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistered) {
            context.showSnackBar('¡Cuenta creada exitosamente!');
            context.replaceRoute(AppRoutes.login);
          } else if (state is AuthError) {
            context.showSnackBar(state.message, isError: true);
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Registrarse como ${widget.role == 'shelter' ? 'Refugio' : 'Adoptante'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Nombre completo
                  TextField(
                    controller: _fullNameController,
                    enabled: state is! AuthLoading,
                    decoration: const InputDecoration(
                      hintText: 'Nombre completo',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      hintText: 'Contraseña (mínimo 8 caracteres)',
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
                  const SizedBox(height: 16),
                  // Confirmar contraseña
                  TextField(
                    controller: _confirmPasswordController,
                    enabled: state is! AuthLoading,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirmar contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Botón de registro
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _handleRegister,
                      child: const Text('Crear Cuenta'),
                    ),
                  const SizedBox(height: 16),
                  // Enlace de login
                  Center(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('¿Ya tienes cuenta? Inicia sesión'),
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
