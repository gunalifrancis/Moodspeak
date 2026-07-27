import 'package:flutter/material.dart';

class MoodEmojiTile extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const MoodEmojiTile({
    super.key,
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
    this.size = 80, // make it default bigger
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.3), // circle background color
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: size * 0.6, // emoji fits nicely inside
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.25,
            ),
          ),
        ],
      ),
    );
  }
}
