import '../controller/mood_controller.dart';
import 'mood_speak_brain.dart';
import 'ai_service.dart';

class HybridAIService {
  static Future<String> getReply(String userInput) async {
    final mood = MoodController.instance.mood;

    // 1️⃣ Try API first
    try {
      final apiReply = await AIService.getChatResponse(
        mood: mood,
        userText: userInput,
      );

      // If API gives a meaningful response, use it
      if (apiReply.isNotEmpty && !apiReply.toLowerCase().contains("busy")) {
        return apiReply;
      }
    } catch (e) {
      // Ignore error → fallback
    }

    // 2️⃣ Fallback to local brain
    return MoodSpeakBrain.getReply(
      userInput: userInput,
      mood: mood,
    );
  }
}
