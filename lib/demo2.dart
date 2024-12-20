import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CategoryDropdown(),
    );
  }
}

class CategoryDropdown extends StatefulWidget {
  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  List<String> _categories = [];  // To store category names
  String? _selectedCategory;  // To store the selected category

  @override
  void initState() {
    super.initState();
    _fetchCategories();  // Fetch the categories when the widget is initialized
  }

  // Fetch the categories from the Laravel API
  Future<void> _fetchCategories() async {
    final url = Uri.parse('http://192.168.43.92:8000/api/categories/list');
    try {
      final response = await http.get(url);  // Send GET request to the API
      if (response.statusCode == 200) {
        // If the response is successful (200 OK), parse the data
        final List<dynamic> data = jsonDecode(response.body)['data'];
        setState(() {
          // Ensure the categories list has unique values
          _categories = data
              .map((item) => item['category_name'].toString())
              .toSet()  // Remove duplicates
              .toList();
          if (_categories.isNotEmpty) {
            _selectedCategory = _categories[0];  // Set the first category as default if available
          }
        });
      } else {
        // If the response is not successful, log an error
        print('Failed to load categories');
      }
    } catch (e) {
      // If there is an error (e.g., network issue), log it
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Dropdown'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown to select a category
            DropdownButton<String>(
              isExpanded: true,  // Make the dropdown button span the width of the screen
              hint: Text('Select a category'),  // Text shown when no category is selected
              value: _selectedCategory,  // Use the selected category
              onChanged: (String? value) {
                setState(() {
                  // Update the selected category when the user selects a new one
                  _selectedCategory = value;
                });
              },
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,  // Value to be passed when an item is selected
                  child: Text(category),  // Text to be shown in the dropdown
                );
              }).toList(),
            ),
            SizedBox(height: 20),  // Spacer between dropdown and selected category text
            // Text to display the currently selected category
            Text(
              _selectedCategory != null
                  ? 'Selected: $_selectedCategory'
                  : 'No category selected',  // Display the selected category name
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
