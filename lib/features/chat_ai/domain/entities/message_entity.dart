/// Entidad de mensaje en el dominio
class MessageEntity {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  MessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
