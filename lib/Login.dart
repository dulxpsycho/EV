// Login.dart
import 'dart:ui';
import 'package:ev_/Home.dart';
import 'package:ev_/admin.dart';
import 'package:ev_/core/helper/shared_preference.dart';
import 'package:ev_/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim(),
        );

        if (!mounted) return;

        String userId = userCredential.user?.uid ?? '';

        // ✅ Save login state and UID
        await SharedPreference.setLoggedIn(true);
        await SharedPreference.saveUID(userId);

        // ✅ Update last login timestamp in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'lastLogin': FieldValue.serverTimestamp(),
        });

        // ✅ Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ Navigate to Home after delay
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHome()),
            );
          }
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_parseFirebaseError(e)),
            backgroundColor: Colors.redAccent,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  String _parseFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-disabled':
        return 'Account disabled';
      case 'user-not-found':
        return 'No user found';
      case 'wrong-password':
        return 'Incorrect password';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'LIGHT EV',
                              style: GoogleFonts.tektur(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.flash_on_outlined,
                                size: 70, color: Colors.white),
                          ],
                        ),
                        const SizedBox(height: 60),

                        // Login Form Card
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(38, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: const Color.fromARGB(64, 255, 255, 255),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter email';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Invalid email format';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      prefixIcon: const Icon(Icons.mail,
                                          color: Colors.white70),
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          51, 255, 255, 255),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintStyle: GoogleFonts.poppins(
                                          color: Colors.white70),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 20),

                                  TextFormField(
                                    controller: passController,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      if (value.length < 6) {
                                        return 'Minimum 6 characters required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      prefixIcon: const Icon(Icons.lock,
                                          color: Colors.white70),
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          51, 255, 255, 255),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintStyle: GoogleFonts.poppins(
                                          color: Colors.white70),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 30),

                                  // Sign In Button
                                  GestureDetector(
                                    onTap: _isLoading ? null : _login,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFD32F2F),
                                            Color(0xFFB71C1C)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 253, 1, 1)
                                                .withOpacity(0.4),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          )
                                        ],
                                      ),
                                      child: _isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white)
                                          : Text(
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
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()),
                          ),
                          child: const Text("Don't have an account? Sign Up",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ✅ Admin Icon Button
          Positioned(
            top: 35,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EVChargingAdminPanel()),
              ),
              child: const Icon(Icons.admin_panel_settings,
                  size: 30, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
