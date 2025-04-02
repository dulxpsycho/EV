// useranalytics.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class Useranalytics extends StatelessWidget {
  const Useranalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Analytics'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No user data available'));
            }

            var userList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                var userData = userList[index];

                // ✅ Fetch user data safely
                var userId = userData.id;
                var userName = userData.data().toString().contains('name')
                    ? userData['name']
                    : 'No Name';
                var userEmail = userData.data().toString().contains('email')
                    ? userData['email']
                    : 'No Email';

                // ✅ Handle login timestamp (if available)
                var timestamp = userData.data().toString().contains('lastLogin')
                    ? (userData['lastLogin'] as Timestamp?)?.toDate()
                    : null;

                // Format date
                String formattedDate = timestamp != null
                    ? DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp)
                    : 'No Login Data';

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(userName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: $userEmail'),
                        Text('User ID: $userId',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        Text('Last Login: $formattedDate',
                            style: const TextStyle(color: Colors.blueGrey)),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
