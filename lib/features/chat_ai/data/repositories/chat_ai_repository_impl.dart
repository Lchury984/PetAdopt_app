import 'package:petadopt_prueba2_app/features/chat_ai/domain/entities/message_entity.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/domain/repositories/chat_ai_repository.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/data/datasources/chat_ai_remote_datasource.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/data/datasources/chat_ai_local_datasource.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/data/models/chat_model.dart';
import 'package:uuid/uuid.dart';

/// Implementación del repositorio de Chat AI
class ChatAiRepositoryImpl implements ChatAiRepository {
  final ChatAiRemoteDataSource remoteDataSource;
  final ChatAiLocalDataSource localDataSource;

  ChatAiRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<MessageEntity> sendMessage(
    String message,
    List<MessageEntity> conversationHistory,
  ) async {
    // Convertir entities a chat messages
    final chatHistory = conversationHistory
        .map((msg) => ChatMessage(
              id: '',
              text: msg.text,
              isUser: msg.isUser,
              timestamp: msg.timestamp,
            ))
        .toList();

    // Obtener respuesta de Gemini
    final response = await remoteDataSource.sendMessage(
      message,
      chatHistory,
    );

    // Crear entity de la respuesta
    final responseMessage = MessageEntity(
      id: const Uuid().v4(),
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
    );

    return responseMessage;
  }

  @override
  Future<List<MessageEntity>> getConversationHistory() async {
    final history = await localDataSource.getConversationHistory();
    return history
        .map((msg) => MessageEntity(
              id: msg.id,
              text: msg.text,
              isUser: msg.isUser,
              timestamp: msg.timestamp,
            ))
        .toList();
  }

  @override
  Future<void> saveConversationHistory(List<MessageEntity> messages) async {
    final chatMessages = messages
        .map((msg) => ChatMessage(
              id: msg.id,
              text: msg.text,
              isUser: msg.isUser,
              timestamp: msg.timestamp,
            ))
        .toList();

    await localDataSource.saveConversationHistory(chatMessages);
  }

  @override
  Future<void> clearHistory() async {
    await localDataSource.clearHistory();
  }
}
