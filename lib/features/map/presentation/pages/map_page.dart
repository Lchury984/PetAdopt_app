import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:petadopt_prueba2_app/features/map/presentation/cubit/map_cubit.dart';
import 'package:petadopt_prueba2_app/features/map/presentation/cubit/map_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    context.read<MapCubit>().loadMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refugios cercanos')),
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          if (state is MapLoading || state is MapInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MapError) {
            return Center(child: Text(state.message));
          }
          final data = state as MapLoaded;
          final userLatLng = LatLng(data.userLocation.$1, data.userLocation.$2);
          final markers = [
            Marker(
              width: 40,
              height: 40,
              point: userLatLng,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
            ...data.shelters.map(
              (shelter) => Marker(
                width: 50,
                height: 50,
                point: LatLng(shelter.latitude, shelter.longitude),
                child: Column(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        shelter.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];

          return FlutterMap(
            options: MapOptions(
              initialCenter: userLatLng,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.petadopt',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}
