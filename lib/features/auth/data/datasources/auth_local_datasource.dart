/// Repositorio local para guardar datos de sesión
abstract class AuthLocalDataSource {
  /// Guardar token del usuario
  Future<void> saveToken(String token);

  /// Obtener token del usuario
  Future<String?> getToken();

  /// Guardar rol del usuario
  Future<void> saveUserRole(String role);

  /// Obtener rol del usuario
  Future<String?> getUserRole();

  /// Limpiar datos locales
  Future<void> clearAll();
}

/// Implementación de AuthLocalDataSource (simulado con ValueNotifier)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Map<String, String> _localStorage = {};

  @override
  Future<void> saveToken(String token) async {
    _localStorage['token'] = token;
  }

  @override
  Future<String?> getToken() async {
    return _localStorage['token'];
  }

  @override
  Future<void> saveUserRole(String role) async {
    _localStorage['user_role'] = role;
  }

  @override
  Future<String?> getUserRole() async {
    return _localStorage['user_role'];
  }

  @override
  Future<void> clearAll() async {
    _localStorage.clear();
  }
}
