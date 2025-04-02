// ChargingScreen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ev_/BillScreen.dart'; // Import Bill Screen

class Charging extends StatefulWidget {
  final String station;
  final String chargeType;

  const Charging({super.key, required this.station, required this.chargeType});

  @override
  State<Charging> createState() => _ChargingScreenState();
}

class _ChargingScreenState extends State<Charging> {
  int chargePercentage = 0;
  int secondsElapsed = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _startChargingSimulation();
  }

  void _startChargingSimulation() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (chargePercentage < 100) {
        setState(() {
          chargePercentage += 2;
          secondsElapsed++; // Track total charging time
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _stopCharging() {
    timer.cancel(); // Stop charging
    _navigateToBillScreen(); // Navigate to Bill Screen
  }

  void _navigateToBillScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BillScreen(
          station: widget.station,
          chargeType: widget.chargeType,
          chargingTime: secondsElapsed,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Charging Your EV...",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Icon(
                Icons.battery_charging_full,
                size: 80,
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: chargePercentage / 100,
                      strokeWidth: 8,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                  Text(
                    "$chargePercentage%",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color:
                      chargePercentage == 100 ? Colors.green : Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  chargePercentage == 100 ? "Charging Complete" : "Charging...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color:
                        chargePercentage == 100 ? Colors.black : Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Stop Charging Button
              ElevatedButton(
                onPressed:
                    _stopCharging, // Stops charging and goes to Bill Screen
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Stop Charging",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
