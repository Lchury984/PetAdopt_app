/// Entidad de solicitud de adopción
class AdoptionRequestEntity {
  final String id;
  final String petId;
  final String adopterId;
  final String shelterId;
  final String status; // 'pending', 'approved', 'rejected'
  final String? message;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdoptionRequestEntity({
    required this.id,
    required this.petId,
    required this.adopterId,
    required this.shelterId,
    required this.status,
    this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Verificar si la solicitud está pendiente
  bool get isPending => status == 'pending';

  /// Verificar si la solicitud fue aprobada
  bool get isApproved => status == 'approved';

  /// Verificar si la solicitud fue rechazada
  bool get isRejected => status == 'rejected';

  /// Obtener emoji del estado
  String getStatusEmoji() {
    switch (status) {
      case 'approved':
        return '✅';
      case 'rejected':
        return '❌';
      default:
        return '⏳';
    }
  }

  /// Obtener texto del estado
  String getStatusText() {
    switch (status) {
      case 'approved':
        return 'Aprobada';
      case 'rejected':
        return 'Rechazada';
      default:
        return 'Pendiente';
    }
  }
}
