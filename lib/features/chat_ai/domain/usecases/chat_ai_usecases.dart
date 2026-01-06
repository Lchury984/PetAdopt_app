import 'package:petadopt_prueba2_app/features/chat_ai/domain/entities/message_entity.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/domain/repositories/chat_ai_repository.dart';

/// UseCase para enviar mensaje
class SendMessageUseCase {
  final ChatAiRepository repository;

  SendMessageUseCase({required this.repository});

  Future<MessageEntity> call({
    required String message,
    required List<MessageEntity> history,
  }) async {
    // Enviar mensaje con historial actualizado
    return await repository.sendMessage(message, history);
  }
}

/// UseCase para obtener historial
class GetConversationHistoryUseCase {
  final ChatAiRepository repository;

  GetConversationHistoryUseCase({required this.repository});

  Future<List<MessageEntity>> call() async {
    return await repository.getConversationHistory();
  }
}

/// UseCase para guardar historial
class SaveConversationHistoryUseCase {
  final ChatAiRepository repository;

  SaveConversationHistoryUseCase({required this.repository});

  Future<void> call(List<MessageEntity> messages) async {
    return await repository.saveConversationHistory(messages);
  }
}

/// UseCase para limpiar historial
class ClearConversationHistoryUseCase {
  final ChatAiRepository repository;

  ClearConversationHistoryUseCase({required this.repository});

  Future<void> call() async {
    return await repository.clearHistory();
  }
}
