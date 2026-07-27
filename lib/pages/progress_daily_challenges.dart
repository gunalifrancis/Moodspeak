import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodspeak/screens/home_screen.dart';

class ProgressDailyChallengesPage extends StatefulWidget {
  const ProgressDailyChallengesPage({super.key});

  @override
  State<ProgressDailyChallengesPage> createState() =>
      _ProgressDailyChallengesPageState();
}

class _ProgressDailyChallengesPageState
    extends State<ProgressDailyChallengesPage> with WidgetsBindingObserver {
  int xp = 0;
  int beginner = 0;
  int intermediate = 0;
  int advanced = 0;

  final int totalStages = 5;
  bool loaded = false;

  int chatSeconds = 0;
  int voiceSeconds = 0;
  final int challengeTarget = 300;

  bool chatDone = false;
  bool voiceDone = false;

  static const int primaryPurple = 0xFF9C6ADE;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStats();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadStats();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStats(); // ensures refresh when coming back from quiz
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();

    xp = prefs.getInt("total_xp") ?? 0;

    // stages start from 1 if user completed stage 1
    beginner = (prefs.getInt("stage_beginner") ?? 0).clamp(0, totalStages);
    intermediate =
        (prefs.getInt("stage_intermediate") ?? 0).clamp(0, totalStages);
    advanced = (prefs.getInt("stage_advanced") ?? 0).clamp(0, totalStages);

    // Ensure 1-based display for first stage
    beginner = beginner > 0 ? beginner : 0;
    intermediate = intermediate > 0 ? intermediate : 0;
    advanced = advanced > 0 ? advanced : 0;

    chatSeconds = prefs.getInt("chat_time") ?? 0;
    voiceSeconds = prefs.getInt("voice_time") ?? 0;

    chatDone = prefs.getBool("challenge_chat_done") ?? false;
    voiceDone = prefs.getBool("challenge_voice_done") ?? false;

    loaded = true;
    if (mounted) setState(() {});
  }

  Widget buildStageBar(String title, int completed) {
    final value = completed / totalStages;
    final purple = const Color(primaryPurple);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title — Stage $completed / $totalStages",
          style: const TextStyle(
            color: Color.fromARGB(255, 7, 7, 7),
            fontFamily: "Cinzel",
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          builder: (_, v, __) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: v,
                minHeight: 14,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation(
                  completed == totalStages ? Colors.greenAccent : purple,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget buildChallengeRow(String title, int seconds, bool done) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;

    return Row(
      children: [
        Expanded(
          child: Text(
            "$title: $min:${sec.toString().padLeft(2, '0')} / 5:00",
            style: const TextStyle(
              color: Color.fromARGB(255, 7, 7, 7),
              fontFamily: "Cinzel",
              fontSize: 16,
            ),
          ),
        ),
        Icon(
          done ? Icons.check_circle : Icons.timelapse,
          color: done ? Colors.greenAccent : Colors.white70,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          "Your Progress 🚀",
          style: TextStyle(
            fontFamily: "Cinzel",
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 7, 7, 7),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 7, 7, 7)
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "XP LEVEL",
                            style: TextStyle(
                              color: Color.fromARGB(255, 7, 7, 7),
                              fontFamily: "Cinzel",
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "$xp XP",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 7, 7, 7),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Cinzel",
                            ),
                          ),
                          const SizedBox(height: 24),
                          buildChallengeRow(
                              "Chat Challenge", chatSeconds, chatDone),
                          const SizedBox(height: 12),
                          buildChallengeRow(
                              "Voice Challenge", voiceSeconds, voiceDone),
                          const SizedBox(height: 24),
                          buildStageBar("Beginner", beginner),
                          buildStageBar("Intermediate", intermediate),
                          buildStageBar("Advanced", advanced),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
