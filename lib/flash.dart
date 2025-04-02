// flash.dart
import 'package:ev_/Home.dart';
import 'package:ev_/Login.dart';
import 'package:ev_/core/helper/shared_preference.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MyFlash extends StatefulWidget {
  const MyFlash({super.key});

  @override
  State<MyFlash> createState() => _MyFlashState();
}

class _MyFlashState extends State<MyFlash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller (Lightning Flash Speed)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Quick flashing effect
    )..repeat(reverse: true); // Makes it flicker

    // Color animation for flashing effect (White -> Red -> White)
    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.red,
    ).animate(_controller);

    // Opacity animation for flickering
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 50),
    ]).animate(_controller);

    // Navigate after 3 seconds
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Wait for 3 seconds
    final bool isLoggedIn = await SharedPreference.getLoggedIn() ?? false;

    if (!mounted) return; // Ensure widget is still active

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? const MyHome() : const LoginPage(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.red, // Red background for the logo
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.flash_on,
                    size: 80,
                    color: _colorAnimation.value, // Flashing effect
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: const Text(
                    "LIGHT EV",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
