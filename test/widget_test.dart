import 'package:flutter_test/flutter_test.dart';
import 'package:moodspeak/main.dart';

void main() {
  testWidgets('HomePage module cards exist', (tester) async {
    await tester.pumpWidget(const MoodEnglishApp());

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

    // Tap first module
    await tester.tap(find.text('Mood Selection'));
    await tester.pumpAndSettle();

    expect(find.text('You selected:'), findsNothing); // Mood page starts empty
  });
}
