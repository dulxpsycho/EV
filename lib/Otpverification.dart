// Otpverification.dart
import 'package:ev_/Home.dart';
import 'package:flutter/material.dart';

class MyOtp extends StatelessWidget {
  const MyOtp({super.key});

  void verifieduserin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHome()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Controllers for OTP fields
    final otpControllers = List.generate(4, (index) => TextEditingController());
    final focusNodes = List.generate(4, (index) => FocusNode());

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Add spacing at the top
            const Text(
              'Enter the 4-digit code sent to your phone',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40), // Spacing between text and input
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => _otpTextField(
                    context,
                    otpControllers[index],
                    focusNodes[index],
                    index < 3 ? focusNodes[index + 1] : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40), // Spacing between inputs and button
            ElevatedButton(
              onPressed: () {
                String otp = otpControllers.map((e) => e.text).join();
                if (otp.length == 4) {
                  verifieduserin(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid OTP')),
                  );
                }
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpTextField(BuildContext context, TextEditingController controller,
      FocusNode focusNode, FocusNode? nextFocusNode) {
    return SizedBox(
      height: 68,
      width: 64,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        keyboardType: TextInputType.number,
        maxLength: 1, // Limit to a single character
        decoration: InputDecoration(
          counterText: '', // Hide the character counter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else if (value.isEmpty) {
            focusNode.previousFocus(); // Move back to the previous field
          }
        },
      ),
    );
  }
}
