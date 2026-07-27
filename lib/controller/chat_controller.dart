import 'package:moodspeak/services/hybrid_ai_service.dart';

class ChatController {
  static Future<String> sendMessage(String userText) async {
    return await HybridAIService.getReply(userText);
  }
}
  