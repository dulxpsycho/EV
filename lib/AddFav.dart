// AddFav.dart
import 'package:flutter/material.dart';

class AddFav extends StatefulWidget {
  const AddFav({super.key});

  @override
  _AddFavState createState() => _AddFavState();
}

class _AddFavState extends State<AddFav> {
  final TextEditingController _stationController = TextEditingController();
  final List<String> _favoriteStations = [];

  void _toggleFavorite() {
    if (_stationController.text.isNotEmpty) {
      setState(() {
        if (_favoriteStations.contains(_stationController.text)) {
          _favoriteStations.remove(_stationController.text);
        } else {
          _favoriteStations.add(_stationController.text);
        }
        _stationController.clear();
      });
    }
  }

  void _deleteStation(String station) {
    setState(() {
      _favoriteStations.remove(station);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Favorite Stations',
          style: TextStyle(
            color: Colors.black87,
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
                  prefixIcon: const Icon(Icons.ev_station,
                      color: Color.fromARGB(255, 255, 0, 0)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add,
                        color: Color.fromARGB(255, 255, 0, 0)),
                    onPressed: _toggleFavorite,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
