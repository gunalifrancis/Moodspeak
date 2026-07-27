import 'package:flutter/material.dart';

class EmojiTile extends StatelessWidget {
  final String emoji;
  final String label;
  final double size;

  const EmojiTile({
    super.key,
    required this.emoji,
    required this.label,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 24, 23, 23).withOpacity(0.15),
            border: Border.all(
              color: const Color.fromARGB(255, 12, 11, 11).withOpacity(0.35),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            emoji,
            style: TextStyle(fontSize: size * 0.6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 12, 12, 12),
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
