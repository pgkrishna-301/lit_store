import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lit_store/user_app/test3.dart'; // Import the ProfileEditScreen

class ProfileuserScreen extends StatefulWidget {
  final String userId; // Get userId from ProfilesScreen

  ProfileuserScreen({required this.userId});

  @override
  _ProfileuserScreenState createState() => _ProfileuserScreenState();
}

class _ProfileuserScreenState extends State<ProfileuserScreen> {
  String _address = '';
  String _city = '';
  String _pincode = '';
  String _phoneNumber = '';
  bool _isLoading = true; // Track loading state

  // Function to get profile details (Get API)
  Future<void> _fetchProfileDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.31.205:8000/api/shippings/get'), // Update the API URL here
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        // Find the correct user shipping information based on userId
        final userData = responseData['data'].firstWhere(
              (data) => data['user_id'].toString() == widget.userId,
          orElse: () => null,
        );

        if (userData != null) {
          setState(() {
            _address = userData['address'];
            _city = userData['city'];
            _pincode = userData['pincode'];
            _phoneNumber = userData['phone_number'];
            _isLoading = false; // Stop loading once the data is fetched
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User profile not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Failed to fetch profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the ProfileEditScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading // Show loading indicator while fetching data
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: $_address'),
            Text('City: $_city'),
            Text('Pincode: $_pincode'),
            Text('Phone Number: $_phoneNumber'),
          ],
        ),
      ),
    );
  }
}
