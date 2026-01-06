/// Entidad de mascota en el dominio
class PetEntity {
  final String id;
  final String name;
  final String type;
  final String breed;
  final int age; // en meses
  final String description;
  final String? imageUrl;
  final String shelterId;
  final bool adopted;
  final DateTime createdAt;

  PetEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.description,
    this.imageUrl,
    required this.shelterId,
    this.adopted = false,
    required this.createdAt,
  });

  /// Obtener la edad en años y meses
  String getAgeFormatted() {
    final years = age ~/ 12;
    final months = age % 12;
    if (years == 0) return '$months meses';
    if (months == 0) return '$years años';
    return '$years años $months meses';
  }
}
