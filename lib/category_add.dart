import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'config.dart';

class CategoryAddPopup extends StatefulWidget {
  final Function(String) onCategoryAdded;

  CategoryAddPopup({required this.onCategoryAdded});

  @override
  _CategoryAddPopupState createState() => _CategoryAddPopupState();
}

class _CategoryAddPopupState extends State<CategoryAddPopup> {
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? categoryImage;


  Future<void> _pickcategoryImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        categoryImage = File(pickedFile.path);
      });
    }
  }



  Future<void> addCategory() async {
    final uri = Uri.parse("$baseUrl/api/categories");
    final request = http.MultipartRequest('POST', uri);

    try {
      // Add text fields
      request.fields['category_name'] = categoryNameController.text;
      request.fields['section'] = sectionController.text;

      // Add banner image
      if (categoryImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'category_image',
          categoryImage!.path,
        ));
      }

      // Send request
      final response = await request.send();

      // Handle response
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product uploaded successfully!")),
        );
        print("Success: $jsonResponse");

        // Close the current screen after a brief delay
        await Future.delayed(Duration(seconds: 1)); // Optional: Add a delay for the user to see the message
        Navigator.pop(context); // Navigate back to the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload product.")),
        );
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while uploading.")),
      );
      print("Error: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFECECEC), // Container color
                  borderRadius: BorderRadius.circular(16), // Apply circular border radius
                ),

                width: 100,
                height: 100,
                child: GestureDetector(
                  onTap: _pickcategoryImage,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Adjust to center the content
                    children: [
                      // Display image picker button or the selected image
                      categoryImage == null
                          ? SvgPicture.asset(
                        'assets/images/icons/image.svg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Optional: Adjust for rounded edges
                        child: Image.file(
                          categoryImage!,
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Show the selected image's file name


                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(3), // Padding to create space for the gradient border
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEB3030), Color(0xFF851B1B)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  height: 35, // Adjust the height of the TextField
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the TextField
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextField(
                    controller: categoryNameController,
                    decoration: InputDecoration(
                      hintText: "Category Name",
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(3), // Padding to create space for the gradient border
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEB3030), Color(0xFF851B1B)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  height: 35, // Adjust the height of the TextField
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the TextField
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextField(
                    controller: sectionController,
                    decoration: InputDecoration(
                      hintText: "Section",
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: addCategory,
                child: Text("Add Category "),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
