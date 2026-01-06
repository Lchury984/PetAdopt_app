import 'package:petadopt_prueba2_app/features/pets/domain/entities/pet_entity.dart';

abstract class PetsRepository {
  /// Obtener todas las mascotas disponibles
  Future<List<PetEntity>> getAllPets();

  /// Obtener mascotas de un refugio
  Future<List<PetEntity>> getShelterPets(String shelterId);

  /// Obtener mascota por ID
  Future<PetEntity> getPetById(String petId);

  /// Crear nueva mascota
  Future<PetEntity> createPet(PetEntity pet);

  /// Actualizar mascota
  Future<PetEntity> updatePet(PetEntity pet);

  /// Eliminar mascota
  Future<void> deletePet(String petId);
}
