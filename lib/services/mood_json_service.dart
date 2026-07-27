import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

class MoodJsonService {
  static final Random _random = Random();
  static Map<String, dynamic>? _cachedJson;
  static String? _cachedMood;

  static Future<void> loadMoodJson(String mood) async {
    try {
      if (_cachedMood == mood && _cachedJson != null) return;

      final fileName = mood.toLowerCase(); // happy, sad, angry, relaxed
      final path = 'assets/data/$fileName.json';

      print('📦 Loading JSON: $path');

      final jsonString = await rootBundle.loadString(path);
      _cachedJson = jsonDecode(jsonString);
      _cachedMood = mood;

      print('✅ JSON loaded for mood: $mood');
    } catch (e) {
      print('❌ Error loading JSON for mood $mood: $e');
      _cachedJson = null;
    }
  }

  static String getResponse({required String intent}) {
    if (_cachedJson == null) {
      return "⚠️ JSON not loaded. Please try again.";
    }

    final section = _cachedJson![intent];
    if (section == null || section["responses"] == null) {
      return "⚠️ No response found for intent: $intent";
    }

    final List responses = section["responses"];
    return responses[_random.nextInt(responses.length)];
  }
}
  