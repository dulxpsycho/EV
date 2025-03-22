// AddWall.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddWall extends StatefulWidget {
  const AddWall({super.key});

  @override
  _AddWallState createState() => _AddWallState();
}

class _AddWallState extends State<AddWall> {
  double _balance = 0.00;
  double _amountToAdd = 0.0;
  final List<String> _transactionHistory = [];

  void _addMoney() {
    if (_amountToAdd <= 0) {
      // Display a snack bar message for invalid amount
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Amount must be greater than zero!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _balance += _amountToAdd;
      _transactionHistory.insert(
        0,
        'Added ₹${_amountToAdd.toStringAsFixed(2)} | ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
      );
      _amountToAdd = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(name: 'INR');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Wallet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Card
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade200,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      _balance == 0.0
                          ? '₹0.00'
                          : currencyFormat.format(_balance),
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Add Money Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Money',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _amountToAdd = double.tryParse(value) ?? 0.0;
                                });
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                labelText: 'Enter Amount',
                                prefixText: '₹ ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _amountToAdd > 0 ? _addMoney : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade400,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Transaction History
              const Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Expanded ListView for Transaction History
              _transactionHistory.isEmpty
                  ? const Center(
                      child: Text(
                        'No transactions yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _transactionHistory.length,
                      itemBuilder: (context, index) {
                        return _buildTransactionItem(
                            _transactionHistory[index]);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(String transaction) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1, // Lower elevation for a minimal look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: Text(
          transaction.split(' | ')[0],
          style: const TextStyle(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis, // Prevent overflow with ellipsis
        ),
        subtitle: Text(
          transaction.split(' | ')[1],
          style: TextStyle(color: Colors.grey.shade600),
          overflow: TextOverflow.ellipsis, // Prevent overflow with ellipsis
        ),
        trailing: const Icon(Icons.arrow_upward, color: Colors.green, size: 20),
        onTap: () {
          // Show transaction details in a simplified dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
                title: const Text('Transaction Details'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Amount: ${transaction.split(' | ')[0]}'),
                    const SizedBox(height: 8),
                    Text('Date & Time: ${transaction.split(' | ')[1]}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
