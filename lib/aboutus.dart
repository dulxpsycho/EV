// aboutus.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAbt extends StatelessWidget {
  const AddAbt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Image or Icon
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/images/logo.png'), // Your logo image here
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Welcome to LightEV',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'We are committed to bringing a sustainable and innovative electric vehicle experience.',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Our Mission
            Text(
              'Our Mission:',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'To revolutionize the transportation industry by offering eco-friendly, efficient, and affordable electric vehicles.',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Our Vision
            Text(
              'Our Vision:',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'To create a greener and more sustainable world, driving the future of electric vehicles globally.',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            // Contact Information Section
            Text(
              'Contact Us:',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: info@lightev.com\nPhone: +1 (234) 567-8900\nAddress: 123 EV Lane, Green City, Earth',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            // Social Media Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.facebook,
                    color: Colors.blue.shade700,
                    size: 32,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.message,
                    color: Colors.blue.shade700,
                    size: 32,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.mail,
                    color: Colors.blue.shade700,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
