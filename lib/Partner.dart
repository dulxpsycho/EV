// Partner.dart
import 'package:flutter/material.dart';

class PartnerWithUs extends StatelessWidget {
  const PartnerWithUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner With Us'),
        backgroundColor: const Color.fromARGB(
            255, 239, 241, 241), // More appealing color for the app bar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Become a Partner with Us!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 0, 0),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We are looking for passionate individuals and organizations to partner with us and make a bigger impact. If you are interested in collaborating with us, please fill out the form or get in touch using the contact information below.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5, // Added line spacing for better readability
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Contact us:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Email: lightevLtd@ourcompany.com',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                'Phone: 6465666769',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add your button functionality here, such as navigating to a form or contact page.
                    // For example:
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => PartnershipForm()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255,
                        255), // Corrected property name for background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12), // Better button size
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Contact Us'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
