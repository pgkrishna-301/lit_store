import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'test.dart';



class ShippingEditPage extends StatefulWidget {
  final String userId;
  final Shipping shipping;

  ShippingEditPage({required this.userId, required this.shipping});

  @override
  _ShippingEditPageState createState() => _ShippingEditPageState();
}

class _ShippingEditPageState extends State<ShippingEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _pincodeController;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.shipping.address);
    _cityController = TextEditingController(text: widget.shipping.city);
    _mobileNumberController = TextEditingController(text: widget.shipping.mobileNumber);
    _pincodeController = TextEditingController(text: widget.shipping.pincode);
  }

  Future<void> updateShipping() async {
    final url = 'http://192.168.31.205:8000/api/shipping/update';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': widget.userId,
        'address': _addressController.text,
        'city': _cityController.text,
        'phone_number': _mobileNumberController.text,
        'pincode': _pincodeController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Shipping information updated successfully!")),
      );
      Navigator.pop(context, true); // Pass `true` to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update shipping information")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Shipping"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Address"),
                validator: (value) => value!.isEmpty ? "Address cannot be empty" : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: "City"),
                validator: (value) => value!.isEmpty ? "City cannot be empty" : null,
              ),
              TextFormField(
                controller: _mobileNumberController,
                decoration: InputDecoration(labelText: "Mobile Number"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Mobile number cannot be empty" : null,
              ),
              TextFormField(
                controller: _pincodeController,
                decoration: InputDecoration(labelText: "Pincode"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Pincode cannot be empty" : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateShipping();
                  }
                },
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
