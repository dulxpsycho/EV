// wallet.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ev_/firbase/db/db.dart';
import 'payment_page.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWalletData();

    // Add listener to update UI when wallet balance changes
    walletBalance.addListener(() {
      if (mounted) {
        setState(() {}); // Trigger rebuild when balance changes
      }
    });
  }

  @override
  void dispose() {
    // It's a good practice to remove listeners when the widget is disposed
    // But since this is a global ValueNotifier, only remove the listener, not dispose the notifier
    super.dispose();
  }

  Future<void> _fetchWalletData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Use the existing DataBaseHandler class
        DataBaseHandler db = DataBaseHandler(uid: user.uid);

        // Get wallet balance
        double balance = await db.getWalletBalance();
        walletBalance.value = balance;

        // Get user document to fetch transactions
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null && data.containsKey('transactions')) {
            List<dynamic> rawTransactions = data['transactions'] ?? [];
            setState(() {
              transactions = rawTransactions
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
            });
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching wallet data: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void navigateToPaymentPage() async {
    double? enteredAmount = await _showAmountDialog();
    if (enteredAmount != null && enteredAmount > 0) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyPay(amount: enteredAmount)),
      );

      if (result == true) {
        _fetchWalletData();
      }
    }
  }

  Future<double?> _showAmountDialog() async {
    TextEditingController amountController = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Amount"),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: "Amount (₹)", prefixText: "₹"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              double? enteredAmount = double.tryParse(amountController.text);
              Navigator.pop(context, enteredAmount);
            },
            child: const Text("Proceed"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("My Wallet",
            style:
                GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    color: Colors.redAccent,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      child: Column(
                        children: [
                          const Icon(Icons.account_balance_wallet,
                              color: Colors.white, size: 40),
                          const SizedBox(height: 10),
                          Text("Wallet Balance",
                              style: GoogleFonts.roboto(
                                  fontSize: 18, color: Colors.white70)),
                          const SizedBox(height: 8),
                          Text("₹${walletBalance.value.toStringAsFixed(2)}",
                              style: GoogleFonts.roboto(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: navigateToPaymentPage,
                    icon: const Icon(Icons.add, size: 24),
                    label: const Text("Add Money"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: transactions.isEmpty
                        ? const Center(child: Text("No transactions yet"))
                        : ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              Timestamp? timestamp =
                                  transaction['date'] as Timestamp?;
                              String dateStr = timestamp != null
                                  ? "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}"
                                  : "N/A";

                              return ListTile(
                                leading: Icon(
                                    transaction['type'] == 'Credit'
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: transaction['type'] == 'Credit'
                                        ? Colors.green
                                        : Colors.red),
                                title: Text(
                                    "${transaction['type'] == 'Credit' ? '+' : '-'} ₹${transaction['amount'].toStringAsFixed(2)}",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: transaction['type'] == 'Credit'
                                            ? Colors.green
                                            : Colors.red)),
                                subtitle: Text("Date: $dateStr",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14, color: Colors.black54)),
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
