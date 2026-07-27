import 'package:shared_preferences/shared_preferences.dart';

class XPController {
  static const String xpKey = "USER_XP";

  // Get saved XP
  static Future<int> getXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(xpKey) ?? 0;
  }

  // Add XP
  static Future<void> addXP(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(xpKey) ?? 0;
    await prefs.setInt(xpKey, current + amount);
  }

  // Reset (optional debug)
  static Future<void> resetXP() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(xpKey, 0);
  }

  // Unlock checks
  static Future<bool> unlockedIntermediate() async {
    return (await getXP()) >= 100;
  }

  static Future<bool> unlockedAdvanced() async {
    return (await getXP()) >= 250;
  }
}
