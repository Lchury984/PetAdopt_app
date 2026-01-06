import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_state.dart';

/// Cubit para manejar la autenticación
class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetUserRoleUseCase getUserRoleUseCase;
  final CheckAuthenticationUseCase checkAuthenticationUseCase;

  AuthCubit({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.getUserRoleUseCase,
    required this.checkAuthenticationUseCase,
  }) : super(const AuthInitial());

  /// Registrar nuevo usuario
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    emit(const AuthLoading());
    await registerUseCase(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    ).then((_) {
      emit(const AuthRegistered());
    }).catchError((error) {
      emit(AuthError(message: error.toString()));
    });
  }

  /// Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    await loginUseCase(
      email: email,
      password: password,
    ).then((_) async {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(AuthAuthenticated(
          userId: user.id,
          email: user.email,
          fullName: user.fullName,
          role: user.role,
        ));
      }
    }).catchError((error) {
      emit(AuthError(message: error.toString()));
    });
  }

  /// Logout
  Future<void> logout() async {
    emit(const AuthLoading());
    await logoutUseCase().then((_) {
      emit(const AuthLoggedOut());
      emit(const AuthUnauthenticated());
    }).catchError((error) {
      emit(AuthError(message: error.toString()));
    });
  }

  /// Verificar autenticación al iniciar la app
  Future<void> checkAuthentication() async {
    emit(const AuthLoading());
    final isAuthenticated = await checkAuthenticationUseCase();
    if (isAuthenticated) {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(AuthAuthenticated(
          userId: user.id,
          email: user.email,
          fullName: user.fullName,
          role: user.role,
        ));
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
