/// Entidad que representa un mensaje en el chat
class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  /// Crea una copia del mensaje con parámetros opcionales
  Message copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return Message(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() => 'Message(text: $text, isUser: $isUser, timestamp: $timestamp)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          isUser == other.isUser &&
          timestamp == other.timestamp;

  @override
  int get hashCode => text.hashCode ^ isUser.hashCode ^ timestamp.hashCode;
}
