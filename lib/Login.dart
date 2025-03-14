// Login.dart
import 'dart:ui'; // Required for BackdropFilter
import 'package:ev_/Otpverification.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Navigate to OTP page
  void signUserIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyOtp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)], // Red gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Logo Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LIGHT EV',
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white, // White text for logo
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.electric_car_rounded,
                        size: 40,
                        color: Colors.white, // White icon
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Glassmorphism Card
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          38, 255, 255, 255), // Semi-transparent white
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color.fromARGB(
                            64, 255, 255, 255), // Light border
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Column(
                          children: [
                            // Username Field
                            TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.white70),
                                filled: true,
                                fillColor: const Color.fromARGB(
                                    51, 255, 255, 255), // Transparent white
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle:
                                    GoogleFonts.poppins(color: Colors.white70),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),

                            // Phone Number Field
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                prefixIcon: const Icon(Icons.phone,
                                    color: Colors.white70),
                                filled: true,
                                fillColor: const Color.fromARGB(
                                    51, 255, 255, 255), // Transparent white
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle:
                                    GoogleFonts.poppins(color: Colors.white70),
                              ),
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 30),

                            // Sign In Button
                            GestureDetector(
                              onTap: () => signUserIn(context),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                alignment: Alignment.center,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFD32F2F),
                                      Color(0xFFB71C1C)
                                    ], // Red gradient
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color.fromARGB(255, 253, 1, 1)
                                              .withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Footer Section
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
