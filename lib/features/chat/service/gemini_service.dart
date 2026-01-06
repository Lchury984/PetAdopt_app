import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:petadopt_prueba2_app/core/constants/app_constants.dart';

/// Servicio para interactuar con la API de Gemini
class GeminiService {
  late GenerativeModel _model;

  GeminiService() {
    // Preferir --dart-define, fallback a .env
    final apiKey = AppConstants.geminiApiKey;
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY no configurada. Usa --dart-define GEMINI_API_KEY=tu-clave o configura en .env');
    }
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  /// Envía un mensaje a Gemini y obtiene una respuesta
  /// [userMessage] - El mensaje del usuario
  /// [history] - El historial de la conversación
  Future<String> sendMessage(String userMessage, List<Content> history) async {
    try {
      // Crear una sesión de chat con el historial
      final chat = _model.startChat(history: history);
      
      // Enviar el nuevo mensaje
      final response = await chat.sendMessage(
        Content.text(userMessage),
      );
      
      // Retornar el texto de la respuesta
      return response.text ?? 'Sin respuesta del servidor';
    } catch (e) {
      return 'Error al comunicarse con Gemini: $e';
    }
  }

  /// Construye el historial de conversación en el formato esperado por Gemini
  static List<Content> buildHistory(List<String> messages) {
    final history = <Content>[];
    for (int i = 0; i < messages.length; i++) {
      final role = i % 2 == 0 ? 'user' : 'model';
      history.add(Content(role, [TextPart(messages[i])]));
    }
    return history;
  }
}
