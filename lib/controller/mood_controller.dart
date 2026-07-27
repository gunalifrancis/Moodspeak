import 'package:flutter/material.dart';

class MoodController extends ChangeNotifier {
  // Private constructor
  MoodController._internal();

  // Singleton instance
  static final MoodController instance = MoodController._internal();

  // Default mood
  String _mood = "Happy";

  // Getter
  String get mood => _mood;

  // Setter
  void setMood(String newMood) {
    _mood = newMood;
    notifyListeners();
  }
}
