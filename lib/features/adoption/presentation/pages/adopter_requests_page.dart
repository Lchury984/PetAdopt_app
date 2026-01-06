import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_cubit.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_state.dart';

class AdopterRequestsPage extends StatefulWidget {
  final String adopterId;

  const AdopterRequestsPage({Key? key, required this.adopterId}) : super(key: key);

  @override
  State<AdopterRequestsPage> createState() => _AdopterRequestsPageState();
}

class _AdopterRequestsPageState extends State<AdopterRequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdoptionCubit>().getAdopterRequests(widget.adopterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis solicitudes')),
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
              return const Center(child: Text('Aún no has enviado solicitudes'));
            }
            return ListView.builder(
              itemCount: state.requests.length,
              itemBuilder: (context, index) {
                final req = state.requests[index];
                return ListTile(
                  leading: Text(req.getStatusEmoji()),
                  title: Text('Mascota: ${req.petId}'),
                  subtitle: Text('Estado: ${req.getStatusText()}'),
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
