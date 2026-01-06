/// Entidad de usuario en el dominio
class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final String role; // 'adopter' o 'shelter'
  final String? profileImageUrl;
  final DateTime createdAt;

  UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
  });
}
