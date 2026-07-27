import 'package:flutter/material.dart';

class AIVoiceOnboardingPage extends StatelessWidget {
  const AIVoiceOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                /// Top Navigation (Back & Skip) ✅ same as quiz
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Back
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/mood');
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
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/quiz');
                        },
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

                /// Main Content
                Column(
                  children: [
                    const Spacer(),

                    /// Image ✅ exact same size
                    SizedBox(
                      height: 260,
                      child: Image.asset(
                        "assets/images/ai_voice.png",
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Title (single clean title)
                    const Text(
                      "Speak English\nWith AI Voice",
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
                        "Practice real conversations with smart AI voice and improve your fluency faster.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Page Indicator ✅ same animated style
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Indicator(isActive: false),
                        Indicator(isActive: true),
                        Indicator(isActive: false),
                      ],
                    ),

                    const Spacer(),

                    /// Bottom Navigation
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 50),

                          /// Floating Next Button ✅ identical
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
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/quiz');
                                },
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

/// Same Indicator used everywhere
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
