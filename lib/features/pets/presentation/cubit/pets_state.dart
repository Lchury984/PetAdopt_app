import 'package:petadopt_prueba2_app/features/pets/domain/entities/pet_entity.dart';

/// Estados para PetsCubit
abstract class PetsState {
  const PetsState();
}

/// Estado inicial
class PetsInitial extends PetsState {
  const PetsInitial();
}

/// Estado de carga
class PetsLoading extends PetsState {
  const PetsLoading();
}

/// Estado de mascotas cargadas
class PetsLoaded extends PetsState {
  final List<PetEntity> pets;

  const PetsLoaded({required this.pets});
}

/// Estado de mascota cargada
class PetLoaded extends PetsState {
  final PetEntity pet;

  const PetLoaded({required this.pet});
}

/// Estado de mascota creada
class PetCreated extends PetsState {
  final PetEntity pet;

  const PetCreated({required this.pet});
}

/// Estado de mascota actualizada
class PetUpdated extends PetsState {
  final PetEntity pet;

  const PetUpdated({required this.pet});
}

/// Estado de mascota eliminada
class PetDeleted extends PetsState {
  const PetDeleted();
}

/// Estado de error
class PetsError extends PetsState {
  final String message;

  const PetsError({required this.message});
}
