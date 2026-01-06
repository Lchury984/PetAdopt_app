/// Modelo de mensaje de chat
class ChatMessage {
  final String id;
  final String text;
  final bool isUser; // true si es del usuario, false si es de la IA
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  /// Obtener el rol del remitente
  String getSenderRole() => isUser ? 'user' : 'model';
}

/// Modelo para la estructura esperada por Gemini API
class GeminiMessage {
  final String role; // 'user' o 'model'
  final String text;

  GeminiMessage({
    required this.role,
    required this.text,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'parts': [
          {'text': text}
        ]
      };
}
