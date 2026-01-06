import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/pets/domain/usecases/pets_usecases.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_state.dart';
import 'package:petadopt_prueba2_app/features/pets/domain/entities/pet_entity.dart';

/// Cubit para manejar las mascotas
class PetsCubit extends Cubit<PetsState> {
  final GetAllPetsUseCase getAllPetsUseCase;
  final GetShelterPetsUseCase getShelterPetsUseCase;
  final GetPetByIdUseCase getPetByIdUseCase;
  final CreatePetUseCase createPetUseCase;
  final UpdatePetUseCase updatePetUseCase;
  final DeletePetUseCase deletePetUseCase;
  final UploadPetImageUseCase uploadPetImageUseCase;

  PetsCubit({
    required this.getAllPetsUseCase,
    required this.getShelterPetsUseCase,
    required this.getPetByIdUseCase,
    required this.createPetUseCase,
    required this.updatePetUseCase,
    required this.deletePetUseCase,
    required this.uploadPetImageUseCase,
  }) : super(const PetsInitial());

  /// Obtener todas las mascotas disponibles
  Future<void> getAllPets() async {
    emit(const PetsLoading());
    await getAllPetsUseCase().then((pets) {
      emit(PetsLoaded(pets: pets));
    }).catchError((error) {
      emit(PetsError(message: error.toString()));
    });
  }

  /// Obtener mascotas de un refugio
  Future<void> getShelterPets(String shelterId) async {
    emit(const PetsLoading());
    await getShelterPetsUseCase(shelterId).then((pets) {
      emit(PetsLoaded(pets: pets));
    }).catchError((error) {
      emit(PetsError(message: error.toString()));
    });
  }

  /// Obtener mascota por ID
  Future<void> getPetById(String petId) async {
    emit(const PetsLoading());
    await getPetByIdUseCase(petId).then((pet) {
      emit(PetLoaded(pet: pet));
    }).catchError((error) {
      emit(PetsError(message: error.toString()));
    });
  }

  /// Crear nueva mascota
  Future<void> createPet(PetEntity pet) async {
    emit(const PetsLoading());
    await createPetUseCase(pet).then((createdPet) {
      emit(PetCreated(pet: createdPet));
    }).catchError((error) {
      emit(PetsError(message: error.toString()));
    });
  }

  /// Actualizar mascota
  Future<void> updatePet(PetEntity pet) async {
    emit(const PetsLoading());
    await updatePetUseCase(pet).then((updatedPet) {
      emit(PetUpdated(pet: updatedPet));
    }).catchError((error) {
      emit(PetsError(message: error.toString()));
    });
  }

  /// Eliminar mascota
  Future<void> deletePet(String petId) async {
    emit(const PetsLoading());
    await deletePetUseCase(petId).then((_) {
      emit(const PetDeleted());
    }).catchError((error) {
      emit(PetsError(message: error.toString()));
    });
  }

  /// Subir imagen de mascota y devolver URL
  Future<String> uploadPetImage({required Uint8List bytes, required String fileName}) {
    return uploadPetImageUseCase(bytes: bytes, fileName: fileName);
  }
}
