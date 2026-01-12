import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    // Si ya está inicializado, no reinicializar
    if (_isInitialized) {
      debugPrint('✅ Supabase ya está inicializado');
      return;
    }

    // Primero intentar desde --dart-define (funciona en todas las plataformas)
    String? supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
    String? supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

    // Si no están en --dart-define, intentar cargar desde .env (solo móvil/desktop)
    if ((supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) && !kIsWeb) {
      try {
        await dotenv.load(fileName: '.env');
        supabaseUrl = dotenv.env['SUPABASE_URL'] ?? supabaseUrl;
        supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? supabaseAnonKey;
      } catch (e) {
        debugPrint('⚠️ No se pudo cargar .env: $e');
      }
    }

    // Validar credenciales
    if (supabaseUrl == null || supabaseUrl.isEmpty || 
        supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
      throw Exception(
        '❌ ERROR: Faltan variables de entorno de Supabase.\n\n'
        'Opciones:\n'
        '1. Usa --dart-define al ejecutar:\n'
        '   flutter run --dart-define=SUPABASE_URL=tu-url --dart-define=SUPABASE_ANON_KEY=tu-key\n\n'
        '2. O crea archivo .env en la raíz con:\n'
        '   SUPABASE_URL=tu-url\n'
        '   SUPABASE_ANON_KEY=tu-key',
      );
    }

    debugPrint('🔧 Inicializando Supabase...');
    debugPrint('📍 URL: $supabaseUrl');

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce),
      // Habilitar debug en desarrollo
      debug: kDebugMode,
    );

    _isInitialized = true;

    debugPrint('✅ Supabase inicializado correctamente');
    debugPrint(
      '👤 Usuario actual: ${client.auth.currentUser?.email ?? "Ninguno"}',
    );
  }

  static bool _isInitialized = false;

  static SupabaseClient get client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      throw Exception('Supabase no está inicializado. Asegúrate de haber llamado a SupabaseConfig.initialize()');
    }
  }

  // Helper para verificar si hay usuario autenticado
  static bool get isAuthenticated {
    try {
      return client.auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  // Helper para obtener el ID del usuario actual
  static String? get currentUserId {
    try {
      return client.auth.currentUser?.id;
    } catch (e) {
      return null;
    }
  }
}
