/// Estados para AuthCubit
abstract class AuthState {
  const AuthState();
}

/// Estado inicial
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Estado de carga
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Estado de usuario autenticado
class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String fullName;
  final String role;

  const AuthAuthenticated({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.role,
  });
}

/// Estado de usuario no autenticado
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Estado de error
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});
}

/// Estado de registro exitoso
class AuthRegistered extends AuthState {
  const AuthRegistered();
}

/// Estado de logout exitoso
class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
