import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/mood_controller.dart';
import '../pages/chat_learning.dart';
import '../pages/ai_voice_interaction.dart';
import '../pages/progress_daily_challenges.dart';
import '../pages/quiz_menu_page.dart';
import 'profile_screen.dart';

////////////////////////////////////////////////////////////
/// HOME SCREEN
////////////////////////////////////////////////////////////

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeTab(),
    AIVoiceInteractionPage(),
    ChatLearningPage(),
    QuizMenuPage(),
    ProgressDailyChallengesPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),

      ////////////////////////////////////////////////////////////
      /// 🔥 BOTTOM NAV
      ////////////////////////////////////////////////////////////
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF9C6ADE),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (i) => setState(() => currentIndex = i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF9C6ADE),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            elevation: 0,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "Home"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.mic), label: "AI Voice"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.chat), label: "Chat"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.quiz), label: "Quiz"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart), label: "Progress"),

              ////////////////////////////////////////////////////////////
              /// PROFILE IMAGE
              ////////////////////////////////////////////////////////////
              BottomNavigationBarItem(
                icon: user == null
                    ? const Icon(Icons.account_circle)
                    : StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(user.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data!.data() == null) {
                            return const Icon(Icons.account_circle);
                          }

                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          if (data["profileImage"] != null &&
                              data["profileImage"] != "") {
                            return CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundImage:
                                    NetworkImage(data["profileImage"]),
                              ),
                            );
                          }

                          return const Icon(Icons.account_circle);
                        },
                      ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HOME TAB
////////////////////////////////////////////////////////////

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  int boomIndex = -1;

  late AnimationController particleController;

  String selectedEmoji = "😐";

  final moods = const [
    {"title": "Happy", "img": "assets/happy.jpeg"},
    {"title": "Relaxed", "img": "assets/relax.jpeg"},
    {"title": "Sad", "img": "assets/sad.jpeg"},
    {"title": "Angry", "img": "assets/angry.jpeg"},
  ];

  final List<String> emojis = ["😊", "😌", "😢", "😡"];

  @override
  void initState() {
    super.initState();

    particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    particleController.dispose();
    super.dispose();
  }

  void handleTap(int index) async {
    setState(() {
      boomIndex = index;
      selectedEmoji = emojis[index];
    });

    particleController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 200));

    try {
      MoodController.instance.setMood(moods[index]["title"]!);
    } catch (_) {}

    setState(() => boomIndex = -1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ////////////////////////////////////////////////////////////
        /// BACKGROUND
        ////////////////////////////////////////////////////////////
        Positioned.fill(
          child: Image.asset("assets/bg.png", fit: BoxFit.cover),
        ),

        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.15),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SizedBox(height: 30),

                ////////////////////////////////////////////////////////////
                /// TITLE (CINZEL APPLIED)
                ////////////////////////////////////////////////////////////
                Column(
                  children: [
                    const Text(
                      "Mood English",
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 60, height: 1, color: Colors.white70),
                        const SizedBox(width: 10),
                        Text(
                          selectedEmoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 10),
                        Container(width: 60, height: 1, color: Colors.white70),
                      ],
                    ),
                  ],
                ),

                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Learn English Based on Your Mood!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "How are you feeling today?",
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ////////////////////////////////////////////////////////////
                /// GRID
                ////////////////////////////////////////////////////////////
                Expanded(
                  child: GridView.builder(
                    itemCount: moods.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                    ),
                    itemBuilder: (context, index) {
                      final mood = moods[index];

                      return GestureDetector(
                        onTap: () => handleTap(index),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: boomIndex == index ? 1.08 : 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset(
                                      mood["img"]!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.5),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    left: 0,
                                    right: 0,
                                    child: Text(
                                      mood["title"]!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Cinzel',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
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
      ],
    );
  }
}
