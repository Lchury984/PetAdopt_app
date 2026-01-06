import 'dart:typed_data';

import 'package:petadopt_prueba2_app/features/pets/domain/entities/pet_entity.dart';
import 'package:petadopt_prueba2_app/features/pets/domain/repositories/pets_repository.dart';
import 'package:petadopt_prueba2_app/features/pets/data/datasources/pets_remote_datasource.dart';
import 'package:petadopt_prueba2_app/features/pets/data/models/pet_model.dart';

/// Implementación del repositorio de mascotas
class PetsRepositoryImpl implements PetsRepository {
  final PetsRemoteDataSource remoteDataSource;

  PetsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PetEntity>> getAllPets() async {
    final models = await remoteDataSource.getAllPets();
    return models
        .map((model) => PetEntity(
              id: model.id,
              name: model.name,
              type: model.type,
              breed: model.breed,
              age: model.age,
              description: model.description,
              imageUrl: model.imageUrl,
              shelterId: model.shelterId,
              adopted: model.adopted,
              createdAt: DateTime.parse(model.createdAt),
            ))
        .toList();
  }

  @override
  Future<List<PetEntity>> getShelterPets(String shelterId) async {
    final models = await remoteDataSource.getShelterPets(shelterId);
    return models
        .map((model) => PetEntity(
              id: model.id,
              name: model.name,
              type: model.type,
              breed: model.breed,
              age: model.age,
              description: model.description,
              imageUrl: model.imageUrl,
              shelterId: model.shelterId,
              adopted: model.adopted,
              createdAt: DateTime.parse(model.createdAt),
            ))
        .toList();
  }

  @override
  Future<PetEntity> getPetById(String petId) async {
    final model = await remoteDataSource.getPetById(petId);
    return PetEntity(
      id: model.id,
      name: model.name,
      type: model.type,
      breed: model.breed,
      age: model.age,
      description: model.description,
      imageUrl: model.imageUrl,
      shelterId: model.shelterId,
      adopted: model.adopted,
      createdAt: DateTime.parse(model.createdAt),
    );
  }

  @override
  Future<PetEntity> createPet(PetEntity pet) async {
    final model = await remoteDataSource.createPet(
      _entityToModel(pet),
    );
    return PetEntity(
      id: model.id,
      name: model.name,
      type: model.type,
      breed: model.breed,
      age: model.age,
      description: model.description,
      imageUrl: model.imageUrl,
      shelterId: model.shelterId,
      adopted: model.adopted,
      createdAt: DateTime.parse(model.createdAt),
    );
  }

  @override
  Future<PetEntity> updatePet(PetEntity pet) async {
    final model = await remoteDataSource.updatePet(
      _entityToModel(pet),
    );
    return PetEntity(
      id: model.id,
      name: model.name,
      type: model.type,
      breed: model.breed,
      age: model.age,
      description: model.description,
      imageUrl: model.imageUrl,
      shelterId: model.shelterId,
      adopted: model.adopted,
      createdAt: DateTime.parse(model.createdAt),
    );
  }

  @override
  Future<void> deletePet(String petId) async {
    await remoteDataSource.deletePet(petId);
  }

  @override
  Future<String> uploadPetImage({required Uint8List bytes, required String fileName}) {
    return remoteDataSource.uploadPetImage(bytes: bytes, fileName: fileName);
  }

  // Helper privado para convertir entity a model
  PetModel _entityToModel(PetEntity pet) {
    return PetModel(
      id: pet.id,
      name: pet.name,
      type: pet.type,
      breed: pet.breed,
      age: pet.age,
      description: pet.description,
      imageUrl: pet.imageUrl,
      shelterId: pet.shelterId,
      adopted: pet.adopted,
      createdAt: pet.createdAt.toIso8601String(),
    );
  }
}
