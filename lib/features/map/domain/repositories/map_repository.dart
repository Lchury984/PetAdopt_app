import 'package:petadopt_prueba2_app/features/map/domain/entities/shelter_pin_entity.dart';

abstract class MapRepository {
  /// Obtener ubicación actual (lat, lng)
  Future<(double lat, double lng)> getCurrentLocation();

  /// Obtener refugios (mock)
  Future<List<ShelterPinEntity>> getShelterPins();
}
