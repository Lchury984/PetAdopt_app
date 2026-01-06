import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_cubit.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_state.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';
import 'package:petadopt_prueba2_app/core/widgets/app_back_button.dart';

class ShelterRequestsPage extends StatefulWidget {
  final String shelterId;

  const ShelterRequestsPage({Key? key, required this.shelterId}) : super(key: key);

  @override
  State<ShelterRequestsPage> createState() => _ShelterRequestsPageState();
}

class _ShelterRequestsPageState extends State<ShelterRequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdoptionCubit>().getShelterRequests(widget.shelterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes recibidas'),
        leading: const AppBackButton(
          fallbackRoute: AppRoutes.shelterHome,
        ),
      ),
      body: BlocBuilder<AdoptionCubit, AdoptionState>(
        builder: (context, state) {
          if (state is AdoptionLoading || state is AdoptionInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AdoptionError) {
            return Center(child: Text(state.message));
          }
          if (state is AdoptionRequestsLoaded) {
            if (state.requests.isEmpty) {
              return const Center(child: Text('Sin solicitudes'));
            }
            return ListView.builder(
              itemCount: state.requests.length,
              itemBuilder: (context, index) {
                final req = state.requests[index];
                return ListTile(
                  leading: Text(req.getStatusEmoji()),
                  title: Text('Mascota: ${req.petId}'),
                  subtitle: Text('Adoptante: ${req.adopterId}\nEstado: ${req.getStatusText()}'),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      context.read<AdoptionCubit>().updateRequestStatus(
                            requestId: req.id,
                            status: value,
                          );
                      context.read<AdoptionCubit>().getShelterRequests(widget.shelterId);
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'approved', child: Text('Aprobar')),
                      PopupMenuItem(value: 'rejected', child: Text('Rechazar')),
                      PopupMenuItem(value: 'pending', child: Text('Pendiente')),
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
