// nearstation.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Nearstation extends StatefulWidget {
  const Nearstation({super.key});

  @override
  State<Nearstation> createState() => _NearstationState();
}

class _NearstationState extends State<Nearstation> {
  List<dynamic> stations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChargingStations();
  }

  Future<void> _fetchChargingStations() async {
    Position position = await _determinePosition();
    double latitude = position.latitude;
    double longitude = position.longitude;

    String apiKey =
        'AIzaSyBA8i9tL9iEuwntDKd0jTHGM8kMKfE4Ltg'; // Replace with your API key
    String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$latitude,$longitude'
        '&radius=20000' // 20 km radius
        '&keyword=electric+vehicle+charging+station' // Ensures only EV stations
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        stations = json.decode(response.body)['results'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load charging stations');
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby EV Charging Stations')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: stations.length,
              itemBuilder: (context, index) {
                var station = stations[index];
                return ListTile(
                  leading: const Icon(Icons.ev_station, color: Colors.green),
                  title: Text(station['name']),
                  subtitle: Text(station['vicinity']),
                );
              },
            ),
    );
  }
}
