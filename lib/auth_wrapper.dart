import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/home_screen.dart';
import 'screens/signin_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 🔄 While checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // ❌ If error happens
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        // ✅ User logged in
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // 🔐 User NOT logged in
        return const SignInScreen();
      },
    );
  }
}
