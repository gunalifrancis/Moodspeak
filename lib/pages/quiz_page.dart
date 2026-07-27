import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'quiz_menu_page.dart'; // back to menu page

class QuizPage extends StatefulWidget {
  final String title;
  final int levelIndex;
  final List<Map<String, Object>> allQuestions;

  const QuizPage({
    super.key,
    required this.title,
    required this.levelIndex,
    required this.allQuestions,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int stage = 0;
  int index = 0;
  bool loaded = false;
  List<int?> answers = [];
  int? selectedAnswer;
  final AudioPlayer player = AudioPlayer();

  String get saveKey => "quiz_progress_${widget.levelIndex}";

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> playSound(String file) async {
    try {
      await player.stop();
      await player.play(AssetSource("sounds/$file"));
    } catch (_) {}
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    stage = (prefs.getInt("${saveKey}_stage") ?? 0).clamp(0, 4);
    index = prefs.getInt("${saveKey}_index") ?? 0;

    List<String>? saved = prefs.getStringList("${saveKey}_answers");
    answers = List.generate(
      10,
      (i) => saved != null && i < saved.length && saved[i].isNotEmpty
          ? int.tryParse(saved[i])
          : null,
    );

    loaded = true;
    setState(() {});
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("${saveKey}_stage", stage);
    await prefs.setInt("${saveKey}_index", index);
    await prefs.setStringList(
      "${saveKey}_answers",
      answers.map((e) => e?.toString() ?? "").toList(),
    );
  }

  List<Map<String, Object>> get stageQuestions {
    int start = stage * 10;
    int end = (start + 10).clamp(0, widget.allQuestions.length);
    if (start >= widget.allQuestions.length) return [];
    return widget.allQuestions.sublist(start, end);
  }

  int calculateScore() {
    int s = 0;
    for (int i = 0; i < stageQuestions.length; i++) {
      if (answers[i] == null) continue;
      int correct = stageQuestions[i]["answer"] as int;
      if (answers[i] == correct) s++;
    }
    return s;
  }

  Future<void> submitAnswer() async {
    if (selectedAnswer == null) return; // no answer selected

    answers[index] = selectedAnswer;
    int correct = stageQuestions[index]["answer"] as int;
    await playSound(selectedAnswer == correct ? "correct.mp3" : "wrong.mp3");

    selectedAnswer = null; // reset selection for next question

    if (index < stageQuestions.length - 1) {
      index++;
    } else {
      await finishStage();
    }

    await saveProgress();
    setState(() {});
  }

  Future<void> previous() async {
    if (index > 0) {
      index--;
      selectedAnswer = answers[index];
      setState(() {});
    }
  }

  Future<void> finishStage() async {
    int score = calculateScore();
    bool pass = score >= 5;

    await playSound(pass ? "win.mp3" : "loss.mp3");

    final prefs = await SharedPreferences.getInstance();
    int earnedXp = score * 10;
    int totalXp = prefs.getInt("total_xp") ?? 0;
    totalXp += earnedXp;
    await prefs.setInt("total_xp", totalXp);

    int currentUnlocked = prefs.getInt("unlockedLevel") ?? 0;
    if (pass && widget.levelIndex >= currentUnlocked) {
      await prefs.setInt("unlockedLevel", widget.levelIndex + 1);
    }

    // Reset for next stage
    index = 0;
    answers = List.generate(10, (_) => null);
    selectedAnswer = null;
    if (pass && stage < 4) stage++;
    await saveProgress();

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color.fromARGB(255, 250, 250, 251),
        title: Text(
          pass ? "Stage Cleared 🎉" : "Try Again",
          style: const TextStyle(
            fontFamily: "Cinzel",
            color: Color.fromARGB(255, 7, 7, 7),
          ),
        ),
        content: Text(
          "Score: $score / ${stageQuestions.length}",
          style: const TextStyle(
            fontFamily: "Cinzel",
            color: Color.fromARGB(255, 7, 7, 7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(
                fontFamily: "Cinzel",
                color: Color(0xFF9C6ADE),
              ),
            ),
          ),
        ],
      ),
    );

    setState(() {});
  }

  Widget optionCard(String text, int i) {
    bool selected = selectedAnswer == i;
    String badge = String.fromCharCode(65 + i);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () => setState(() => selectedAnswer = i),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF9C6ADE).withOpacity(.35)
                    : const Color.fromARGB(255, 7, 7, 7).withOpacity(.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF9C6ADE)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(.6),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        fontFamily: "Cinzel",
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 7, 7, 7),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontFamily: "Cinzel",
                        fontSize: 16,
                        color: Color.fromARGB(255, 7, 7, 7),
                      ),
                    ),
                  ),
                  if (selected)
                    const Icon(Icons.check, color: Color(0xFF9C6ADE))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded || stageQuestions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final q = stageQuestions[index];
    final options = q["options"] as List<String>;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QuizMenuPage()),
        );
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF9C6ADE)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const QuizMenuPage()),
              );
            },
          ),
          title: Text(
            "${widget.title} — Stage ${stage + 1}/5",
            style: const TextStyle(
              fontFamily: "Cinzel",
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 7, 7, 7),
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/bg.png", fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    q["question"] as String,
                    style: const TextStyle(
                      fontFamily: "Cinzel",
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color.fromARGB(255, 7, 7, 7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: List.generate(
                        options.length,
                        (i) => optionCard(options[i], i),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: index == 0 ? null : previous,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9C6ADE),
                        ),
                        child: const Text("Previous"),
                      ),
                      ElevatedButton(
                        onPressed: selectedAnswer == null ? null : submitAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9C6ADE),
                        ),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
