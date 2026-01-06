/// Entidad para representar un refugio en el mapa
class ShelterPinEntity {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String phone;

  ShelterPinEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phone,
  });
}
