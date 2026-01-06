import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/core/widgets/adopter_scaffold.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_cubit.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_state.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/widgets/pet_card.dart';
import 'package:petadopt_prueba2_app/core/extensions/build_context_extensions.dart';
import 'package:petadopt_prueba2_app/core/widgets/app_back_button.dart';

/// Página principal para adoptantes
class AdopterHomePage extends StatefulWidget {
  final String adopterId;

  const AdopterHomePage({Key? key, required this.adopterId}) : super(key: key);

  @override
  State<AdopterHomePage> createState() => _AdopterHomePageState();
}

class _AdopterHomePageState extends State<AdopterHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos'; // Todos, Perros, Gatos
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<PetsCubit>().getAllPets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() {
    context.read<AuthCubit>().logout();
  }

  List<dynamic> _filterPets(List<dynamic> pets) {
    var filtered = pets;

    // Filtrar por búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((pet) {
        final name = pet.name.toLowerCase();
        final breed = pet.breed.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || breed.contains(query);
      }).toList();
    }

    // Filtrar por tipo
    if (_selectedFilter != 'Todos') {
      filtered = filtered.where((pet) {
        return pet.type.toLowerCase() == _selectedFilter.toLowerCase();
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    String userName = 'Usuario';
    
    if (authState is AuthAuthenticated) {
      userName = authState.fullName;
    }

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut || state is AuthUnauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      child: AdopterScaffold(
        currentRoute: AppRoutes.adopterHome,
        appBar: AppBar(
          title: const Text('Inicio'),
          leading: const AppBackButton(
            fallbackRoute: AppRoutes.login,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Cerrar sesión',
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header con saludo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                Text(
                  '¡Hola, $userName! 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Encuentra tu compañero perfecto',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Buscador y filtros
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Buscador
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar mascotas...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Filtros
                Row(
                  children: [
                    Expanded(
                      child: _FilterChip(
                        label: 'Todos',
                        selected: _selectedFilter == 'Todos',
                        onSelected: () {
                          setState(() {
                            _selectedFilter = 'Todos';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _FilterChip(
                        label: 'Perros',
                        selected: _selectedFilter == 'Perros',
                        onSelected: () {
                          setState(() {
                            _selectedFilter = 'Perros';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _FilterChip(
                        label: 'Gatos',
                        selected: _selectedFilter == 'Gatos',
                        onSelected: () {
                          setState(() {
                            _selectedFilter = 'Gatos';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Listado de mascotas
          Expanded(
            child: BlocBuilder<PetsCubit, PetsState>(
              builder: (context, state) {
                if (state is PetsLoading || state is PetsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PetsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(state.message),
                      ],
                    ),
                  );
                }
                if (state is PetsLoaded) {
                  final filteredPets = _filterPets(state.pets);

                  if (filteredPets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pets, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            'No se encontraron mascotas',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredPets.length,
                    itemBuilder: (context, index) {
                      final pet = filteredPets[index];
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
          ),
        ],
      ),
    ),
  );
  }
}

/// Widget para los chips de filtro
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
