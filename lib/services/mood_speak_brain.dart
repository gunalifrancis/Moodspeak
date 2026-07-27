import 'mood_json_service.dart';

class MoodSpeakBrain {
  /// Main entry point
  static Future<String> getReply({
    required String userInput,
    required String mood, // happy / relaxed / sad / angry
  }) async {
    final input = userInput.trim().toLowerCase();

    // Load correct JSON based on mood (cached internally)
    await MoodJsonService.loadMoodJson(mood);

    // 1️⃣ Empty input
    if (input.isEmpty) {
      return MoodJsonService.getResponse(intent: "empty_input");
    }

    // 2️⃣ Greeting intent
    if (_containsAny(input, ["hi", "hello", "hey", "hai"])) {
      return MoodJsonService.getResponse(intent: "greeting");
    }

    // 3️⃣ Practice intent
    if (_containsAny(input, [
      "practice",
      "learn",
      "improve",
      "english",
      "speaking",
      "talk",
      "communication"
    ])) {
      return MoodJsonService.getResponse(intent: "practice");
    }

    // 4️⃣ Sentence feedback
    if (_looksLikeSentence(input)) {
      return MoodJsonService.getResponse(intent: "sentence_feedback");
    }

    // 5️⃣ Fallback
    return MoodJsonService.getResponse(intent: "fallback");
  }

  // -----------------------------
  // Helpers
  // -----------------------------

  static bool _containsAny(String text, List<String> patterns) {
    for (final p in patterns) {
      if (text.contains(p)) return true;
    }
    return false;
  }

  static bool _looksLikeSentence(String text) {
    return text.split(" ").length >= 3;
  }
}
