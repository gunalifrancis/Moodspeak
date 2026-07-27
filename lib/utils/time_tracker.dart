import 'package:shared_preferences/shared_preferences.dart';

class TimeTracker {
  // Add seconds spent on a page
  static Future<void> addSeconds(String key, int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(key) ?? 0;
    current += seconds;
    await prefs.setInt(key, current);
  }

  // Get seconds spent
  static Future<int> getSeconds(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  // Quiz completion flag
  static Future<void> markQuizDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("quiz_stage_done", true);
  }

  static Future<bool> quizDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("quiz_stage_done") ?? false;
  }

  // Optional daily reset
  static Future<void> resetDaily() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("time_voice");
    await prefs.remove("time_chat");
    await prefs.remove("time_progress");
    await prefs.remove("quiz_stage_done");
  }
}
