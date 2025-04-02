// firbase/db/db.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_/model/usermodel.dart';

class DataBaseHandler {
  final String uid;
  DataBaseHandler({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  // Save user data to Firestore
  Future<String> saveUserData(UserModel userModel) async {
    try {
      userModel = userModel.copyWith(id: uid);
      await userCollection.doc(uid).set(userModel.toMap());
      return 'success';
    } on FirebaseException catch (e) {
      return 'Firebase error: ${e.message}';
    } catch (e) {
      return e.toString();
    }
  }

  // Submit user feedback to Firestore
  Future<String> submitFeedback(String userId, String feedback) async {
    try {
      await feedbackCollection.add({
        'userId': userId,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return 'success';
    } on FirebaseException catch (e) {
      return 'Firebase error: ${e.message}';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // 🔹 Fetch user's wallet balance
  Future<double> getWalletBalance() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        return (doc['balance'] ?? 0.0).toDouble();
      }
      return 0.0; // Default balance if not found
    } on FirebaseException catch (e) {
      print("Firebase error: ${e.message}");
      return 0.0;
    } catch (e) {
      print("Error: $e");
      return 0.0;
    }
  }

  // 🔹 Add money to user's wallet
  Future<String> addMoneyToWallet(double amount) async {
    try {
      return await FirebaseFirestore.instance
          .runTransaction((transaction) async {
        DocumentReference userDocRef = userCollection.doc(uid);
        DocumentSnapshot userDoc = await transaction.get(userDocRef);

        if (!userDoc.exists) {
          transaction.set(userDocRef, {
            'balance': amount,
            'transactions': [
              {
                'type': 'Credit',
                'amount': amount,
                'date': FieldValue.serverTimestamp()
              }
            ],
          });
        } else {
          double currentBalance = (userDoc['balance'] ?? 0.0).toDouble();
          List<dynamic> transactions = userDoc['transactions'] ?? [];

          transactions.insert(0, {
            'type': 'Credit',
            'amount': amount,
            'date': FieldValue.serverTimestamp()
          });

          transaction.update(userDocRef, {
            'balance': currentBalance + amount,
            'transactions': transactions
          });
        }

        return 'success';
      });
    } on FirebaseException catch (e) {
      return 'Firebase error: ${e.message}';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // 🔹 Deduct money from wallet (for payments)
  Future<String> deductMoneyFromWallet(double amount) async {
    try {
      return await FirebaseFirestore.instance
          .runTransaction((transaction) async {
        DocumentReference userDocRef = userCollection.doc(uid);
        DocumentSnapshot userDoc = await transaction.get(userDocRef);

        if (!userDoc.exists || (userDoc['balance'] ?? 0.0) < amount) {
          return 'Insufficient balance';
        }

        double currentBalance = (userDoc['balance'] ?? 0.0).toDouble();
        List<dynamic> transactions = userDoc['transactions'] ?? [];

        transactions.insert(0, {
          'type': 'Debit',
          'amount': amount,
          'date': FieldValue.serverTimestamp()
        });

        transaction.update(userDocRef,
            {'balance': currentBalance - amount, 'transactions': transactions});

        return 'success';
      });
    } on FirebaseException catch (e) {
      return 'Firebase error: ${e.message}';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
