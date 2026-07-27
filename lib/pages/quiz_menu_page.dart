import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_page.dart';
import 'quiz_questions.dart';
import '../screens/home_screen.dart'; // import HomeScreen

class QuizMenuPage extends StatefulWidget {
  const QuizMenuPage({super.key});

  @override
  State<QuizMenuPage> createState() => _QuizMenuPageState();
}

class _QuizMenuPageState extends State<QuizMenuPage> {
  int unlockedLevel = 0;

  final TextStyle titleFont = const TextStyle(
    fontFamily: "Cinzel",
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 7, 7, 7),
    letterSpacing: 1.2,
  );

  final TextStyle subFont = const TextStyle(
    fontFamily: "Cinzel",
    fontSize: 14,
    color: Color.fromARGB(255, 7, 7, 7),
  );

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => unlockedLevel = prefs.getInt("unlockedLevel") ?? 0);
  }

  void open(String title, int level, List<Map<String, Object>> q) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(
          title: title,
          levelIndex: level,
          allQuestions: q,
        ),
      ),
    ).then((_) => load());
  }

  Widget levelCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required int levelIndex,
    required List<Map<String, Object>> questions,
  }) {
    bool locked = levelIndex > unlockedLevel;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: locked ? null : () => open(title, levelIndex, questions),
      child: Opacity(
        opacity: locked ? .55 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 7, 7, 7).withOpacity(.12),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: locked
                        ? const Color.fromARGB(255, 7, 7, 7).withOpacity(.25)
                        : const Color(0xFF9C6ADE),
                    width: 1.4,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: locked
                          ? Colors.white24
                          : const Color(0xFF9C6ADE).withOpacity(.2),
                      child: Icon(
                        locked ? Icons.lock : icon,
                        size: 30,
                        color: locked
                            ? const Color.fromARGB(255, 7, 7, 7)
                            : const Color(0xFF9C6ADE),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: titleFont),
                          const SizedBox(height: 6),
                          Text(
                            locked
                                ? "Locked — finish previous level"
                                : subtitle,
                            style: subFont,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: locked
                          ? const Color.fromARGB(255, 7, 7, 7)
                          : const Color(0xFF9C6ADE),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color.fromARGB(255, 7, 7, 7)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          "Choose Level",
          style: TextStyle(
            fontFamily: "Cinzel",
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
            color: Color.fromARGB(255, 7, 7, 7),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/bg.png", fit: BoxFit.cover),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("📝 Quiz Time!",
                        style: TextStyle(fontSize: 28, fontFamily: "Cinzel")),
                    const SizedBox(height: 12),
                    levelCard(
                      title: "Beginner",
                      subtitle: "Start easy and warm up",
                      icon: Icons.sentiment_satisfied_alt,
                      levelIndex: 0,
                      questions: QuizQuestions.beginner,
                    ),
                    levelCard(
                      title: "Intermediate",
                      subtitle: "Step up the challenge",
                      icon: Icons.trending_up,
                      levelIndex: 1,
                      questions: QuizQuestions.intermediate,
                    ),
                    levelCard(
                      title: "Advanced",
                      subtitle: "Hardcore mode",
                      icon: Icons.flash_on,
                      levelIndex: 2,
                      questions: QuizQuestions.advanced,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
