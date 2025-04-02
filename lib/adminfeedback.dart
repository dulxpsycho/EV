// adminfeedback.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminFeedback extends StatelessWidget {
  const AdminFeedback({super.key});

  // Function to delete feedback from Firestore
  void _deleteFeedback(String feedbackId) async {
    try {
      await FirebaseFirestore.instance
          .collection('feedback')
          .doc(feedbackId)
          .delete();
    } catch (e) {
      debugPrint("Error deleting feedback: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Feedback'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('feedback')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No feedback available'));
            }

            var feedbackList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                var feedbackData = feedbackList[index];

                // ✅ Safe field access with default values
                var feedbackId = feedbackData.id;
                var feedbackMessage =
                    feedbackData.data().toString().contains('feedback')
                        ? feedbackData['feedback']
                        : 'No feedback available';
                var userId = feedbackData.data().toString().contains('userId')
                    ? feedbackData['userId']
                    : 'Unknown User';
                var timestamp =
                    feedbackData.data().toString().contains('timestamp')
                        ? (feedbackData['timestamp'] as Timestamp?)?.toDate() ??
                            DateTime.now()
                        : DateTime.now();

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(userId),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(feedbackMessage),
                        const SizedBox(height: 5),
                        Text(
                          'Submitted on: ${timestamp.toLocal()}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteFeedback(feedbackId),
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
