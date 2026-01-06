import 'package:petadopt_prueba2_app/features/adoption/domain/entities/adoption_request_entity.dart';

abstract class AdoptionRepository {
  /// Crear nueva solicitud de adopción
  Future<AdoptionRequestEntity> createAdoptionRequest({
    required String petId,
    required String adopterId,
    required String shelterId,
    required String? message,
  });

  /// Obtener solicitudes del adoptante
  Future<List<AdoptionRequestEntity>> getAdopterRequests(String adopterId);

  /// Obtener solicitudes del refugio
  Future<List<AdoptionRequestEntity>> getShelterRequests(String shelterId);

  /// Actualizar estado de solicitud
  Future<AdoptionRequestEntity> updateRequestStatus({
    required String requestId,
    required String status,
  });

  /// Obtener solicitud por ID
  Future<AdoptionRequestEntity> getRequestById(String requestId);
}
