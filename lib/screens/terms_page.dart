import 'dart:ui';
import 'package:flutter/material.dart';
import 'signup_screen.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          "Terms & Conditions",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Glass Card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              // Scrollable Terms
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Terms and Conditions",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "1. Acceptance of Terms\n"
                                        "By using this app, you agree to comply with these terms. If you do not agree, please stop using the app.\n\n"
                                        "2. Purpose of the App\n"
                                        "This application is built for educational purposes to improve English skills through mood-based learning, AI chat, and AI voice interaction.\n\n"
                                        "3. User Responsibilities\n"
                                        "- Provide accurate registration details.\n"
                                        "- Use the platform respectfully.\n"
                                        "- Do not misuse AI features.\n\n"
                                        "4. Privacy & Data\n"
                                        "Basic user information such as name and email may be stored for personalization. Data is not sold to third parties.\n\n"
                                        "5. Intellectual Property\n"
                                        "All UI, design, content, and code belong to the developer. Unauthorized copying or redistribution is prohibited.\n\n"
                                        "6. Limitation of Liability\n"
                                        "The app is provided as-is without guarantees. The developer is not responsible for losses caused by usage.\n\n"
                                        "7. Third-Party Services\n"
                                        "The app uses external AI services. Any downtime or errors from those services are outside developer responsibility.\n\n"
                                        "8. Termination\n"
                                        "Access may be restricted if users violate these terms.\n\n"
                                        "9. Governing Law\n"
                                        "These terms follow the applicable laws of the operating country.\n\n"
                                        "10. Updates to Terms\n"
                                        "Terms may change at any time. Continued use means acceptance of updates.",
                                        style: TextStyle(
                                          fontSize: 16,
                                          height: 1.6,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Agree Button
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SignUpScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF9C6ADE),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    "Agree & Continue",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
