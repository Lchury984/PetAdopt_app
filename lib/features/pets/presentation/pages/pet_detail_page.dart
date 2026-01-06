import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/pets/domain/entities/pet_entity.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_cubit.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_state.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:petadopt_prueba2_app/core/extensions/build_context_extensions.dart';

class PetDetailPage extends StatelessWidget {
  final PetEntity pet;

  const PetDetailPage({Key? key, required this.pet}) : super(key: key);

  void _requestAdoption(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      context.showSnackBar('Debes iniciar sesión para adoptar', isError: true);
      return;
    }

    final adopterId = authState.userId;
    final shelterId = pet.shelterId;
    context.read<AdoptionCubit>().createAdoptionRequest(
          petId: pet.id,
          adopterId: adopterId,
          shelterId: shelterId,
          message: 'Estoy interesado en ${pet.name}',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet.name)),
      body: BlocListener<AdoptionCubit, AdoptionState>(
        listener: (context, state) {
          if (state is AdoptionRequestCreated) {
            context.showSnackBar('Solicitud enviada');
          } else if (state is AdoptionError) {
            context.showSnackBar(state.message, isError: true);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pet.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    pet.imageUrl!,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.pets, size: 80),
                ),
              const SizedBox(height: 16),
              Text(
                pet.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('${pet.type} • ${pet.breed} • ${pet.getAgeFormatted()}'),
              const SizedBox(height: 12),
              Text(pet.description),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _requestAdoption(context),
                icon: const Icon(Icons.volunteer_activism),
                label: const Text('Solicitar adopción'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
