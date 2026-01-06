import 'package:petadopt_prueba2_app/features/map/domain/entities/shelter_pin_entity.dart';
import 'package:petadopt_prueba2_app/features/map/domain/repositories/map_repository.dart';

class GetCurrentLocationUseCase {
  final MapRepository repository;

  GetCurrentLocationUseCase({required this.repository});

  Future<(double lat, double lng)> call() async {
    return await repository.getCurrentLocation();
  }
}

class GetShelterPinsUseCase {
  final MapRepository repository;

  GetShelterPinsUseCase({required this.repository});

  Future<List<ShelterPinEntity>> call() async {
    return await repository.getShelterPins();
  }
}
