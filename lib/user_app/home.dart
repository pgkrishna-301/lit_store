import 'package:flutter/material.dart';
import 'package:lit_store/user_app/product_details.dart';
import 'package:lit_store/user_app/settings.dart';
import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'package:lit_store/user_app/product_description.dart';

class Category {
  final int id;
  final String name;
  final String section;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.section,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['category_name'] ?? 'Unknown',
      section: json['section'] ?? 'General',
      image: json['category_image'] ?? '',
    );
  }
}


class Product {
  final int id;
  final String bannerImage;
  final List<String> addImage;
  final String productCategory;
  final String productBrand;
  final String productName;
  final String productDescription;
  final double mrp;
  final double discount;
  final double offerPrice;
  final String sizeName;
  final String packSize;
  final String lightType;
  final String wattage;
  final String specialFeature;
  final String bulbShapeSize;
  final String bulbBase;
  final String lightColour;
  final int netQuantity;
  final String colourTemperature;
  final List<String> colorImage;
  final String aboutItems;

  Product({
    required this.id,
    required this.bannerImage,
    required this.addImage,
    required this.productCategory,
    required this.productBrand,
    required this.productName,
    required this.productDescription,
    required this.mrp,
    required this.discount,
    required this.offerPrice,
    required this.sizeName,
    required this.packSize,
    required this.lightType,
    required this.wattage,
    required this.specialFeature,
    required this.bulbShapeSize,
    required this.bulbBase,
    required this.lightColour,
    required this.netQuantity,
    required this.colourTemperature,
    required this.colorImage,
    required this.aboutItems,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      bannerImage: json['banner_image'] ?? '',
      addImage: (json['add_image'] as String?)
          ?.replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .split(',') ?? [],
      productCategory: json['product_category'] ?? '',
      productBrand: json['product_brand'] ?? '',
      productName: json['product_name'] ?? '',
      productDescription: json['product_description'] ?? '',
      mrp: _parseDouble(json['mrp']),
      discount: _parseDouble(json['discount']),
      offerPrice: _parseDouble(json['offer_price']),
      sizeName: json['size_name'] ?? '',
      packSize: json['pack_size'] ?? '',
      lightType: json['light_type'] ?? '',
      wattage: json['wattage'] ?? '',
      specialFeature: json['special_feature'] ?? '',
      bulbShapeSize: json['bulb_shape_size'] ?? '',
      bulbBase: json['bulb_base'] ?? '',
      lightColour: json['light_colour'] ?? '',
      netQuantity: json['net_quantity'] ?? 0,
      colourTemperature: json['colour_temperature'] ?? '',
      colorImage: (json['color_image'] as String?)
          ?.replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .split(',') ?? [],
      aboutItems: json['about_items'] ?? '',
    );
  }


  // Helper function to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) {
      return 0.0;  // Return 0.0 if the value is null
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;  // Try parsing string to double
    } else if (value is num) {
      return value.toDouble();  // If it's already a number, convert it to double
    }
    return 0.0;  // Default to 0.0 if not a valid type
  }
}

Future<List<Product>> fetchfullProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/api/products/list'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Ensure the 'data' field contains a list of products
    if (data['data'] is List) {
      List<dynamic> productList = data['data'];
      return productList.map((productData) => Product.fromJson(productData as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Expected a list of products, but received something else.');
    }
  } else {
    throw Exception('Failed to load products');
  }
}

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/api/products/list'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['data'] is List) {
      List<dynamic> productList = data['data'];
      List<Product> products = productList
          .map((productData) => Product.fromJson(productData as Map<String, dynamic>))
          .toList();

      // Sort by recency (assuming 'created_at' or 'id' reflects recency)
      products.sort((a, b) => b.id.compareTo(a.id)); // Replace 'id' with 'created_at' if available.

      // Return the first 4 products only
      return products.take(4).toList();
    } else {
      throw Exception('Expected a list of products, but received something else.');
    }

  } else {
    throw Exception('Failed to load products');
  }
}
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> futurefullProducts;
  late Future<List<Product>> futureProducts;
  final String apiUrl = "$baseUrl/api/categories/list";
  final String imageBasePath = "$baseUrl/storage/";
  List<dynamic> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
    futurefullProducts = fetchfullProducts();
    fetchCategories();// Fetch all products
  }


  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("Response: ${response.body}"); // Debugging line

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("Parsed JSON: $jsonResponse"); // Debugging line

        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          setState(() {
            categories = jsonResponse['data'];
            isLoading = false;
          });
        } else {
          throw Exception("Invalid API response structure");
        }
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching categories: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the Drawer
            },
          ),
        ),
        title: Text('Home Screen'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder profile image
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                // Handle History action
              },
            ),
            ListTile(
              leading: Icon(Icons.track_changes),
              title: Text('Order Tracking'),
              onTap: () {
                // Handle Order Tracking action
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: () {
                // Handle Logout action
              },
            ),
          ],
        ),
      )

      ,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Box
              Container(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.0),

              // All Featured Text
              Text(
                'All Featured',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),

              // Horizontal Scrolling List of Categories
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final categoryName = category['category_name'];
                    final categoryImage = category['category_image'];
                    return Container(
                      width: 50,
                      margin: EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0), // Image's border radius
                            child: Image.network(
                              "$imageBasePath$categoryImage",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(height: 5.0),
                          Text(
                            category['category_name'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );

                  },
                ),
              ),
              SizedBox(height: 16.0),

              // Banner Image
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/400'), // Placeholder banner image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "New item" Text
                  Text(
                    "New item",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // "See All" Button with Icon
                  TextButton.icon(
                    onPressed: () {
                      // Handle "See All" button action
                    },

                    label: Text("See All"),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove padding around button
                      textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),
                    ),
                    icon: Icon(Icons.arrow_forward, size: 16),
                  ),
                ],
              ),
              FutureBuilder<List<Product>>(
                future: futureProducts, // Future that fetches the products
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final products = snapshot.data!;
                    return Container(
                      height: 150,
                      child: ListView.builder(
                        itemCount: products.length,
                        scrollDirection: Axis.horizontal, // Horizontal scroll
                        itemBuilder: (context, index) {
                          final product = products[index];
                          // Handle null safety for product fields
                          final bannerImage = product.bannerImage ?? '';
                          final productName = product.productName ?? 'No Name';
                          final productBrand = product.productBrand ?? 'No Name';
                          final mrp = product.mrp ?? 'No Name';

                          return Container(
                            width: 150,
                            margin: EdgeInsets.only(right: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0), // Image's border radius
                                  child: bannerImage.isNotEmpty
                                      ? Image.network(
                                    '$baseUrl/storage/$bannerImage',
                                    width: 130,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      Icons.error,
                                      size: 50,
                                      color: Colors.red,
                                    ),
                                  )
                                      : Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),

                                Text(
                                  '₹$mrp',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  '$productName,($productBrand)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),


                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text('No products found.'));
                  }
                },
              ),
              SizedBox(height: 10),
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/400'), // Placeholder banner image
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              FutureBuilder<List<Product>>(
                future: futurefullProducts, // Future that fetches the products
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final products = snapshot.data!;
                    return ListView(
                      padding: EdgeInsets.all(16.0),
                      physics: NeverScrollableScrollPhysics(), // Prevents separate scrolling for this ListView
                      shrinkWrap: true, // Allows the ListView to size dynamically
                      children: [
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(), // GridView shouldn't scroll independently
                          shrinkWrap: true, // GridView adapts its size within the ListView
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            crossAxisSpacing: 16.0, // Horizontal spacing between items
                            mainAxisSpacing: 16.0, // Vertical spacing between items
                            childAspectRatio: 0.75, // Aspect ratio of each item
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final bannerImage = product.bannerImage ?? '';
                            final productName = product.productName ?? 'No Name';
                            final productBrand = product.productBrand ?? 'No Name';
                            final mrp = product.mrp ?? 'No Name';



                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: (){Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDescriptionPage(
                                      bannerImage: product.bannerImage,
                                      addImage: product.addImage,
                                      colorImage: product.colorImage,
                                      productCategory: product.productCategory,
                                      productBrand: product.productBrand,
                                      productName: product.productName,
                                      productDescription: product.productDescription,
                                      lightType: product.lightType,
                                      specialFeature: product.specialFeature,
                                      wattage: product.wattage,
                                      bulbShapeSize: product.bulbShapeSize,
                                      bulbBase: product.bulbBase,
                                      lightColour: product.lightColour,
                                      colourTemperature: product.colourTemperature,
                                      aboutItems: product.aboutItems,
                                      mrp: product.mrp,

                                    ),
                                  ),
                                );},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0), // Image's border radius
                                      child: bannerImage.isNotEmpty
                                          ? Image.network(
                                        '$baseUrl/storage/$bannerImage',
                                        width: double.infinity,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.error,
                                          size: 50,
                                          color: Colors.red,
                                        ),
                                      )
                                          : Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 8), // Add spacing between elements
                                    Text(
                                      '₹$mrp',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      '$productName, ($productBrand)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text('No products found.'));
                  }
                },
              ),










            ],
          ),
        ),
      ),
    );
  }
}


