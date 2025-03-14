// components/List.dart
import 'package:flutter/material.dart';

class MyEv extends StatelessWidget {
  final Function()? onTap;

  const MyEv({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 217, 214, 214),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.add, color: Colors.red),
            SizedBox(width: 8), // Add some spacing
            Text('Add Vehicle', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
