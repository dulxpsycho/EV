// Home.dart
import 'dart:async';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
import 'package:ev_/AddFav.dart';
import 'package:ev_/AddWall.dart';
import 'package:ev_/Login.dart';
import 'package:ev_/Partner.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:ev_/aboutus.dart';
import 'package:ev_/addEv.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    const MapScreen(),
    const MyEvScreen(),
    const MyQr(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            gap: 6,
            padding: const EdgeInsets.all(10),
            backgroundColor: Colors.black,
            activeColor: const Color.fromARGB(255, 255, 0, 0),
            color: const Color.fromARGB(255, 255, 255, 255),
            tabBackgroundColor: const Color.fromARGB(255, 30, 30, 30),
            tabs: const [
              GButton(
                icon: Icons.map,
                text: 'Maps',
              ),
              GButton(
                icon: Icons.car_rental,
                text: 'My Ev',
              ),
              GButton(
                icon: Icons.qr_code,
                text: 'Scan',
              ),
              GButton(
                icon: Icons.list_rounded,
                text: 'User',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index; // Update selected index
              });
            },
          ),
        ),
      ),
    );
  }
}

// Screen 1: MapScreen

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();

  LatLng? _currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: Text('Loading....'))
              : GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 13,
                  ),
                  markers: _markers,
                ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search location...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 470,
            right: 20,
            child: FloatingActionButton(
              tooltip: 'Recenter Map',
              onPressed: () {
                _moveCameraToCurrentLocation();
              },
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              child: const Icon(Icons.my_location,
                  color: Color.fromARGB(255, 255, 0, 0)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted =
        await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });

        _moveCameraToCurrentLocation();
        _fetchChargingStations();
      }
    });
  }

  Future<void> _moveCameraToCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    if (_currentPosition != null) {
      controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
    }
  }

  Future<void> _fetchChargingStations() async {
    if (_currentPosition == null) return;

    String apiKey =
        'AIzaSyBA8i9tL9iEuwntDKd0jTHGM8kMKfE4Ltg'; // Replace with your API key
    String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${_currentPosition!.latitude},${_currentPosition!.longitude}'
        '&radius=20000' // 20 km radius
        '&keyword=electric+vehicle+charging+station'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> stations = json.decode(response.body)['results'];
      Set<Marker> newMarkers = {
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: _currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: "Your Location"),
        ),
      };

      for (var station in stations) {
        double lat = station['geometry']['location']['lat'];
        double lng = station['geometry']['location']['lng'];
        String name = station['name'];
        String address = station['vicinity'];
        double? rating =
            station['rating']?.toDouble(); // Get rating if available

        newMarkers.add(
          Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(
              title: name,
              snippet: address,
              onTap: () {
                _showChargingStationDialog(name, address,
                    rating: rating, location: LatLng(lat, lng));
              },
            ),
          ),
        );
      }

      setState(() {
        _markers = newMarkers;
      });
    } else {
      throw Exception('Failed to load charging stations');
    }
  }

  void _showChargingStationDialog(String name, String address,
      {double? rating, LatLng? location}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              const Icon(Icons.ev_station, color: Colors.green),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(address, style: const TextStyle(fontSize: 16)),
              if (rating != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text('$rating / 5', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
              if (location != null) ...[
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () {
                    String googleMapsUrl =
                        "https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}";
                    launchUrl(Uri.parse(googleMapsUrl));
                  },
                  icon: const Icon(Icons.directions, color: Colors.white),
                  label: const Text("Get Directions",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

// Screen 2: MyEvScreen

class MyEvScreen extends StatefulWidget {
  const MyEvScreen({super.key});

  @override
  State<MyEvScreen> createState() => _MyEvScreenState();
}

class _MyEvScreenState extends State<MyEvScreen> {
  final List<Vehicle> vehicles = []; // List to store added vehicles

  // Method to navigate to AddEv screen and handle returned vehicle
  void addCar(BuildContext context) async {
    final Vehicle? newVehicle = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEv()),
    );
    if (newVehicle != null) {
      setState(() {
        vehicles.add(newVehicle); // Add the new vehicle to the list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My EVs')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Vehicles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 1, color: Colors.grey),
              Expanded(
                child: vehicles.isEmpty
                    ? const Center(child: Text('No vehicles added yet.'))
                    : ListView.builder(
                        itemCount: vehicles.length,
                        itemBuilder: (context, index) {
                          final vehicle = vehicles[index];
                          return ListTile(
                            leading: const Icon(Icons.directions_car),
                            title: Text('${vehicle.name} ${vehicle.model}'),
                            subtitle:
                                Text('Reg. No: ${vehicle.registrationNumber}'),
                          );
                        },
                      ),
              ),
              const Divider(thickness: 1, color: Colors.grey),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => addCar(context), // Navigate to AddEv screen
                  child: const Text('Add New Vehicle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen 3: ScanScreen

class MyQr extends StatefulWidget {
  const MyQr({super.key});

  @override
  State<MyQr> createState() => _MyQrState();
}

class _MyQrState extends State<MyQr> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 20), // Spacer
            const Text(
              "Scan QR Code",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Container(
                  width: 300, // Set the width of the scanner
                  height: 300, // Set the height of the scanner
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 0, 0), width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: MobileScanner(
                      controller: MobileScannerController(
                        returnImage: true,
                        detectionSpeed: DetectionSpeed.noDuplicates,
                      ),
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        final Uint8List? image = capture.image;

                        if (barcodes.isNotEmpty) {
                          _showBarcodeDialog(context, barcodes, image);
                        } else {
                          print("No barcodes detected.");
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacer
            const Text(
              "Align the QR code within the box to scan.",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 134, 133, 133),
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Action for a button (optional)
                },
                child: const Text("Learn More"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBarcodeDialog(
      BuildContext context, List<Barcode> barcodes, Uint8List? image) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Detected Barcodes",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...barcodes.map(
                  (barcode) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.qr_code, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            barcode.rawValue ?? "Unknown",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(image: MemoryImage(image)),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

// Screen 4: User Screen
// Make sure to add this dependency in pubspec.yaml

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  // Navigation functions
  void addcar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEv()),
    );
  }

  void addwallet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWall()),
    );
  }

  void addFav(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddFav()),
    );
  }

  void addpart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PartnerWithUs()),
    );
  }

  void addabt(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAbt()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 251, 251, 251),
              Color.fromARGB(255, 255, 255, 255),
            ], // Subtle gradient for a minimal effect
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Logo and Title
                Row(
                  children: [
                    const Icon(
                      Icons.electric_car,
                      color: Color.fromARGB(255, 252, 0, 0),
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Light EV',
                      style: GoogleFonts.roboto(
                        color: const Color.fromARGB(255, 255, 0, 0),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                const SizedBox(height: 30),

                // Wallet Item
                Userlist(
                  icon: Icons.wallet,
                  title: 'Wallet',
                  onTap: () => addwallet(context),
                ),
                const SizedBox(height: 15),

                // Favorites Item
                Userlist(
                  icon: Icons.favorite,
                  title: 'Favorites',
                  onTap: () => addFav(context),
                ),
                const SizedBox(height: 15),

                // Partner Item
                Userlist(
                  icon: Icons.handshake,
                  title: 'Become a Partner',
                  onTap: () => addpart(context),
                ),
                const SizedBox(height: 15),

                // About Us Item
                Userlist(
                  icon: Icons.info,
                  title: 'About Us',
                  onTap: () => addabt(context),
                ),
                const SizedBox(height: 15),

                // Log Out Item
                Userlist(
                  icon: Icons.exit_to_app,
                  title: 'Log Out',
                  onTap: () => LoginPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Userlist extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const Userlist({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 202, 199, 199).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 249, 1, 1),
              size: 28, // Slightly bigger icon for better visibility
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: const Color.fromARGB(
                    255, 255, 1, 1), // Text color for visibility
                fontWeight: FontWeight.w500, // Slightly bold font for contrast
              ),
            ),
          ],
        ),
      ),
    );
  }
}
