import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Constantes de la aplicación
class AppConstants {
  // API - Cargadas del archivo .env
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? 'https://xzruawmvhiczjqrlurqp.supabase.co';
  static String get supabaseKey => dotenv.env['SUPABASE_ANON_KEY'] ?? 'sb_publishable_Fe269s_YDROt06td8CzugA_YjbynHIE';
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // Database tables
  static const String usersTable = 'users';
  static const String petsTable = 'pets';
  static const String adoptionRequestsTable = 'adoption_requests';
  static const String sheltersTable = 'shelters';

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
