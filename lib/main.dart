// main.dart
import 'package:ev_/Login.dart';
import 'package:ev_/flash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        'Home': (context) => const LoginPage(),
      },
    );
  }
}
