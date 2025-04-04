// components/button.dart
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;

  const MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
