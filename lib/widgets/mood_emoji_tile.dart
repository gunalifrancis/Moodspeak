import 'package:flutter/material.dart';

class MoodEmojiTile extends StatelessWidget {
  final String image; // ✅ changed from emoji
  final String label;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const MoodEmojiTile({
    super.key,
    required this.image, // ✅ required image
    required this.label,
    required this.color,
    required this.onTap,
    this.size = 80, // default size
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
              color: color.withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
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
