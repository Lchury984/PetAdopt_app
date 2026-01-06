import 'package:petadopt_prueba2_app/features/map/domain/entities/shelter_pin_entity.dart';

/// Estados para MapCubit
abstract class MapState {
  const MapState();
}

class MapInitial extends MapState {
  const MapInitial();
}

class MapLoading extends MapState {
  const MapLoading();
}

class MapLoaded extends MapState {
  final (double lat, double lng) userLocation;
  final List<ShelterPinEntity> shelters;

  const MapLoaded({
    required this.userLocation,
    required this.shelters,
  });
}

class MapError extends MapState {
  final String message;

  const MapError({required this.message});
}
