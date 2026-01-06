import 'package:geolocator/geolocator.dart';
import 'package:petadopt_prueba2_app/features/map/domain/entities/shelter_pin_entity.dart';

abstract class MapLocalDataSource {
  Future<(double lat, double lng)> getCurrentLocation();
  Future<List<ShelterPinEntity>> getMockShelters();
}

class MapLocalDataSourceImpl implements MapLocalDataSource {
  @override
  Future<(double lat, double lng)> getCurrentLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        // Coordenadas de fallback (CDMX)
        return (19.4326, -99.1332);
      }
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return (position.latitude, position.longitude);
  }

  @override
  Future<List<ShelterPinEntity>> getMockShelters() async {
    return [
      ShelterPinEntity(
        id: 's1',
        name: 'Refugio Patitas Felices',
        latitude: 19.4340,
        longitude: -99.1400,
        address: 'Centro, CDMX',
        phone: '+52 55 1111 2222',
      ),
      ShelterPinEntity(
        id: 's2',
        name: 'Huellas y Esperanza',
        latitude: 19.4280,
        longitude: -99.1200,
        address: 'Roma Norte, CDMX',
        phone: '+52 55 3333 4444',
      ),
    ];
  }
}
