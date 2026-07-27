import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controller/voice_controller.dart';
import '../services/tts_service.dart';
import '../screens/home_screen.dart'; // make sure this path is correct

class AIVoiceInteractionPage extends StatefulWidget {
  const AIVoiceInteractionPage({super.key});

  @override
  State<AIVoiceInteractionPage> createState() => _AIVoiceInteractionPageState();
}

class _AIVoiceInteractionPageState extends State<AIVoiceInteractionPage>
    with TickerProviderStateMixin {
  bool _isListening = false;
  String _spokenText = "Tap the mic to start speaking";

  late AnimationController _animationController;
  Timer? _timer;

  static const primaryPurple = Color(0xFF9C6ADE);

  @override
  void initState() {
    super.initState();
    TTSService.init();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    VoiceController.stopListening();
    TTSService.stop();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// MIC PERMISSION
  ////////////////////////////////////////////////////////////
  Future<bool> _checkPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  ////////////////////////////////////////////////////////////
  /// START LISTENING
  ////////////////////////////////////////////////////////////
  Future<void> _startListening() async {
    bool granted = await _checkPermission();
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Microphone permission denied"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isListening = true;
      _spokenText = "Listening...";
    });

    VoiceController.startListening(
      onListening: (text) {
        if (!mounted) return;
        setState(() {
          _spokenText = text;
        });
      },
      onComplete: (userText, aiReply) async {
        if (!mounted) return;

        setState(() {
          _isListening = false;
          _spokenText = "You: $userText\n\nAI: $aiReply";
        });

        await TTSService.speak(aiReply);
      },
    );
  }

  void _stopListening() {
    VoiceController.stopListening();
    TTSService.stop();

    setState(() {
      _isListening = false;
    });
  }

  ////////////////////////////////////////////////////////////
  /// HANDLE BACK NAVIGATION
  ////////////////////////////////////////////////////////////
  Future<bool> _onWillPop() async {
    if (Navigator.canPop(context)) {
      return true; // normal pop
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      return false; // prevent default pop
    }
  }

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: _onWillPop,
          ),
          title: const Text(
            "AI Voice Assistant 🎧",
            style: TextStyle(
              fontFamily: 'Cinzel',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      double scale = 1 + 0.05 * _animationController.value;
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      onTap: _isListening ? _stopListening : _startListening,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor:
                            _isListening ? primaryPurple : Colors.white,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          size: 50,
                          color: _isListening ? Colors.white : primaryPurple,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (_isListening)
                    ElevatedButton(
                      onPressed: _stopListening,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        textStyle: const TextStyle(
                          fontFamily: 'Cinzel',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text("Stop Listening"),
                    ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          _spokenText,
                          style: const TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
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
