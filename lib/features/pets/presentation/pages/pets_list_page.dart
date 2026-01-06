import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_cubit.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_state.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/widgets/pet_card.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';
import 'package:petadopt_prueba2_app/core/extensions/build_context_extensions.dart';
import 'package:petadopt_prueba2_app/core/widgets/app_back_button.dart';

class PetsListPage extends StatefulWidget {
  const PetsListPage({Key? key}) : super(key: key);

  @override
  State<PetsListPage> createState() => _PetsListPageState();
}

class _PetsListPageState extends State<PetsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<PetsCubit>().getAllPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mascotas disponibles'),
        leading: const AppBackButton(
          fallbackRoute: AppRoutes.adopterHome,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => context.navigateTo(AppRoutes.map),
          )
        ],
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
              return const Center(child: Text('No hay mascotas disponibles'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: state.pets.length,
              itemBuilder: (context, index) {
                final pet = state.pets[index];
                return PetCard(
                  pet: pet,
                  onTap: () => context.navigateTo(
                    AppRoutes.petDetail,
                    arguments: pet,
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
