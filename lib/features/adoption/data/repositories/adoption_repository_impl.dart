import 'package:petadopt_prueba2_app/features/adoption/domain/entities/adoption_request_entity.dart';
import 'package:petadopt_prueba2_app/features/adoption/domain/repositories/adoption_repository.dart';
import 'package:petadopt_prueba2_app/features/adoption/data/datasources/adoption_remote_datasource.dart';

/// Implementación del repositorio de adopción
class AdoptionRepositoryImpl implements AdoptionRepository {
  final AdoptionRemoteDataSource remoteDataSource;

  AdoptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AdoptionRequestEntity> createAdoptionRequest({
    required String petId,
    required String adopterId,
    required String shelterId,
    required String? message,
  }) async {
    final model = await remoteDataSource.createAdoptionRequest(
      petId: petId,
      adopterId: adopterId,
      shelterId: shelterId,
      message: message,
    );

    return _modelToEntity(model);
  }

  @override
  Future<List<AdoptionRequestEntity>> getAdopterRequests(
    String adopterId,
  ) async {
    final models = await remoteDataSource.getAdopterRequests(adopterId);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<AdoptionRequestEntity>> getShelterRequests(
    String shelterId,
  ) async {
    final models = await remoteDataSource.getShelterRequests(shelterId);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<AdoptionRequestEntity> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    final model = await remoteDataSource.updateRequestStatus(
      requestId: requestId,
      status: status,
    );
    return _modelToEntity(model);
  }

  @override
  Future<AdoptionRequestEntity> getRequestById(String requestId) async {
    final model = await remoteDataSource.getRequestById(requestId);
    return _modelToEntity(model);
  }

  // Helper privado para convertir model a entity
  AdoptionRequestEntity _modelToEntity(model) {
    return AdoptionRequestEntity(
      id: model.id,
      petId: model.petId,
      adopterId: model.adopterId,
      shelterId: model.shelterId,
      status: model.status,
      message: model.message,
      createdAt: DateTime.parse(model.createdAt),
      updatedAt: DateTime.parse(model.updatedAt),
    );
  }
}
