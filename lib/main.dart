// main.dart

import 'package:ev_/Home.dart';
import 'package:ev_/Login.dart';

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
      home: LoginPage(),
      routes: {
        'Login': (context) => LoginPage(),
        'Home': (context) => const MyHome(),
      },
    );
  }
}
