import 'package:flutter/material.dart';
import 'package:lit_store/user_app/drawer/profile_edit.dart';
import 'package:lit_store/user_app/test1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _mobileNumber = '';
  String _name = '';
  String _email = '';
  int _id = 0; // Corrected variable for user id
  String _profileImage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMobileNumber();
  }

  // Retrieve the mobile number from SharedPreferences
  Future<void> _loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _mobileNumber = prefs.getString('mobile_number') ?? 'No mobile number found';
      _getUserProfile(_mobileNumber);  // Fetch user data based on mobile number
    });
  }

  // Fetch user profile data from the API based on mobile number
  Future<void> _getUserProfile(String mobileNumber) async {
    final response = await http.get(Uri.parse('http://192.168.31.205:8000/api/user/profile'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Find the user where mobile_number matches
      for (var user in data) {
        if (user['mobile_number'] == mobileNumber) {
          setState(() {
            _name = user['name'] ?? 'No name available';
            _email = user['email'] ?? 'No email available';
            _id = user['id'] ?? 0; // Fetch the id value correctly
            _profileImage = user['profile_image'] ?? 'No profile image available';
            _isLoading = false;
          });
          break;
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // Handle API error
      print('Failed to load user data');
    }
  }

  // Navigate to the profile edit screen
  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilesEditScreen(  // Corrected class name
          id: _id,  // Pass the actual user ID
          name: _name,
          email: _email,
          mobileNumber: _mobileNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _navigateToEditProfile,  // Edit button
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()  // Show loading spinner while fetching data
            : _mobileNumber == 'No mobile number found'
            ? Text('No mobile number stored in preferences')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Mobile Number: $_mobileNumber', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('Name: $_name', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Email: $_email', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            _profileImage == 'No profile image available'
                ? Text('No profile image available')
                : Image.network(_profileImage),  // Show profile image if available
          ],
        ),
      ),
    );
  }
}
