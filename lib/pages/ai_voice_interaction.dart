import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/learning_level.dart';
import '../screens/home_screen.dart'; // Make sure the path is correct

class AIVoiceInteractionPage extends StatefulWidget {
  final LearningLevel level;

  const AIVoiceInteractionPage({
    super.key,
    required this.level,
  });

  @override
  State<AIVoiceInteractionPage> createState() => _AIVoiceInteractionPageState();
}

class _AIVoiceInteractionPageState extends State<AIVoiceInteractionPage>
    with TickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = "Tap the mic to start speaking";

  late AnimationController _circleController;

  final List<List<Color>> gradientColors = [
    [Color(0xFF5F0A87), Color(0xFF20BF55)],
    [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    [Color(0xFF00B09B), Color(0xFF96C93D)],
    [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
  ];

  int currentIndex = 0;
  late List<Color> currentGradient;

  String get _practicePrompt {
    switch (widget.level) {
      case LearningLevel.beginner:
        return "Say: \"My name is ____\"";
      case LearningLevel.intermediate:
        return "Say: \"Today I feel ____ because ____\"";
      case LearningLevel.advanced:
        return "Say: \"In my opinion, technology has changed our lives because...\"";
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    currentGradient = gradientColors[0];
    _animateGradient();

    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _spokenText =
        "🎯 Practice Prompt (${widget.level.label}):\n$_practicePrompt";
  }

  @override
  void dispose() {
    _circleController.dispose();
    super.dispose();
  }

  void _animateGradient() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        currentIndex = (currentIndex + 1) % gradientColors.length;
        currentGradient = gradientColors[currentIndex];
      });
      _animateGradient();
    });
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords.isEmpty
                ? "Listening..."
                : result.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _stopListening() {
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _resetPrompt() {
    setState(() {
      _spokenText =
          "🎯 Practice Prompt (${widget.level.label}):\n$_practicePrompt";
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        return false; // prevent default pop
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
        ),
        body: AnimatedContainer(
          duration: const Duration(seconds: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: currentGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "AI Voice Assistant 🎧",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Level: ${widget.level.label}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isListening ? "Listening..." : "Tap the mic to speak",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AnimatedBuilder(
                    animation: _circleController,
                    builder: (context, child) {
                      double scale = 1 + 0.05 * (_circleController.value);
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      onTap: _toggleListening,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            _isListening ? Colors.deepPurple : Colors.white,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          size: 40,
                          color:
                              _isListening ? Colors.white : Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          _spokenText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _resetPrompt,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Prompt",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _stopListening,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Stop",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
