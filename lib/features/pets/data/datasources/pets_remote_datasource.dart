import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:petadopt_prueba2_app/features/pets/data/models/pet_model.dart';

abstract class PetsRemoteDataSource {
  /// Obtener todas las mascotas disponibles (para adoptantes)
  Future<List<PetModel>> getAllPets();

  /// Obtener mascotas de un refugio específico
  Future<List<PetModel>> getShelterPets(String shelterId);

  /// Obtener mascota por ID
  Future<PetModel> getPetById(String petId);

  /// Crear nueva mascota (solo refugios)
  Future<PetModel> createPet(PetModel pet);

  /// Actualizar mascota (solo refugios)
  Future<PetModel> updatePet(PetModel pet);

  /// Eliminar mascota (solo refugios)
  Future<void> deletePet(String petId);
}

/// Implementación de PetsRemoteDataSource usando Supabase
class PetsRemoteDataSourceImpl implements PetsRemoteDataSource {
  final SupabaseClient supabaseClient;

  PetsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<PetModel>> getAllPets() async {
    final response = await supabaseClient
        .from('pets')
        .select()
        .eq('adopted', false)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => PetModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PetModel>> getShelterPets(String shelterId) async {
    final response = await supabaseClient
        .from('pets')
        .select()
        .eq('shelter_id', shelterId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => PetModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PetModel> getPetById(String petId) async {
    final response =
        await supabaseClient.from('pets').select().eq('id', petId).single();

    return PetModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<PetModel> createPet(PetModel pet) async {
    final response = await supabaseClient
        .from('pets')
        .insert(pet.toJson())
        .select()
        .single();

    return PetModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<PetModel> updatePet(PetModel pet) async {
    final response = await supabaseClient
        .from('pets')
        .update(pet.toJson())
        .eq('id', pet.id)
        .select()
        .single();

    return PetModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> deletePet(String petId) async {
    await supabaseClient.from('pets').delete().eq('id', petId);
  }
}
