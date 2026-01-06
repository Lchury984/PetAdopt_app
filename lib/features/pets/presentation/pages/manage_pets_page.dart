import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_cubit.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_state.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/pages/pet_form_page.dart';
import 'package:petadopt_prueba2_app/core/extensions/build_context_extensions.dart';

class ManagePetsPage extends StatefulWidget {
  final String shelterId;

  const ManagePetsPage({Key? key, required this.shelterId}) : super(key: key);

  @override
  State<ManagePetsPage> createState() => _ManagePetsPageState();
}

class _ManagePetsPageState extends State<ManagePetsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PetsCubit>().getShelterPets(widget.shelterId);
  }

  void _openForm({PetFormMode mode = PetFormMode.create, pet}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PetFormPage(
          mode: mode,
          shelterId: widget.shelterId,
          pet: pet,
        ),
      ),
    );
    context.read<PetsCubit>().getShelterPets(widget.shelterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar mascotas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PetsCubit, PetsState>(
        builder: (context, state) {
          if (state is PetsLoading || state is PetsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PetsError) {
            return Center(child: Text(state.message));
          }
          if (state is PetsLoaded) {
            if (state.pets.isEmpty) {
              return const Center(child: Text('No tienes mascotas registradas'));
            }
            return ListView.builder(
              itemCount: state.pets.length,
              itemBuilder: (context, index) {
                final pet = state.pets[index];
                return ListTile(
                  leading: const Icon(Icons.pets),
                  title: Text(pet.name),
                  subtitle: Text('${pet.type} • ${pet.breed}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openForm(mode: PetFormMode.edit, pet: pet),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<PetsCubit>().deletePet(pet.id);
                          context.showSnackBar('Mascota eliminada');
                          context.read<PetsCubit>().getShelterPets(widget.shelterId);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
