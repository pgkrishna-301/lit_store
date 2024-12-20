import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lit_store/user_app/product_view.dart';// Import the products view page

class AllCategoryScreen extends StatefulWidget {
  @override
  _AllCategoryScreenState createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  Map<String, List<dynamic>> groupedCategories = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    const String url = 'http://192.168.31.205:8000/api/categories/list';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          List<dynamic> categoryData = jsonResponse['data'];

          // Group categories by section
          Map<String, List<dynamic>> groupedData = {};
          for (var category in categoryData) {
            final section = category['section'] ?? 'Uncategorized';
            if (!groupedData.containsKey(section)) {
              groupedData[section] = [];
            }
            groupedData[section]?.add(category);
          }

          setState(() {
            groupedCategories = groupedData;
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load categories');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to fetch products by category name
  Future<void> fetchProductsByCategory(String categoryName) async {
    const String url = 'http://192.168.31.205:8000/api/products/list';

    try {
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');  // Print the raw response

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          List<dynamic> productData = jsonResponse['data'];

          // Filter products by the selected category name
          List<dynamic> filteredProducts = productData.where((product) {
            return product['product_category'] == categoryName;
          }).toList();

          if (filteredProducts.isEmpty) {
            print('No products found for category: $categoryName');
          }

          // Navigate to the products view screen with filtered products
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductsViewScreen(products: filteredProducts),
            ),
          );
        } else {
          throw Exception('Failed to load products');
        }
      } else {
        throw Exception('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories by Section'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: groupedCategories.keys.length,
        itemBuilder: (context, index) {
          final section = groupedCategories.keys.elementAt(index);
          final categories = groupedCategories[section]!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    section,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // List of Categories in the Section
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, catIndex) {
                    final category = categories[catIndex];
                    return Card(
                      color: Colors.white,
                      elevation: 8,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: category['category_image'] != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'http://192.168.31.205:8000/storage/${category['category_image']}',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Icon(Icons.image_not_supported),
                        title: Text(category['category_name'] ?? 'No Name'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        onTap: () {
                          // Fetch products for the selected category
                          fetchProductsByCategory(category['category_name']);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
