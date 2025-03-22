// charging_station_details_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChargingStationDetailsScreen extends StatelessWidget {
  final String name;
  final String address;
  final double? rating;
  final LatLng location;

  const ChargingStationDetailsScreen({
    super.key,
    required this.name,
    required this.address,
    this.rating,
    required this.location,
  });

  void _openGoogleMaps() {
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}";
    launchUrl(Uri.parse(googleMapsUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Charging Station Details"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.ev_station, color: Colors.green, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(address,
                style: const TextStyle(fontSize: 18, color: Colors.black87)),
            if (rating != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                  const SizedBox(width: 5),
                  Text('$rating / 5', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _openGoogleMaps,
                icon: const Icon(Icons.directions, color: Colors.white),
                label: const Text("Get Directions",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
