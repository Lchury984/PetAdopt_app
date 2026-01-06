import 'package:petadopt_prueba2_app/features/pets/domain/entities/pet_entity.dart';
import 'package:petadopt_prueba2_app/features/pets/domain/repositories/pets_repository.dart';

/// UseCase para obtener todas las mascotas
class GetAllPetsUseCase {
  final PetsRepository repository;

  GetAllPetsUseCase({required this.repository});

  Future<List<PetEntity>> call() async {
    return await repository.getAllPets();
  }
}

/// UseCase para obtener mascotas de un refugio
class GetShelterPetsUseCase {
  final PetsRepository repository;

  GetShelterPetsUseCase({required this.repository});

  Future<List<PetEntity>> call(String shelterId) async {
    return await repository.getShelterPets(shelterId);
  }
}

/// UseCase para obtener mascota por ID
class GetPetByIdUseCase {
  final PetsRepository repository;

  GetPetByIdUseCase({required this.repository});

  Future<PetEntity> call(String petId) async {
    return await repository.getPetById(petId);
  }
}

/// UseCase para crear mascota
class CreatePetUseCase {
  final PetsRepository repository;

  CreatePetUseCase({required this.repository});

  Future<PetEntity> call(PetEntity pet) async {
    return await repository.createPet(pet);
  }
}

/// UseCase para actualizar mascota
class UpdatePetUseCase {
  final PetsRepository repository;

  UpdatePetUseCase({required this.repository});

  Future<PetEntity> call(PetEntity pet) async {
    return await repository.updatePet(pet);
  }
}

/// UseCase para eliminar mascota
class DeletePetUseCase {
  final PetsRepository repository;

  DeletePetUseCase({required this.repository});

  Future<void> call(String petId) async {
    return await repository.deletePet(petId);
  }
}
