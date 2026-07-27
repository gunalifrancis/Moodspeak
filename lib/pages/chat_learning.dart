import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodspeak/controller/chat_controller.dart';
import 'package:moodspeak/controller/mood_controller.dart';
import '../screens/home_screen.dart'; // make sure this path is correct

class ChatLearningPage extends StatefulWidget {
  const ChatLearningPage({super.key});

  @override
  State<ChatLearningPage> createState() => _ChatLearningPageState();
}

class _ChatLearningPageState extends State<ChatLearningPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> messages = [];
  bool isTyping = false;

  Timer? _timer;
  int _secondsSpent = 0;

  static const int targetSeconds = 300;
  static const int rewardXP = 50;
  static const int primaryPurple = 0xFF9C6ADE;

  static const String chatTimeKey = "chat_time";
  static const String chatDoneKey = "challenge_chat_done";
  static const String chatCompletedAtKey = "challenge_chat_completed_at";
  static const String xpKey = "total_xp";

  bool challengeDone = false;
  Duration? remainingTime;

  @override
  void initState() {
    super.initState();
    _initializeChallenge();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _emojiForMood(String mood) {
    switch (mood.toLowerCase()) {
      case "happy":
        return "😊";
      case "relaxed":
        return "😌";
      case "sad":
        return "💙";
      case "angry":
        return "😡";
      default:
        return "🙂";
    }
  }

  Future<void> _initializeChallenge() async {
    final prefs = await SharedPreferences.getInstance();

    challengeDone = prefs.getBool(chatDoneKey) ?? false;

    if (challengeDone) {
      final completedAt = prefs.getInt(chatCompletedAtKey);

      if (completedAt != null) {
        final completedTime = DateTime.fromMillisecondsSinceEpoch(completedAt);
        final diff = DateTime.now().difference(completedTime);

        if (diff >= const Duration(hours: 24)) {
          await prefs.setBool(chatDoneKey, false);
          await prefs.remove(chatCompletedAtKey);
          await prefs.setInt(chatTimeKey, 0);
          challengeDone = false;
          _secondsSpent = 0;
        } else {
          remainingTime = const Duration(hours: 24) - diff;
        }
      }
    }

    if (!challengeDone) {
      _secondsSpent = prefs.getInt(chatTimeKey) ?? 0;
      _startTimer();
    }

    if (mounted) setState(() {});
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) return;

      if (_secondsSpent >= targetSeconds) {
        timer.cancel();
        await _completeChallenge();
        return;
      }

      _secondsSpent++;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(chatTimeKey, _secondsSpent);

      if (mounted) setState(() {});
    });
  }

  Future<void> _completeChallenge() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(chatDoneKey) ?? false) return;

    await prefs.setBool(chatDoneKey, true);
    await prefs.setInt(
      chatCompletedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );

    int currentXP = prefs.getInt(xpKey) ?? 0;
    await prefs.setInt(xpKey, currentXP + rewardXP);

    challengeDone = true;

    if (mounted) setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Daily Challenge Completed! +50 XP"),
        backgroundColor: Colors.green,
      ),
    );
  }

  String get _timeLabel {
    int min = _secondsSpent ~/ 60;
    int sec = _secondsSpent % 60;
    return "$min:${sec.toString().padLeft(2, '0')} / 5:00";
  }

  Future<void> sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userText = _controller.text.trim();

    setState(() {
      messages.add({"sender": "You", "text": userText});
      _controller.clear();
      isTyping = true;
    });

    _scrollToBottom();

    try {
      final aiReply = await ChatController.sendMessage(userText);

      if (!mounted) return;

      setState(() {
        messages.add({"sender": "AI", "text": aiReply});
        isTyping = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        messages.add({"sender": "AI", "text": "Something went wrong."});
        isTyping = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color purple = const Color(primaryPurple);

    return WillPopScope(
      onWillPop: () async {
        // Navigate back to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          title: const Text(
            "Chat Learning 💬",
            style: TextStyle(
              fontFamily: 'Cinzel',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 7, 7, 7),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  challengeDone
                      ? "Challenge Completed"
                      : "Progress: $_timeLabel",
                  style: const TextStyle(
                    fontFamily: 'Cinzel',
                    color: Color.fromARGB(255, 7, 7, 7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: MoodController.instance,
                  builder: (context, _) {
                    final mood = MoodController.instance.mood;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Mood: ${_emojiForMood(mood)} $mood",
                        style: const TextStyle(
                          fontFamily: 'Cinzel',
                          color: Color.fromARGB(255, 7, 7, 7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: messages.length + (isTyping ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (isTyping && index == messages.length) {
                        return const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "AI typing...",
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              color: Color.fromARGB(255, 7, 7, 7),
                            ),
                          ),
                        );
                      }

                      final msg = messages[index];
                      final isYou = msg["sender"] == "You";

                      return Align(
                        alignment: isYou
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isYou ? purple : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            msg["text"]!,
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              color: isYou ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(
                              fontFamily: 'Cinzel', color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Type...",
                            hintStyle: TextStyle(
                              fontFamily: 'Cinzel',
                              color: Colors.black,
                            ),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => sendMessage(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: purple),
                        onPressed: sendMessage,
                      )
                    ],
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
