import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lit_store/user_app/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingForm extends StatefulWidget {
  @override
  _ShippingFormState createState() => _ShippingFormState();
}

class _ShippingFormState extends State<ShippingForm> {
  String _mobileNumber = '';
  String _id = '';
  String _userId = ''; // Store the user ID here
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMobileNumber();
  }

  Future<void> _loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _mobileNumber = prefs.getString('mobile_number') ?? 'No mobile number found';
    });
    await _fetchUserIdByMobileNumber();
  }

  Future<void> _fetchUserIdByMobileNumber() async {
    final url = Uri.parse('http://192.168.31.205:8000/api/user/profile');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        final matchingUser = users.firstWhere(
              (user) => user['mobile_number'] == _mobileNumber,
          orElse: () => null,
        );

        if (matchingUser != null) {
          setState(() {
            _id = matchingUser['id'].toString();
            _userId = matchingUser['id'].toString();
          });
        } else {
          setState(() {
            _id = '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No matching user found for the mobile number.")),
          );
        }
      } else {
        print("API Error: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch user profiles!")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }


  Future<void> submitShippingDetails() async {
    if (_userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User ID is not available. Please try again later.")),
      );
      return;
    }

    final url = Uri.parse('http://192.168.31.205:8000/api/shipping');
    final body = {
      "user_id": int.parse(_userId),  // Use the fetched user ID
      "address": _addressController.text,
      "city": _cityController.text,
      "pincode": _pincodeController.text,
      "phone_number": _phoneNumberController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Shipping details submitted successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit details!")),
        );
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }
  Future<void> _fetchUserData() async {
    final response = await http.get(Uri.parse('http://192.168.31.205:8000/api/user/profile'));

    if (response.statusCode == 200) {
      // Parse the response data
      List<dynamic> data = json.decode(response.body);

      // Find the user data that matches the mobile number
      for (var user in data) {
        if (user['mobile_number'] == _mobileNumber) {
          setState(() {

            _id = user['id'].toString();
          });
          break;
        }
      }
    } else {
      // Handle API error
      print('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shipping Details Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Removed the TextFormField for User ID as it is set automatically
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Address"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Address";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: "City"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter City";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Pincode"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Pincode";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Phone Number"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Phone Number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitShippingDetails();
                  }
                },
                child: Text("Submit"),
              ),
              Center(
                child: _mobileNumber.isEmpty
                    ? CircularProgressIndicator()
                    : _id.isEmpty
                    ? Text(
                  'No User ID Found',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'User ID: $_id',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShippingListPage(userId: _id),
                          ),
                        );
                      },
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
              )
              ,

            ],
          ),
        ),
      ),
    );
  }
}
