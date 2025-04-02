// startcharge.dart
import 'package:flutter/material.dart';
import 'package:ev_/ChargingScreen.dart';

class StartCharge extends StatefulWidget {
  const StartCharge({super.key});

  @override
  State<StartCharge> createState() => _StartChargeState();
}

class _StartChargeState extends State<StartCharge> {
  String? selectedStation;
  String? selectedChargeType;

  final Map<String, Map<String, Map<String, dynamic>>> stationDetails = {
    "Station 1 - Zeon": {
      "Normal": {"rate": 0.2, "power": "AC - 3.3 kW"},
      "Fast": {"rate": 0.5, "power": "DC - 30 kW"},
      "Superfast": {"rate": 0.8, "power": "DC - 60 kW"}
    },
    "Station 2 - Evoke": {
      "Normal": {"rate": 0.3, "power": "AC - 3.3 kW"},
      "Fast": {"rate": 0.6, "power": "DC - 30 kW"},
      "Superfast": {"rate": 1.0, "power": "DC - 60 kW"}
    },
    "Station 3 - KSEB": {
      "Normal": {"rate": 0.25, "power": "AC - 3.3 kW"},
      "Fast": {"rate": 0.55, "power": "DC - 30 kW"},
      "Superfast": {"rate": 0.9, "power": "DC - 60 kW"}
    },
    "Station 4 - Revolte": {
      "Normal": {"rate": 0.28, "power": "AC - 3.3 kW"},
      "Fast": {"rate": 0.58, "power": "DC - 30 kW"},
      "Superfast": {"rate": 0.95, "power": "DC - 60 kW"}
    },
  };

  final List<String> stations = [
    "Station 1 - Zeon",
    "Station 2 - Evoke",
    "Station 3 - KSEB",
    "Station 4 - Revolte"
  ];

  void _confirmCharging() {
    if (selectedStation != null && selectedChargeType != null) {
      double rate =
          stationDetails[selectedStation]![selectedChargeType]!["rate"];
      String power =
          stationDetails[selectedStation]![selectedChargeType]!["power"];

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Confirm Charging"),
          content: Text(
            "Do you want to start charging at $selectedStation\n"
            "Power: $power\n"
            "Cost: ₹${rate.toStringAsFixed(2)}/sec",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startCharging();
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
              child: const Text("Start"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select both station and charge type!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startCharging() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Charging(
          station: selectedStation!,
          chargeType: selectedChargeType!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> chargeTypeItems = [];

    if (selectedStation != null) {
      Map<String, Map<String, dynamic>> rates =
          stationDetails[selectedStation] ?? {};
      chargeTypeItems = rates.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(
            "${entry.value["power"]} - ₹${entry.value["rate"].toStringAsFixed(2)}/sec",
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList();
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Start EV Charging",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 20),

                // Card Container
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Station Selection
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            labelText: "Select Charging Station",
                          ),
                          value: selectedStation,
                          items: stations.map((station) {
                            return DropdownMenuItem(
                                value: station, child: Text(station));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStation = value;
                              selectedChargeType = null; // Reset charge type
                            });
                          },
                        ),
                        const SizedBox(height: 15),

                        // Charging Type Selection
                        DropdownButtonFormField<String>(
                          isDense: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            labelText: "Select Charging Type",
                          ),
                          value: selectedChargeType,
                          items: chargeTypeItems.isNotEmpty
                              ? chargeTypeItems
                              : [
                                  DropdownMenuItem(
                                    value: null,
                                    child: Text("Select a station first"),
                                  )
                                ],
                          onChanged: selectedStation == null
                              ? null
                              : (value) {
                                  setState(() {
                                    selectedChargeType = value;
                                  });
                                },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Start Charging Button
                Center(
                  child: ElevatedButton(
                    onPressed: _confirmCharging,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[900],
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Start Charging",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
