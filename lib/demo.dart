// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:lit_store/category_add.dart';
//
//
// class ProductScreen extends StatefulWidget {
//   @override
//   _ProductScreenState createState() => _ProductScreenState();
// }
//
// class _ProductScreenState extends State<ProductScreen> {
//   List<String> categories = ["Add Item"]; // Initial list with "Add Item"
//   String? selectedCategory;
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController productCategoryController = TextEditingController();
//   File? bannerImage; // Replace with your file picker logic
//   List<File> additionalImages = []; // Replace with your file picker logic
//   List<File> colorImages = []; // Replace with your file picker logic
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories(); // Fetch categories when the screen loads
//   }
//
//   Future<void> fetchCategories() async {
//     final url = Uri.parse('http://192.168.43.92:8000/api/categories/list');
//     try {
//       final response = await http.get(url);  // Send GET request to the API
//       if (response.statusCode == 200) {
//         // If the response is successful (200 OK), parse the data
//         final List<dynamic> data = jsonDecode(response.body)['data'];
//         setState(() {
//           // Ensure the categories list has unique values
//           categories = data
//               .map((item) => item['category_name'].toString())
//               .toSet()  // Remove duplicates
//               .toList();
//           if (categories.isNotEmpty) {
//             selectedCategory = categories[0];  // Set the first category as default if available
//           }
//         });
//       } else {
//         // If the response is not successful, log an error
//         print('Failed to load categories');
//       }
//     } catch (e) {
//       // If there is an error (e.g., network issue), log it
//       print('Error: $e');
//     }
//   }
//
//   Future<void> uploadProduct() async {
//     final uri = Uri.parse("http://192.168.43.92:8000/api/products");
//     final request = http.MultipartRequest('POST', uri);
//
//     try {
//       // Add text fields
//       request.fields['product_name'] = productNameController.text;
//       request.fields['product_category'] = selectedCategory ?? '';
//
//       // Add banner image
//       if (bannerImage != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'banner_image',
//           bannerImage!.path,
//         ));
//       }
//
//       // Add additional images
//       for (var image in additionalImages) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'add_image[]',
//           image.path,
//         ));
//       }
//
//       for (var image in colorImages) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'color_image[]', // Use appropriate key for color images
//           image.path,
//         ));
//       }
//
//       // Send request
//       final response = await request.send();
//
//       // Handle response
//       if (response.statusCode == 201) {
//         final responseBody = await response.stream.bytesToString();
//         final jsonResponse = jsonDecode(responseBody);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Product uploaded successfully!")),
//         );
//         print("Success: $jsonResponse");
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to upload product.")),
//         );
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("An error occurred while uploading.")),
//       );
//       print("Error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Product Screen")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: productNameController,
//               decoration: InputDecoration(
//                 labelText: "Product Name",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             _buildGradientBorderTextField(
//               child: DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   hintText: "Product Category",
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                 ),
//                 value: selectedCategory,
//                 items: [
//                   ...categories.map((category) => DropdownMenuItem(
//                     value: category,
//                     child: Text(category),
//                   )),
//                   DropdownMenuItem(
//                     value: "Add Item",
//                     child: Text("Add Item"),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   if (value == "Add Item") {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return Dialog(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: SizedBox(
//                               height: 400,
//                               child: CategoryAddPopup(
//                                 onCategoryAdded: (newCategory) {
//                                   setState(() {
//                                     categories.add(newCategory);
//                                     selectedCategory = newCategory;
//                                   });
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   } else {
//                     setState(() {
//                       selectedCategory = value;
//                     });
//                   }
//                 },
//               ),
//
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: uploadProduct,
//               child: Text("Upload Product"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGradientBorderTextField({required Widget child}) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFFEB3030), Color(0xFF851B1B)],
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(2.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }
//
//
