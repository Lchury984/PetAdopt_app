import 'package:petadopt_prueba2_app/features/adoption/domain/entities/adoption_request_entity.dart';
import 'package:petadopt_prueba2_app/features/adoption/domain/repositories/adoption_repository.dart';

/// UseCase para crear solicitud de adopción
class CreateAdoptionRequestUseCase {
  final AdoptionRepository repository;

  CreateAdoptionRequestUseCase({required this.repository});

  Future<AdoptionRequestEntity> call({
    required String petId,
    required String adopterId,
    required String shelterId,
    required String? message,
  }) async {
    return await repository.createAdoptionRequest(
      petId: petId,
      adopterId: adopterId,
      shelterId: shelterId,
      message: message,
    );
  }
}

/// UseCase para obtener solicitudes del adoptante
class GetAdopterRequestsUseCase {
  final AdoptionRepository repository;

  GetAdopterRequestsUseCase({required this.repository});

  Future<List<AdoptionRequestEntity>> call(String adopterId) async {
    return await repository.getAdopterRequests(adopterId);
  }
}

/// UseCase para obtener solicitudes del refugio
class GetShelterRequestsUseCase {
  final AdoptionRepository repository;

  GetShelterRequestsUseCase({required this.repository});

  Future<List<AdoptionRequestEntity>> call(String shelterId) async {
    return await repository.getShelterRequests(shelterId);
  }
}

/// UseCase para actualizar estado de solicitud
class UpdateAdoptionRequestStatusUseCase {
  final AdoptionRepository repository;

  UpdateAdoptionRequestStatusUseCase({required this.repository});

  Future<AdoptionRequestEntity> call({
    required String requestId,
    required String status,
  }) async {
    return await repository.updateRequestStatus(
      requestId: requestId,
      status: status,
    );
  }
}
