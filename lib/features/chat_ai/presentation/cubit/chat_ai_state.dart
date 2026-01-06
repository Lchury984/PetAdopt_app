import 'package:petadopt_prueba2_app/features/chat_ai/domain/entities/message_entity.dart';

/// Estados para ChatAiCubit
abstract class ChatAiState {
  const ChatAiState();
}

/// Estado inicial
class ChatAiInitial extends ChatAiState {
  const ChatAiInitial();
}

/// Estado de carga
class ChatAiLoading extends ChatAiState {
  const ChatAiLoading();
}

/// Estado de mensajes cargados
class ChatAiLoaded extends ChatAiState {
  final List<MessageEntity> messages;

  const ChatAiLoaded({required this.messages});
}

/// Estado de mensaje enviado con respuesta
class ChatAiMessageSent extends ChatAiState {
  final List<MessageEntity> messages;

  const ChatAiMessageSent({required this.messages});
}

/// Estado de error
class ChatAiError extends ChatAiState {
  final String message;

  const ChatAiError({required this.message});
}
