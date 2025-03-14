// addEv.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Vehicle {
  final String name;
  final String model;
  final String registrationNumber;

  Vehicle({
    required this.name,
    required this.model,
    required this.registrationNumber,
  });
}

class AddEv extends StatefulWidget {
  const AddEv({super.key});

  @override
  State<AddEv> createState() => _AddEvState();
}

class _AddEvState extends State<AddEv> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _registrationControllers =
      List.generate(4, (index) => TextEditingController());

  // Predefined lists for EV Names and Models
  final List<String> evNames = ['Tata', 'Mahindra', 'bmw', 'Audi'];
  final List<String> evModels = ['Model S', 'Leaf', 'i4', 'e-tron'];

  String? selectedEvName;
  String? selectedEvModel;

  @override
  void dispose() {
    for (var controller in _registrationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final registrationNumber = _registrationControllers
          .map((controller) => controller.text)
          .join('-'); // Joining the registration segments
      Navigator.pop(
        context,
        Vehicle(
          name: selectedEvName!,
          model: selectedEvModel!,
          registrationNumber: registrationNumber,
        ),
      );
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
                  'Vehicle Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // EV Name Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Manufacturer',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                  ),
                  items: evNames
                      .map((name) => DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          ))
                      .toList(),
                  value: selectedEvName,
                  onChanged: (value) {
                    setState(() {
                      selectedEvName = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a manufacturer' : null,
                ),
                const SizedBox(height: 16),

                // EV Model Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Model',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                  ),
                  items: evModels
                      .map((model) => DropdownMenuItem(
                            value: model,
                            child: Text(model),
                          ))
                      .toList(),
                  value: selectedEvModel,
                  onChanged: (value) {
                    setState(() {
                      selectedEvModel = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select an EV model' : null,
                ),
                const SizedBox(height: 16),

                // Text above registration boxes
                const Text(
                  'Enter Vehicle Registration Number',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                    height: 12), // Space before the registration boxes

                // Vehicle Registration Number Row (4 boxes)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 70,
                      child: TextFormField(
                        controller: _registrationControllers[index],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          counterText: '', // Remove the character counter
                        ),
                        maxLength: index == 0 || index == 2
                            ? 2 // First and third boxes: 2 characters
                            : index == 3
                                ? 4 // Fourth box: Up to 4 digits
                                : 3, // Second box: 3 digits
                        inputFormatters: [
                          if (index == 0 || index == 2)
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Za-z]')), // Allow only letters
                          if (index == 0 || index == 2)
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              return newValue.copyWith(
                                text: newValue.text.toUpperCase(),
                              ); // Convert to uppercase
                            }),
                          if (index == 1)
                            FilteringTextInputFormatter.allow(RegExp(
                                r'\d{0,3}')), // Only digits for the second box
                          if (index == 3)
                            FilteringTextInputFormatter.allow(RegExp(
                                r'\d{0,4}')), // Only digits for the fourth box
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a segment';
                          }
                          if ((index == 0 || index == 2) &&
                              !RegExp(r'^[A-Z]{2}$').hasMatch(value)) {
                            return 'Enter exactly 2 letters';
                          }
                          if (index == 1 &&
                              !RegExp(r'^\d{1,3}$').hasMatch(value)) {
                            return 'Enter up to 3 digits';
                          }
                          if (index == 3 &&
                              !RegExp(r'^\d{1,4}$').hasMatch(value)) {
                            return 'Enter up to 4 digits';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
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
                    child: const Text('Add EV'),
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
