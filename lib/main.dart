// main.dart

import 'package:ev_/Home.dart';
import 'package:ev_/flash.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'Login',
      home: const MyFlash(),
      routes: {
        'Login': (context) => const MyFlash(),
        'Home': (context) => const MyHome(),
      },
    );
  }
}
