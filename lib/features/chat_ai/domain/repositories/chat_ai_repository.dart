import 'package:petadopt_prueba2_app/features/chat_ai/domain/entities/message_entity.dart';

abstract class ChatAiRepository {
  /// Enviar mensaje y obtener respuesta
  Future<MessageEntity> sendMessage(
    String message,
    List<MessageEntity> conversationHistory,
  );

  /// Obtener historial de conversación
  Future<List<MessageEntity>> getConversationHistory();

  /// Guardar historial
  Future<void> saveConversationHistory(List<MessageEntity> messages);

  /// Limpiar historial
  Future<void> clearHistory();
}
