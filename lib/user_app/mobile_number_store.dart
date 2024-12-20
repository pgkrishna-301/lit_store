import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileNumberStoreScreen extends StatefulWidget {
  @override
  _MobileNumberStoreScreenState createState() => _MobileNumberStoreScreenState();
}

class _MobileNumberStoreScreenState extends State<MobileNumberStoreScreen> {
  String _mobileNumber = '';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Number Store'),
      ),
      body: Center(
        child: Text(
          'Mobile Number: $_mobileNumber',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
