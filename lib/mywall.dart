// mywall.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Wallet {
  final String walletName;
  final double amount;
  final String paymentMethod;

  Wallet({
    required this.walletName,
    required this.amount,
    required this.paymentMethod,
  });
}

class AddWallet extends StatefulWidget {
  const AddWallet({super.key});

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _walletNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<String> paymentMethods = ['Credit Card', 'Debit Card', 'PayPal'];

  String? selectedPaymentMethod;

  @override
  void dispose() {
    _walletNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final wallet = Wallet(
        walletName: _walletNameController.text,
        amount: double.parse(_amountController.text),
        paymentMethod: selectedPaymentMethod!,
      );
      Navigator.pop(context,
          wallet); // Returning the wallet object to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Wallet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Wallet Name Text Field
                TextFormField(
                  controller: _walletNameController,
                  decoration: InputDecoration(
                    labelText: 'Wallet Name',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a wallet name'
                      : null,
                ),
                const SizedBox(height: 16),

                // Amount Text Field
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+(\.\d{0,2})?')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Enter a valid amount greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Payment Method Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Payment Method',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                  ),
                  items: paymentMethods
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  value: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a payment method' : null,
                ),
                const Spacer(), // To push the button to the bottom

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Add Wallet'),
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
