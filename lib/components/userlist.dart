// components/userlist.dart
import 'package:flutter/material.dart';

class Userlist extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const Userlist({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: const Color.fromARGB(255, 255, 17, 0),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
