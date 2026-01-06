import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/domain/usecases/chat_ai_usecases.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/presentation/cubit/chat_ai_state.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/domain/entities/message_entity.dart';

/// Cubit para manejar el chat con IA
class ChatAiCubit extends Cubit<ChatAiState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetConversationHistoryUseCase getConversationHistoryUseCase;
  final SaveConversationHistoryUseCase saveConversationHistoryUseCase;
  final ClearConversationHistoryUseCase clearConversationHistoryUseCase;

  ChatAiCubit({
    required this.sendMessageUseCase,
    required this.getConversationHistoryUseCase,
    required this.saveConversationHistoryUseCase,
    required this.clearConversationHistoryUseCase,
  }) : super(const ChatAiInitial());

  List<MessageEntity> _messages = [];

  /// Cargar historial
  Future<void> loadHistory() async {
    emit(const ChatAiLoading());
    try {
      _messages = await getConversationHistoryUseCase();
      emit(ChatAiLoaded(messages: _messages));
    } catch (e) {
      emit(ChatAiError(message: e.toString()));
    }
  }

  /// Enviar mensaje
  Future<void> sendMessage(String message) async {
    emit(const ChatAiLoading());
    try {
      final response = await sendMessageUseCase(
        message: message,
        history: _messages,
      );
      _messages = [
        ..._messages,
        MessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: message,
          isUser: true,
          timestamp: DateTime.now(),
        ),
        response,
      ];
      await saveConversationHistoryUseCase(_messages);
      emit(ChatAiMessageSent(messages: _messages));
    } catch (e) {
      emit(ChatAiError(message: e.toString()));
    }
  }

  /// Limpiar historial
  Future<void> clearHistory() async {
    emit(const ChatAiLoading());
    try {
      await clearConversationHistoryUseCase();
      _messages = [];
      emit(const ChatAiLoaded(messages: []));
    } catch (e) {
      emit(ChatAiError(message: e.toString()));
    }
  }
}
