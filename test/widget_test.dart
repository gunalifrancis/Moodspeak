import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:moodspeak/screens/home_screen.dart';

void main() {
  testWidgets('HomePage module cards exist', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Mood-Based English Learning'), findsOneWidget);

    final moduleTitles = [
      'Mood Selection',
      'Chat Learning',
      'AI Voice Interaction',
      'Voice & Grammar',
      'Grammar Practice',
      'Lesson Completion',
      'Progress & Challenges'
    ];

    for (var title in moduleTitles) {
      expect(find.text(title), findsOneWidget);
    }
  });
}
