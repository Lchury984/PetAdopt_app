import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../domain/entities/message.dart';
import '../../service/gemini_service.dart';

/// Proveedor para el servicio de Gemini
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

/// Proveedor para el estado del chat usando StateNotifier
final chatProvider =
    StateNotifierProvider<ChatNotifier, List<Message>>((ref) {
  final geminiService = ref.watch(geminiServiceProvider);
  return ChatNotifier(geminiService);
});

/// Notificador que gestiona el estado del chat
class ChatNotifier extends StateNotifier<List<Message>> {
  final GeminiService _geminiService;
  List<Content> _conversationHistory = [];

  ChatNotifier(this._geminiService) : super([]);

  /// Envía un mensaje y obtiene respuesta de Gemini
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // Agregar mensaje del usuario al estado
    final userMsg = Message(
      text: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = [...state, userMsg];

    // Agregar al historial de Gemini
    _conversationHistory.add(
      Content('user', [TextPart(userMessage)]),
    );

    // Obtener respuesta de Gemini
    final responseText =
        await _geminiService.sendMessage(userMessage, _conversationHistory);

    // Agregar respuesta del bot al estado
    final botMsg = Message(
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
    );
    state = [...state, botMsg];

    // Agregar respuesta al historial
    _conversationHistory.add(
      Content('model', [TextPart(responseText)]),
    );
  }

  /// Limpia el chat y el historial
  void clearChat() {
    state = [];
    _conversationHistory = [];
  }

  /// Obtiene el número de mensajes
  int get messageCount => state.length;

  /// Obtiene el último mensaje
  Message? get lastMessage => state.isNotEmpty ? state.last : null;
}
