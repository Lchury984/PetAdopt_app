import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/map/domain/usecases/map_usecases.dart';
import 'package:petadopt_prueba2_app/features/map/presentation/cubit/map_state.dart';

class MapCubit extends Cubit<MapState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetShelterPinsUseCase getShelterPinsUseCase;

  MapCubit({
    required this.getCurrentLocationUseCase,
    required this.getShelterPinsUseCase,
  }) : super(const MapInitial());

  Future<void> loadMap() async {
    emit(const MapLoading());
    try {
      final location = await getCurrentLocationUseCase();
      final shelters = await getShelterPinsUseCase();
      emit(MapLoaded(userLocation: location, shelters: shelters));
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }
}
