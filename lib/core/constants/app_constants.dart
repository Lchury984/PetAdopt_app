import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Constantes de la aplicación
class AppConstants {
  // API - Preferir --dart-define en Web, fallback a .env en móviles
  static const String _ddSupabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String _ddSupabaseAnon =
      String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String _ddGeminiKey = String.fromEnvironment('GEMINI_API_KEY');

  // Safe access to dotenv variables only if initialized
  static String _env(String key) {
    return dotenv.isInitialized ? (dotenv.env[key] ?? '') : '';
  }

  static String get supabaseUrl => (_ddSupabaseUrl.isNotEmpty
      ? _ddSupabaseUrl
      : (_env('SUPABASE_URL').isNotEmpty
          ? _env('SUPABASE_URL')
          : 'https://xzruawmvhiczjqrlurqp.supabase.co'));

  static String get supabaseKey => (_ddSupabaseAnon.isNotEmpty
      ? _ddSupabaseAnon
      : (_env('SUPABASE_ANON_KEY').isNotEmpty
          ? _env('SUPABASE_ANON_KEY')
          : 'sb_publishable_Fe269s_YDROt06td8CzugA_YjbynHIE'));

  static String get geminiApiKey =>
      (_ddGeminiKey.isNotEmpty ? _ddGeminiKey : _env('GEMINI_API_KEY'));

  // Database tables
  static const String usersTable = 'users';
  static const String petsTable = 'pets';
  static const String adoptionRequestsTable = 'adoption_requests';
  static const String sheltersTable = 'shelters';

  // Storage
  static const String petImagesBucket = 'pet_images';

  // User roles
  static const String roleAdopter = 'adopter';
  static const String roleShelter = 'shelter';

  // Adoption request statuses
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';

  // Pet types
  static const List<String> petTypes = ['Perro', 'Gato', 'Conejo', 'Pájaro'];

  // API Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
}
