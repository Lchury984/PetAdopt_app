import 'package:petadopt_prueba2_app/features/chat_ai/data/models/chat_model.dart';

abstract class ChatAiLocalDataSource {
  /// Guardar historial de conversación
  Future<void> saveConversationHistory(List<ChatMessage> messages);

  /// Obtener historial de conversación
  Future<List<ChatMessage>> getConversationHistory();

  /// Limpiar historial
  Future<void> clearHistory();
}

/// Implementación de ChatAiLocalDataSource (en memoria)
class ChatAiLocalDataSourceImpl implements ChatAiLocalDataSource {
  final List<ChatMessage> _conversationHistory = [];

  @override
  Future<void> saveConversationHistory(List<ChatMessage> messages) async {
    _conversationHistory.clear();
    _conversationHistory.addAll(messages);
  }

  @override
  Future<List<ChatMessage>> getConversationHistory() async {
    return List.from(_conversationHistory);
  }

  @override
  Future<void> clearHistory() async {
    _conversationHistory.clear();
  }
}
