import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product2nd_view.dart'; // Import the second screen

class ProductsViewScreen extends StatelessWidget {
  final List<dynamic> products;

  ProductsViewScreen({required this.products});

  Future<Map<String, dynamic>> fetchProductDetails(int productId) async {
    final response = await http.get(
      Uri.parse('http://192.168.31.205:8000/api/products/list/$productId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return the decoded response
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 8, // Spacing between columns
          mainAxisSpacing: 8, // Spacing between rows
          childAspectRatio: 0.75, // Aspect ratio for each card
        ),
        padding: EdgeInsets.all(8), // Padding around the grid
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final productId = product['id'].toString();

          return GestureDetector(
            onTap: () {
              // When a product card is tapped, navigate to Product2ndViewScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Product2ndViewScreen(product: product),
                ),
              );
            },
            child: Container(
              height: 300,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network(
                        'http://192.168.31.205:8000/storage/${product['banner_image']}',
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, size: 50, color: Colors.red);
                        },
                      ),
                    ),

                       Text(
                        product['product_name'] ?? 'Product Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),


                       Text(
                        '${product['product_brand'] ?? 'Unknown Brand'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),


                          Text(
                        '₹${product['mrp'] ?? '0.00'}',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    // Display the add_images below the card content
                    // if (product['add_image'] != null && product['add_image'].isNotEmpty)
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: SizedBox(
                      //     height: 60, // You can adjust the height as per your design
                      //     child: ListView.builder(
                      //       scrollDirection: Axis.horizontal,
                      //       itemCount: product['add_image'].length,
                      //       itemBuilder: (context, index) {
                      //         final imageUrl = 'http://192.168.31.205:8000/storage/${product['add_image'][index]}';
                      //         return Padding(
                      //           padding: const EdgeInsets.only(right: 8.0),
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(8),
                      //             child: Image.network(
                      //               imageUrl,
                      //               width: 60, // Image width for display
                      //               height: 60, // Image height for display
                      //               fit: BoxFit.cover,
                      //               errorBuilder: (context, error, stackTrace) {
                      //                 return Icon(Icons.error, size: 40, color: Colors.red);
                      //               },
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
