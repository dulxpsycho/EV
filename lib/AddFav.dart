// AddFav.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFav extends StatefulWidget {
  const AddFav({super.key});

  @override
  _AddFavState createState() => _AddFavState();
}

class _AddFavState extends State<AddFav> {
  final TextEditingController _stationController = TextEditingController();
  List<String> _favoriteStations = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteStations = prefs.getStringList('favoriteStations') ?? [];
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteStations', _favoriteStations);
  }

  void _toggleFavorite(String station) {
    if (station.isNotEmpty) {
      setState(() {
        if (_favoriteStations.contains(station)) {
          _favoriteStations.remove(station);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("'$station' removed from favorites!"),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else {
          _favoriteStations.add(station);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("'$station' added to favorites!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
      _saveFavorites();
    }
  }

  void _deleteStation(String station) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Favorite?"),
        content: Text("Are you sure you want to remove '$station'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _favoriteStations.remove(station);
              });
              _saveFavorites();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[700],
        title: const Text(
          'Favorite Stations',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _stationController,
                decoration: InputDecoration(
                  hintText: 'Enter station name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.ev_station, color: Colors.green),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      _toggleFavorite(_stationController.text);
                      _stationController.clear();
                    },
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Favorite List
            Expanded(
              child: _favoriteStations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No favorite stations yet',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _favoriteStations.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(_favoriteStations[index]),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteStation(_favoriteStations[index]);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                _favoriteStations[index],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _deleteStation(_favoriteStations[index]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
