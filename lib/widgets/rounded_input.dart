import 'package:flutter/material.dart';

class RoundedInput extends StatelessWidget {
  final IconData icon;            // Icon to show inside the input
  final String hint;              // Hint text
  final bool obscure;             // For passwords
  final TextEditingController? controller; // Optional controller
  final Function(String)? onChanged;      // Optional callback
  final Color iconColor;
  final Color fillColor;
  final Color hintColor;

  const RoundedInput({
    super.key,
    required this.icon,
    required this.hint,
    this.obscure = false,
    this.controller,
    this.onChanged,
    this.iconColor = Colors.deepPurple,
    this.fillColor = Colors.white,
    this.hintColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: iconColor),
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
