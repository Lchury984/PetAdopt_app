import 'package:petadopt_prueba2_app/features/auth/domain/entities/user_entity.dart';
import 'package:petadopt_prueba2_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:petadopt_prueba2_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:petadopt_prueba2_app/features/auth/data/datasources/auth_local_datasource.dart';

/// Implementación del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    await remoteDataSource.register(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    );
    await localDataSource.saveUserRole(role);
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await remoteDataSource.login(email: email, password: password);
    final token = await remoteDataSource.getUserToken();
    if (token != null) {
      await localDataSource.saveToken(token);
    }
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearAll();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = await remoteDataSource.getCurrentUser();
    if (user != null) {
      return UserEntity(
        id: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'] ?? '',
        role: user.userMetadata?['role'] ?? 'adopter',
        createdAt: DateTime.parse(user.createdAt),
      );
    }
    return null;
  }

  @override
  Future<String?> getUserRole() async {
    return await localDataSource.getUserRole();
  }

  @override
  Future<bool> isAuthenticated() async {
    return remoteDataSource.isAuthenticated();
  }
}
