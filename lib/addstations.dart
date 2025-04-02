// addstations.dart
import 'package:flutter/material.dart';

class AddStations extends StatefulWidget {
  const AddStations({super.key});

  @override
  State<AddStations> createState() => _AddStationsState();
}

class _AddStationsState extends State<AddStations> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  final TextEditingController connectorsController = TextEditingController();

  void submitStation() {
    String name = nameController.text;
    String location = locationController.text;
    String power = powerController.text;
    String connectors = connectorsController.text;

    if (name.isNotEmpty &&
        location.isNotEmpty &&
        power.isNotEmpty &&
        connectors.isNotEmpty) {
      // Handle station submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Charging Station Added Successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add EV Charging Station",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Station Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: powerController,
                decoration: const InputDecoration(
                  labelText: "Power Capacity (kW)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: connectorsController,
                decoration: const InputDecoration(
                  labelText: "Available Connectors",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitStation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text("Submit Station"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
