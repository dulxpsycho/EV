// payment_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ValueNotifier<double> walletBalance = ValueNotifier<double>(0.0);

class MyPay extends StatefulWidget {
  final double amount;
  const MyPay({super.key, required this.amount});

  @override
  State<MyPay> createState() => _MyPayState();
}

class _MyPayState extends State<MyPay> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  String _paymentMethod = 'Credit Card';
  final TextEditingController _amountController = TextEditingController();

  final List<String> _paymentMethods = [
    'Credit Card',
    'Debit Card',
    'UPI',
    'Google Pay',
    'Paytm'
  ];

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<String> addMoneyToWallet(String uid, double amount) async {
    try {
      return await FirebaseFirestore.instance
          .runTransaction((transaction) async {
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(uid);
        DocumentSnapshot userDoc = await transaction.get(userDocRef);

        if (!userDoc.exists) {
          transaction.set(userDocRef, {
            'balance': amount,
            'transactions': [
              {
                'type': 'Credit',
                'amount': amount,
                'date': FieldValue.serverTimestamp()
              },
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
    } catch (e) {
      return 'Error: $e';
    }
  }

  void _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);

      try {
        double amount = double.tryParse(_amountController.text) ?? 0.0;
        if (amount <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Please enter a valid amount greater than 0")));
          setState(() => _isProcessing = false);
          return;
        }

        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User not logged in.")));
          setState(() => _isProcessing = false);
          return;
        }

        String result = await addMoneyToWallet(user.uid, amount);

        if (result == 'success') {
          walletBalance.value += amount;
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Payment Successful'),
                content: Text('₹$amount has been added to your wallet.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Payment failed: $result")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("An error occurred: $e")));
      } finally {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Gateway')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '₹',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  value: _paymentMethod,
                  items: _paymentMethods.map((String method) {
                    return DropdownMenuItem<String>(
                        value: method, child: Text(method));
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _paymentMethod = newValue);
                    }
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white),
                    child: _isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Pay Now', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
