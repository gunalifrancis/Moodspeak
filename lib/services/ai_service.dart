import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AIService {
  // 🔑 GROQ API KEY
  static const String _apiKey = "";

  static Future<String> getChatResponse({
    required String mood,
    required String userText,
  }) async {
    final url = Uri.parse(
      "https://api.groq.com/openai/v1/chat/completions",
    );

    final body = {
      "model": "llama-3.1-8b-instant",
      "messages": [
        {
          "role": "system",
          "content": "You are a friendly English learning assistant. "
              "User mood is $mood. "
              "Respond supportively and help improve English."
        },
        {"role": "user", "content": userText}
      ],
      "temperature": 0.7,
      "max_tokens": 150
    };

    try {
      debugPrint("🟡 [GROQ] Sending request...");
      debugPrint("🟡 [GROQ] Mood: $mood");
      debugPrint("🟡 [GROQ] User text: $userText");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint("🟡 [GROQ] HTTP status: ${response.statusCode}");
      debugPrint("🟡 [GROQ] Raw response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reply = data['choices'][0]['message']['content'];

        debugPrint("🟢 [GROQ SUCCESS] Reply received");
        return reply.trim();
      } else {
        debugPrint("🔴 [GROQ ERROR] Non-200 response");
        return "AI is busy right now.";
      }
    } catch (e, stack) {
      debugPrint("❌ [GROQ EXCEPTION] $e");
      debugPrint("$stack");
      return "AI is busy right now.";
    }
  }
}
