import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/learning_level.dart';
import '../pages/selection_level.dart';
import '../pages/chat_learning.dart';
import '../pages/ai_voice_interaction.dart';
import '../pages/mood_selection.dart';
import '../pages/progress_daily_challenges.dart';
import '../screens/signin_screen.dart'; // Import your SignIn page

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  LearningLevel selectedLevel = LearningLevel.beginner;

  final List<List<Color>> gradientColors = [
    [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
    [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    [Color(0xFF00B09B), Color(0xFF96C93D)],
    [Color(0xFF5F0A87), Color(0xFF20BF55)],
  ];

  int gradientIndex = 0;
  late AnimationController _gradientController;
  late Animation<Color?> _color1Anim;
  late Animation<Color?> _color2Anim;

  @override
  void initState() {
    super.initState();
    _gradientController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6));
    _setNextGradient();
  }

  void _setNextGradient() {
    final nextIndex = (gradientIndex + 1) % gradientColors.length;

    _color1Anim = ColorTween(
      begin: gradientColors[gradientIndex][0],
      end: gradientColors[nextIndex][0],
    ).animate(_gradientController);

    _color2Anim = ColorTween(
      begin: gradientColors[gradientIndex][1],
      end: gradientColors[nextIndex][1],
    ).animate(_gradientController);

    _gradientController.forward(from: 0).whenComplete(() {
      gradientIndex = nextIndex;
      _setNextGradient();
    });
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> modules = [
      {
        "title": "Mood Selection",
        "subtitle": "Select your current mood",
        "icon": Icons.mood_rounded,
        "page": MoodSelectionPage(),
        "color": Colors.pinkAccent,
      },
      {
        "title": "Level Selection",
        "subtitle": "Choose your learning level",
        "icon": Icons.school_rounded,
        "page": SelectionLevelPage(
          onLevelSelected: (level) {
            setState(() {
              selectedLevel = level;
            });
          },
        ),
        "color": Colors.greenAccent,
      },
      {
        "title": "Chat Learning",
        "subtitle": "Practice English by chatting with AI",
        "icon": Icons.chat_bubble_rounded,
        "page": null, // will handle dynamically
        "color": Colors.cyan,
      },
      {
        "title": "AI Voice",
        "subtitle": "Speak naturally with AI",
        "icon": Icons.mic_rounded,
        "page": null, // will handle dynamically
        "color": Colors.purpleAccent,
      },
      {
        "title": "Daily Progress",
        "subtitle": "Check your daily challenges",
        "icon": Icons.timeline_rounded,
        "page": ProgressDailyChallengesPage(),
        "color": Colors.orangeAccent,
      },
    ];

    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _color1Anim.value ?? gradientColors[0][0],
                  _color2Anim.value ?? gradientColors[0][1],
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BACK BUTTON
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Navigate to SignIn page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignInScreen()),
                            );
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Home",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Learn English\nBased on Your Mood!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.builder(
                        itemCount: modules.length,
                        itemBuilder: (context, index) {
                          final module = modules[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () {
                                // Handle Chat & AI dynamically with selected level
                                Widget page;
                                if (module["title"] == "Chat Learning") {
                                  page = ChatLearningPage(level: selectedLevel);
                                } else if (module["title"] == "AI Voice") {
                                  page = AIVoiceInteractionPage(
                                      level: selectedLevel);
                                } else {
                                  page = module["page"];
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => page),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                                  child: Container(
                                    height: 100,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          (module["color"] as Color)
                                              .withOpacity(0.4),
                                          Colors.white.withOpacity(0.05),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.25),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              Colors.black.withOpacity(0.3),
                                          child: Icon(
                                            module["icon"],
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                module["title"],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                module["subtitle"],
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white70,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
