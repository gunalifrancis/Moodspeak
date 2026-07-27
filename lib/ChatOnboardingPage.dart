import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatOnboardingPage extends StatelessWidget {
  const ChatOnboardingPage({super.key});

  /// ✅ Save onboarding done & navigate
  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstLaunch', false);
    Navigator.pushReplacementNamed(context, '/moodscreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                /// 🔹 Top Navigation (same everywhere)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Back
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/quiz');
                        },
                        child: const Text(
                          "back",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                      ),

                      /// Skip
                      GestureDetector(
                        onTap: () => _completeOnboarding(context),
                        child: const Text(
                          "skip",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔹 Main Content
                Column(
                  children: [
                    const Spacer(),

                    /// Image (same size everywhere)
                    SizedBox(
                      height: 260,
                      child: Image.asset(
                        "assets/images/ai_chat.png",
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Title
                    const Text(
                      "Chat With AI\nAnytime You Want",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3C3C3C),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// Description
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Have real conversations, improve vocabulary, and build confidence daily.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Indicator (same purple style)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Indicator(isActive: false),
                        Indicator(isActive: false),
                        Indicator(isActive: false),
                        Indicator(isActive: true),
                      ],
                    ),

                    const Spacer(),

                    /// 🔹 Bottom Button (same design)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 50),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFFF4FA3).withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFFF4FA3).withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _completeOnboarding(context),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF4FA3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Same indicator used across all screens
class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 28 : 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF9C6ADE) : Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
