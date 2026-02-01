enum LearningLevel { beginner, intermediate, advanced }

extension LearningLevelExtension on LearningLevel {
  String get label {
    switch (this) {
      case LearningLevel.beginner:
        return "Beginner";
      case LearningLevel.intermediate:
        return "Intermediate";
      case LearningLevel.advanced:
        return "Advanced";
    }
  }
}
