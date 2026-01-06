import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/data/models/chat_model.dart';

abstract class ChatAiRemoteDataSource {
  /// Enviar mensaje a Gemini y obtener respuesta
  Future<String> sendMessage(
    String message,
    List<ChatMessage> conversationHistory,
  );
}

/// Implementación de ChatAiRemoteDataSource usando Google Generative AI
class ChatAiRemoteDataSourceImpl implements ChatAiRemoteDataSource {
  final String apiKey;
  late final GenerativeModel _model;

  ChatAiRemoteDataSourceImpl({required this.apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  @override
  Future<String> sendMessage(
    String message,
    List<ChatMessage> conversationHistory,
  ) async {
    // Construir el historial de conversación para Gemini
    final history = <Content>[];

    for (final msg in conversationHistory) {
      history.add(
        Content(
          msg.isUser ? 'user' : 'model',
          [TextPart(msg.text)],
        ),
      );
    }

    // Crear chat session
    final chat = _model.startChat(history: history);

    // Enviar nuevo mensaje
    final response = await chat.sendMessage(
      Content.text(message),
    );

    final text = response.text;
    if (text == null) throw Exception('No response from Gemini API');

    return text;
  }
}
