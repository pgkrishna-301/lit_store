// main.dart

import 'package:flutter/material.dart';
import 'package:lit_store/user_app/all_category.dart';
import 'package:lit_store/user_app/home.dart';
import 'package:lit_store/user_app/login.dart';
  // Import the AllCategoryScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Categories and Products',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),  // Set the home screen to AllCategoryScreen
    );
  }
}
