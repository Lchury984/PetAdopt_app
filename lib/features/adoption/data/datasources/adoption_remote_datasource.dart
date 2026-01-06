import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:petadopt_prueba2_app/features/adoption/data/models/adoption_request_model.dart';

abstract class AdoptionRemoteDataSource {
  /// Crear nueva solicitud de adopción
  Future<AdoptionRequestModel> createAdoptionRequest({
    required String petId,
    required String adopterId,
    required String shelterId,
    required String? message,
  });

  /// Obtener solicitudes de adopción del adoptante
  Future<List<AdoptionRequestModel>> getAdopterRequests(String adopterId);

  /// Obtener solicitudes de adopción del refugio
  Future<List<AdoptionRequestModel>> getShelterRequests(String shelterId);

  /// Actualizar estado de solicitud
  Future<AdoptionRequestModel> updateRequestStatus({
    required String requestId,
    required String status,
  });

  /// Obtener solicitud por ID
  Future<AdoptionRequestModel> getRequestById(String requestId);
}

/// Implementación de AdoptionRemoteDataSource usando Supabase
class AdoptionRemoteDataSourceImpl implements AdoptionRemoteDataSource {
  final SupabaseClient supabaseClient;

  AdoptionRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<AdoptionRequestModel> createAdoptionRequest({
    required String petId,
    required String adopterId,
    required String shelterId,
    required String? message,
  }) async {
    final response = await supabaseClient
        .from('adoption_requests')
        .insert({
          'pet_id': petId,
          'adopter_id': adopterId,
          'shelter_id': shelterId,
          'status': 'pending',
          'message': message,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return AdoptionRequestModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<List<AdoptionRequestModel>> getAdopterRequests(
    String adopterId,
  ) async {
    final response = await supabaseClient
        .from('adoption_requests')
        .select()
        .eq('adopter_id', adopterId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) =>
            AdoptionRequestModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AdoptionRequestModel>> getShelterRequests(
    String shelterId,
  ) async {
    final response = await supabaseClient
        .from('adoption_requests')
        .select()
        .eq('shelter_id', shelterId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) =>
            AdoptionRequestModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AdoptionRequestModel> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    final response = await supabaseClient
        .from('adoption_requests')
        .update({
          'status': status,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId)
        .select()
        .single();

    return AdoptionRequestModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<AdoptionRequestModel> getRequestById(String requestId) async {
    final response = await supabaseClient
        .from('adoption_requests')
        .select()
        .eq('id', requestId)
        .single();

    return AdoptionRequestModel.fromJson(response as Map<String, dynamic>);
  }
}
