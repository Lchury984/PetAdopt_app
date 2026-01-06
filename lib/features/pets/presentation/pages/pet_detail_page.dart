import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:petadopt_prueba2_app/features/pets/domain/entities/pet_entity.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_cubit.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_state.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:petadopt_prueba2_app/core/extensions/build_context_extensions.dart';
import 'package:petadopt_prueba2_app/core/widgets/app_back_button.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';

class PetDetailPage extends StatefulWidget {
  final PetEntity pet;

  const PetDetailPage({Key? key, required this.pet}) : super(key: key);

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _requestAdoption(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      context.showSnackBar('Debes iniciar sesión para adoptar', isError: true);
      return;
    }

    final adopterId = authState.userId;
    final shelterId = widget.pet.shelterId;
    context.read<AdoptionCubit>().createAdoptionRequest(
          petId: widget.pet.id,
          adopterId: adopterId,
          shelterId: shelterId,
          message: 'Estoy interesado en ${widget.pet.name}',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
        leading: const AppBackButton(
          fallbackRoute: AppRoutes.adopterHome,
        ),
      ),
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
              // Image carousel
              if (widget.pet.imageUrls.isNotEmpty)
                Column(
                  children: [
                    SizedBox(
                      height: 280,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.pet.imageUrls.length,
                        onPageChanged: (index) {
                          setState(() => _currentImageIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: widget.pet.imageUrls[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported, size: 80),
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (widget.pet.imageUrls.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.pet.imageUrls.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              else
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.pets, size: 80),
                ),
              const SizedBox(height: 16),
              Text(
                widget.pet.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('${widget.pet.type} • ${widget.pet.breed} • ${widget.pet.getAgeFormatted()}'),
              const SizedBox(height: 12),
              Text(widget.pet.description),
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
