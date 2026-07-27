import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'ChatOnboardingPage.dart';
import 'Quiz_Onboarding.dart';
import 'ai_voice_onboarding_page.dart';
import 'mood_onboarding.dart';

import 'screens/mood_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final firstLaunch = prefs.getBool('firstLaunch') ?? true;

  // Detect Firebase Auth action links
  final queryParams = Uri.base.queryParameters;
  String initialRoute;
  String? oobCode;

  if (queryParams['mode'] == 'resetPassword' &&
      queryParams['oobCode'] != null) {
    // 🔥 Reset password link clicked → go to ResetPasswordScreen
    initialRoute = '/resetPassword';
    oobCode = queryParams['oobCode'];
  } else if (firstLaunch) {
    // First app launch → show onboarding
    initialRoute = '/mood';
  } else {
    // Normal app launch → show main mood screen
    initialRoute = '/moodscreen';
  }

  runApp(MoodEnglishApp(
    initialRoute: initialRoute,
    oobCode: oobCode,
  ));
}

class MoodEnglishApp extends StatelessWidget {
  final String initialRoute;
  final String? oobCode;

  const MoodEnglishApp({super.key, required this.initialRoute, this.oobCode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatterMood',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: initialRoute,
      routes: {
        '/mood': (context) => const MoodOnboardingScreen(),
        '/moodscreen': (context) => const MoodScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/ai': (context) => const AIVoiceOnboardingPage(),
        '/chat': (context) => const ChatOnboardingPage(),
        '/quiz': (context) => const QuizOnboardingPage(),
        '/resetPassword': (context) => ResetPasswordScreen(oobCode: oobCode),
      },
    );
  }
}
