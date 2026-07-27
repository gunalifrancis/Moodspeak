import 'package:shared_preferences/shared_preferences.dart';

class DailyChallengeController {
  static const String _doneKey = "daily_challenge_done";
  static const String _completedAtKey = "daily_challenge_completed_at";

  static const int challengeDurationSeconds = 300; // 5 minutes
  static const int resetAfterHours = 24;

  /// Check if challenge is available
  static Future<bool> isAvailable() async {
    final prefs = await SharedPreferences.getInstance();

    bool done = prefs.getBool(_doneKey) ?? false;

    if (!done) return true;

    int? completedAt = prefs.getInt(_completedAtKey);
    if (completedAt == null) return true;

    final completedTime = DateTime.fromMillisecondsSinceEpoch(completedAt);

    final difference = DateTime.now().difference(completedTime);

    if (difference.inHours >= resetAfterHours) {
      await reset();
      return true;
    }

    return false;
  }

  /// Mark challenge complete
  static Future<void> complete() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_doneKey, true);
    await prefs.setInt(
      _completedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Reset challenge manually
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_doneKey, false);
    await prefs.remove(_completedAtKey);
  }

  /// Get remaining time until reset
  static Future<Duration?> remainingTime() async {
    final prefs = await SharedPreferences.getInstance();

    int? completedAt = prefs.getInt(_completedAtKey);
    if (completedAt == null) return null;

    final completedTime = DateTime.fromMillisecondsSinceEpoch(completedAt);

    final resetTime = completedTime.add(const Duration(hours: resetAfterHours));

    return resetTime.difference(DateTime.now());
  }
}
