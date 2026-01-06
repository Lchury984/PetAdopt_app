import 'package:petadopt_prueba2_app/features/map/data/datasources/map_local_datasource.dart';
import 'package:petadopt_prueba2_app/features/map/domain/entities/shelter_pin_entity.dart';
import 'package:petadopt_prueba2_app/features/map/domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final MapLocalDataSource localDataSource;

  MapRepositoryImpl({required this.localDataSource});

  @override
  Future<(double lat, double lng)> getCurrentLocation() async {
    return await localDataSource.getCurrentLocation();
  }

  @override
  Future<List<ShelterPinEntity>> getShelterPins() async {
    return await localDataSource.getMockShelters();
  }
}
