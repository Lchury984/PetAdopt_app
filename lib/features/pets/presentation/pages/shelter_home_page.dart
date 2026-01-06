import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/core/widgets/shelter_scaffold.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_cubit.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_state.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_cubit.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:petadopt_prueba2_app/core/extensions/build_context_extensions.dart';

/// Página principal para refugios (Panel de administrador)
class ShelterHomePage extends StatefulWidget {
  final String shelterId;

  const ShelterHomePage({Key? key, required this.shelterId}) : super(key: key);

  @override
  State<ShelterHomePage> createState() => _ShelterHomePageState();
}

class _ShelterHomePageState extends State<ShelterHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PetsCubit>().getShelterPets(widget.shelterId);
    context.read<AdoptionCubit>().getShelterRequests(widget.shelterId);
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    String shelterName = 'Refugio';

    if (authState is AuthAuthenticated) {
      shelterName = authState.fullName;
    }

    return ShelterScaffold(
      currentRoute: AppRoutes.shelterHome,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Panel de Administrador',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shelterName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Estadísticas
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.pets,
                      label: 'Mascotas',
                      value: _getPetsCount(context),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.assignment,
                      label: 'Solicitudes',
                      value: _getRequestsCount(context),
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.favorite,
                      label: 'Adoptados',
                      value: _getAdoptedCount(context),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Solicitudes recientes
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Solicitudes Recientes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            BlocBuilder<AdoptionCubit, AdoptionState>(
              builder: (context, state) {
                if (state is AdoptionLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state is AdoptionRequestsLoaded) {
                  final pendingRequests = state.requests
                      .where((req) => req.status == 'pending')
                      .take(5)
                      .toList();

                  if (pendingRequests.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('No hay solicitudes pendientes'),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: pendingRequests.length,
                    itemBuilder: (context, index) {
                      final request = pendingRequests[index];
                      return _RequestCard(
                        request: request,
                        shelterId: widget.shelterId,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 24),

            // Mis Mascotas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mis Mascotas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.navigateTo(
                        AppRoutes.addPet,
                        arguments: widget.shelterId,
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Agregar'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            BlocBuilder<PetsCubit, PetsState>(
              builder: (context, state) {
                if (state is PetsLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state is PetsLoaded) {
                  final pets = state.pets.take(4).toList();

                  if (pets.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('No tienes mascotas registradas'),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      return _PetMiniCard(
                        pet: pet,
                        shelterId: widget.shelterId,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getPetsCount(BuildContext context) {
    final state = context.watch<PetsCubit>().state;
    if (state is PetsLoaded) {
      return state.pets.length.toString();
    }
    return '0';
  }

  String _getRequestsCount(BuildContext context) {
    final state = context.watch<AdoptionCubit>().state;
    if (state is AdoptionRequestsLoaded) {
      return state.requests.where((r) => r.status == 'pending').length.toString();
    }
    return '0';
  }

  String _getAdoptedCount(BuildContext context) {
    final state = context.watch<AdoptionCubit>().state;
    if (state is AdoptionRequestsLoaded) {
      return state.requests.where((r) => r.status == 'approved').length.toString();
    }
    return '0';
  }
}

/// Card de estadística
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card de solicitud
class _RequestCard extends StatelessWidget {
  final dynamic request;
  final String shelterId;

  const _RequestCard({
    required this.request,
    required this.shelterId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Foto de la mascota
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.pets, size: 30),
              ),
            ),
            const SizedBox(width: 12),

            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Solicitud para adopción',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'De: Usuario adoptante',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Botones
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    context.read<AdoptionCubit>().updateRequestStatus(
                          requestId: request.id,
                          status: 'approved',
                        );
                    context.showSnackBar('Solicitud aprobada');
                    context.read<AdoptionCubit>().getShelterRequests(shelterId);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    context.read<AdoptionCubit>().updateRequestStatus(
                          requestId: request.id,
                          status: 'rejected',
                        );
                    context.showSnackBar('Solicitud rechazada');
                    context.read<AdoptionCubit>().getShelterRequests(shelterId);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Mini card de mascota
class _PetMiniCard extends StatelessWidget {
  final dynamic pet;
  final String shelterId;

  const _PetMiniCard({
    required this.pet,
    required this.shelterId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: pet.imageUrl != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: pet.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.pets, size: 40),
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Disponible',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, size: 18),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.navigateTo(
                        AppRoutes.editPet,
                        arguments: {
                          'shelterId': shelterId,
                          'pet': pet,
                        },
                      );
                    } else if (value == 'delete') {
                      context.read<PetsCubit>().deletePet(pet.id);
                      context.showSnackBar('Mascota eliminada');
                      context.read<PetsCubit>().getShelterPets(shelterId);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
