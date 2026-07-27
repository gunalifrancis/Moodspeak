class QuizQuestion {
  final String question;
  final List<String> options;
  final int answerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
  });
}

final List<QuizQuestion> beginnerQuestions = [
  QuizQuestion(
    question: "Apple is a —",
    options: ["Animal", "Fruit", "Vehicle", "Tool"],
    answerIndex: 1,
  ),
  QuizQuestion(
    question: "Opposite of HOT",
    options: ["Cold", "Fast", "Tall", "Hard"],
    answerIndex: 0,
  ),
  QuizQuestion(
    question: "Which word is a verb?",
    options: ["Run", "Blue", "Chair", "Happy"],
    answerIndex: 0,
  ),
  QuizQuestion(
    question: "Plural of CHILD",
    options: ["Childs", "Children", "Childes", "Child"],
    answerIndex: 1,
  ),
  QuizQuestion(
    question: "Synonym of BIG",
    options: ["Tiny", "Large", "Short", "Weak"],
    answerIndex: 1,
  ),
  QuizQuestion(
    question: "Which is a color?",
    options: ["Dog", "Red", "Car", "Jump"],
    answerIndex: 1,
  ),
  QuizQuestion(
    question: "Opposite of FAST",
    options: ["Quick", "Rapid", "Slow", "Speed"],
    answerIndex: 2,
  ),
  QuizQuestion(
    question: "Which is a noun?",
    options: ["Run", "Eat", "Table", "Jump"],
    answerIndex: 2,
  ),
  QuizQuestion(
    question: "Fill in: I ___ happy",
    options: ["is", "am", "are", "be"],
    answerIndex: 1,
  ),
  QuizQuestion(
    question: "Bird can —",
    options: ["Swim", "Drive", "Fly", "Cook"],
    answerIndex: 2,
  ),
];
