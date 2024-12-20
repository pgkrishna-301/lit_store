import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserIDStore extends StatefulWidget {
  @override
  _UserIDStoreState createState() => _UserIDStoreState();
}

class _UserIDStoreState extends State<UserIDStore> {
  String _storedUserId = '';

  @override
  void initState() {
    super.initState();
    _loadStoredUserId();
  }

  Future<void> _loadStoredUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedUserId = prefs.getString('user_id') ?? 'No User ID found';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserID Store'),
      ),
      body: Center(
        child: Text(
          'Stored User ID: $_storedUserId',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
