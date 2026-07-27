import 'package:flutter/material.dart';
import '../widgets/emoji_tile.dart';
import 'signin_screen.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  final double emojiSize = 60;

  final List<Map<String, String>> emojis = const [
    {"emoji": "😊", "label": "Happy"},
    {"emoji": "😌", "label": "Relaxed"},
    {"emoji": "😢", "label": "Sad"},
    {"emoji": "😡", "label": "Angry"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset('assets/bg.png', fit: BoxFit.cover),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    "ChatterMood",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  const Text(
                    "Learn English according to your mood",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 16,
                      color: Colors.black87,
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Girl image
                  Flexible(
                    flex: 3,
                    child: Image.asset(
                      'assets/girl.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Emojis
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: emojis.map((e) {
                        return EmojiTile(
                          emoji: e["emoji"]!,
                          label: e["label"]!,
                          size: emojiSize,
                        );
                      }).toList(),
                    ),
                  ),

                  const Spacer(),

                  // START button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C6ADE),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignInScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "START",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
