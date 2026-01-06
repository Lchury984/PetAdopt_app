import 'package:petadopt_prueba2_app/features/auth/domain/entities/user_entity.dart';
import 'package:petadopt_prueba2_app/features/auth/domain/repositories/auth_repository.dart';

/// UseCase para registrar usuario
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<void> call({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    );
  }
}

/// UseCase para login
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<void> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}

/// UseCase para logout
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() async {
    return await repository.logout();
  }
}

/// UseCase para obtener usuario actual
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}

/// UseCase para obtener rol del usuario
class GetUserRoleUseCase {
  final AuthRepository repository;

  GetUserRoleUseCase({required this.repository});

  Future<String?> call() async {
    return await repository.getUserRole();
  }
}

/// UseCase para verificar autenticación
class CheckAuthenticationUseCase {
  final AuthRepository repository;

  CheckAuthenticationUseCase({required this.repository});

  Future<bool> call() async {
    return await repository.isAuthenticated();
  }
}
