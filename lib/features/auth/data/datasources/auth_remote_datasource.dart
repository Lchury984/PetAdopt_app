import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  /// Registro de nuevo usuario
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  });

  /// Login de usuario
  Future<void> login({required String email, required String password});

  /// Logout de usuario
  Future<void> logout();

  /// Obtener usuario actual
  Future<User?> getCurrentUser();

  /// Obtener token del usuario
  Future<String?> getUserToken();

  /// Verificar si el usuario está autenticado
  bool isAuthenticated();
}

/// Implementación de AuthRemoteDataSource usando Supabase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      // Registrar en Supabase Auth con metadata
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role,
        },
      );

      // Siempre intentar guardar el perfil de usuario (con o sin sesión)
      if (response.user != null) {
        try {
          await supabaseClient.from('users').upsert(
            {
              'id': response.user!.id,
              'email': email,
              'full_name': fullName,
              'role': role,
              'created_at': DateTime.now().toIso8601String(),
            },
            onConflict: 'id',
            ignoreDuplicates: true,
          );
        } catch (insertError) {
          // Si falla por RLS/sesión, hacer log pero no fallar (el trigger en BD debería crearlo)
          print('⚠️ No se pudo insertar perfil directamente. Se usará trigger de BD. Error: $insertError');
        }
      }
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('429') || msg.toLowerCase().contains('too many requests')) {
        throw Exception('Demasiadas solicitudes de registro. Intenta de nuevo en un minuto.');
      }
      throw Exception('No se pudo registrar: $msg');
    }
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    return supabaseClient.auth.currentUser;
  }

  @override
  Future<String?> getUserToken() async {
    return supabaseClient.auth.currentSession?.accessToken;
  }

  @override
  bool isAuthenticated() {
    return supabaseClient.auth.currentUser != null;
  }
}
