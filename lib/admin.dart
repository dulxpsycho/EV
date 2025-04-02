// admin.dart
import 'package:ev_/adminfeedback.dart';
import 'package:ev_/useranalytics.dart';
import 'package:flutter/material.dart';
import 'package:ev_/addstations.dart';
import 'package:ev_/core/core/routes/routes.dart';

class EVChargingAdminPanel extends StatefulWidget {
  const EVChargingAdminPanel({super.key});

  @override
  State<EVChargingAdminPanel> createState() => _EVChargingAdminPanelState();
}

class _EVChargingAdminPanelState extends State<EVChargingAdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 166, 238, 170)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Admin Menu',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.charging_station),
              title: const Text('Charging Stations'),
              onTap: () {
                _navigateToSection(context, 'Charging Stations');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('User Management'),
              onTap: () {
                _navigateToSection(context, 'User Management');
              },
            ),
            ListTile(
              leading: const Icon(Icons.electric_bolt),
              title: const Text('Charging Sessions'),
              onTap: () {
                _navigateToSection(context, 'Charging Sessions');
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Reports'),
              onTap: () {
                _navigateToSection(context, 'Reports');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                _navigateToSection(context, 'Settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Implement logout functionality
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildAdminCard(context, 'Add Stations', Icons.charging_station,
                Colors.green[600]!),
            _buildAdminCard(
                context, 'User Analytics', Icons.analytics, Colors.blue[600]!),
            _buildAdminCard(
                context, 'Billing', Icons.payment, Colors.orange[600]!),
            _buildAdminCard(
                context, 'Feedbacks', Icons.support_agent, Colors.purple[600]!),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
      BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _navigateToSection(context, title);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSection(BuildContext context, String section) {
    switch (section) {
      case 'Add Stations':
        NavigationHandler.navigateTo(context, const AddStations());
        break;
      case 'User Analytics':
        // Replace with the actual page when created
        NavigationHandler.navigateTo(context, const Useranalytics());
        break;
      case 'Billing':
        // Replace with the actual page when created
        print('Navigate to Billing Page');
        break;
      case 'Feedbacks':
        // Replace with the actual page when created
        NavigationHandler.navigateTo(context, const AdminFeedback());
        break;
      case 'Settings':
        // Replace with the actual page when created
        print('Navigate to Settings Page');
        break;
      default:
        print('Unknown section: $section');
    }
  }
}
