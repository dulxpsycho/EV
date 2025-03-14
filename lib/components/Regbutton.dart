// components/Regbutton.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegButton extends StatelessWidget {
  final Function()? onTap;
  const RegButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 28, 166, 240),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Sign Up',
            style: GoogleFonts.nunito(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
