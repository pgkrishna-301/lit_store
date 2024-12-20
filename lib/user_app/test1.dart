import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilesScreen extends StatefulWidget {
  @override
  _ProfilesScreenState createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  String _mobileNumber = '';
  String _name = '';
  String _email = '';
  String _id = '';

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
    });

    // Fetch the user data from the API after loading mobile number
    await _fetchUserData();
  }

  // Fetch user data from the API and store user_id automatically
  Future<void> _fetchUserData() async {
    final response = await http.get(Uri.parse('http://192.168.31.205:8000/api/user/profile'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      for (var user in data) {
        if (user['mobile_number'] == _mobileNumber) {
          setState(() {
            _name = user['name'] ?? 'No ame';
            _email = user['email'] ?? 'No Email';
            _id = user['id'].toString();
          });

          // Automatically save user_id to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id', _id);

          print('User ID saved to SharedPreferences: $_id');
          break;
        }
      }
    } else {
      print('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: _mobileNumber == ''
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User ID: $_id',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Name: $_name',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Email: $_email',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
