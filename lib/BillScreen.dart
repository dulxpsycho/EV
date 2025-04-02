// BillScreen.dart
import 'package:ev_/Home.dart';
import 'package:ev_/core/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillScreen extends StatefulWidget {
  final String station;
  final String chargeType;
  final int chargingTime;

  const BillScreen({
    super.key,
    required this.station,
    required this.chargeType,
    required this.chargingTime,
  });

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();
  }

  Future<void> _loadLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLiked = prefs.getBool(widget.station) ?? false;
    });
  }

  Future<void> _toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLiked = !isLiked;
      prefs.setBool(widget.station, isLiked);
    });

    // Add or Remove from Favorite Stations List
    List<String> favorites = prefs.getStringList('favoriteStations') ?? [];
    if (isLiked) {
      if (!favorites.contains(widget.station)) {
        favorites.add(widget.station);
      }
    } else {
      favorites.remove(widget.station);
    }
    await prefs.setStringList('favoriteStations', favorites);
  }

  double _calculateCost() {
    // Define station-wise reduced cost rates
    Map<String, Map<String, double>> stationRates = {
      "Station A": {
        "Normal": 0.2,
        "Fast": 0.5,
        "Super Fast": 0.8
      }, // ₹ per second
      "Station B": {"Normal": 0.3, "Fast": 0.6, "Super Fast": 1.0},
      "Station C": {"Normal": 0.25, "Fast": 0.55, "Super Fast": 0.9},
    };

    // Default cost per second if station not found
    double costPerSecond = 0.3; // ₹0.3 as default

    // Check if the station exists and has specific rates
    if (stationRates.containsKey(widget.station) &&
        stationRates[widget.station]!.containsKey(widget.chargeType)) {
      costPerSecond = stationRates[widget.station]![widget.chargeType]!;
    }

    double totalCost = widget.chargingTime * costPerSecond * 83; // Convert to ₹
    return totalCost;
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = _calculateCost();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Charging Bill"),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.receipt_long,
                  size: 50,
                  color: Colors.green,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Charging Summary",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _billItem("Charging Station", widget.station),
                _billItem("Charging Type", widget.chargeType),
                _billItem(
                    "Charging Duration", "${widget.chargingTime} seconds"),
                _billItem("Total Cost",
                    "₹${totalCost.toStringAsFixed(2)}"), // Updated to show in Rupees
                const SizedBox(height: 20),

                // Like Button
                IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey<bool>(isLiked),
                      color: isLiked ? Colors.red : Colors.grey,
                      size: 30,
                    ),
                  ),
                  onPressed: _toggleLike,
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    NavigationHandler.navigateTo(context, const MyHome());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Finish",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _billItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
