import 'package:petadopt_prueba2_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Registrar nuevo usuario
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  });

  /// Login
  Future<void> login({required String email, required String password});

  /// Logout
  Future<void> logout();

  /// Obtener usuario actual
  Future<UserEntity?> getCurrentUser();

  /// Obtener rol del usuario
  Future<String?> getUserRole();

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated();
}
