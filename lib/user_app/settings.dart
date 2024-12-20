import 'package:flutter/material.dart';
import 'package:lit_store/user_app/drawer/profile.dart';
import 'package:lit_store/user_app/drawer/shipping_address.dart';
import 'package:lit_store/user_app/test.dart';
import 'package:lit_store/user_app/test1.dart';
import 'package:lit_store/user_app/user_id_store.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Profile'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              // Handle Profile action
            },
          ),
          ListTile(
            title: Text('Shipping Address'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShippingForm()),
              );

              // Handle Shipping Address action
            },
          ),
          ListTile(
            title: Text('Set a Password'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle Set a Password action
            },
          ),
          ListTile(
            title: Text('Terms and Conditions'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle Terms and Conditions action
            },
          ),
          ListTile(
            title: Text('Privacy and Policy'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle Privacy and Policy action
            },
          ),
          ListTile(
            title: Text('Support'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle Support action
            },
          ),
        ],
      ),
    );
  }
}
