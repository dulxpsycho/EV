// Home.dart
import 'dart:async';
import 'dart:typed_data';

import 'package:ev_/AddFav.dart';
import 'package:ev_/AddWall.dart';

import 'package:ev_/aboutus.dart';
import 'package:ev_/addEv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:location/location.dart';
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
    MapScreen(),
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
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Location _loactioncontroller = new Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng applePark = LatLng(37.3346, -122.0090);
  LatLng? _currentP = null;
  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text('Loading....'),
            )
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition: const CameraPosition(
                target: pGooglePlex,
                zoom: 13,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentP!,
                ),
                const Marker(
                  markerId: MarkerId("Sourcelocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: pGooglePlex,
                ),
                const Marker(
                  markerId: MarkerId("Destinationlocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: applePark,
                ),
              },
            ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _PermissionGranted;

    _serviceEnabled = await _loactioncontroller.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _loactioncontroller.requestService();
    } else {
      return;
    }
    _PermissionGranted = await _loactioncontroller.hasPermission();
    if (_PermissionGranted == PermissionStatus.denied) {
      _PermissionGranted = await _loactioncontroller.requestPermission();
      if (_PermissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _loactioncontroller.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _currentP =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            print(_currentP);
          });
        }
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const AddPart()),
    // );
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
              Color.fromARGB(255, 255, 255, 255)
            ], // Subtle red gradient for a minimal effect
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Minimal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Logo and Title
                Row(
                  children: [
                    const Icon(
                      Icons.electric_car,
                      color: Color.fromARGB(255, 252, 0, 0),
                      size: 30, // Smaller icon for minimal style
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Light EV',
                      style: GoogleFonts.roboto(
                        color: const Color.fromARGB(
                            255, 255, 0, 0), // White text for clarity
                        fontSize: 32,
                        fontWeight: FontWeight.w600, // Minimal font weight
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 255, 255, 255), // Subtle divider
                ),
                const SizedBox(height: 30), // Minimal spacing

                // Wallet Item
                Userlist(
                  icon: Icons.wallet,
                  title: 'Wallet',
                  onTap: () {
                    addwallet(context);
                  },
                ),
                const SizedBox(height: 15),

                // Favorites Item
                Userlist(
                  icon: Icons.favorite,
                  title: 'Favorites',
                  onTap: () {
                    addFav(context);
                  },
                ),
                const SizedBox(height: 15),

                // Partner Item
                Userlist(
                  icon: Icons.handshake,
                  title: 'Become a Partner',
                  onTap: () {
                    addpart(context);
                  },
                ),
                const SizedBox(height: 15),

                // About Us Item
                Userlist(
                  icon: Icons.info,
                  title: 'About Us',
                  onTap: () {
                    addabt(context);
                  },
                ),
                const SizedBox(height: 15),

                // Log Out Item
                Userlist(
                  icon: Icons.exit_to_app,
                  title: 'Log Out',
                  onTap: () {
                    addcar(context);
                  },
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

  const Userlist(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 16), // Tight padding
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 202, 199, 199)
              .withOpacity(0.1), // Subtle transparent background
          borderRadius: BorderRadius.circular(12), // Slightly rounded corners
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
              blurRadius: 5, // Minimal shadow
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(
                  255, 249, 1, 1), // White icon for contrast
              size: 24, // Smaller icon size for minimal look
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: const Color.fromARGB(255, 255, 1, 1), // Clean white text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
