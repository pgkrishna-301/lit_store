import 'package:flutter/material.dart';
import 'package:lit_store/user_app//cart.dart';
import 'package:lit_store/user_app/card_model.dart'; // Import the Cart singleton

class ProductDescriptionPage extends StatefulWidget {
  final String bannerImage;
  final List<String> addImage;
  final String productCategory;
  final String productBrand;
  final String productName;
  final String productDescription;
  final double mrp;
  final String lightType;
  final List<String> colorImage;
  final String specialFeature;
  final String wattage;
  final String bulbShapeSize;
  final String bulbBase;
  final String lightColour;
  final String colourTemperature;
  final String aboutItems;

  ProductDescriptionPage({
    required this.bannerImage,
    required this.addImage,
    required this.productCategory,
    required this.productBrand,
    required this.productName,
    required this.productDescription,
    required this.mrp,
    required this.colorImage,
    required this.specialFeature,
    required this.lightType,
    required this.wattage,
    required this.bulbShapeSize,
    required this.bulbBase,
    required this.lightColour,
    required this.colourTemperature,
    required this.aboutItems,
  });

  @override
  _ProductDescriptionPageState createState() =>
      _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  String selectedSize = "";
  String selectedColor = "";
  int selectedValue = 1;

  @override
  void initState() {
    super.initState();
    _loadCart(); // Load cart items when the page is initialized
  }

  // Load cart items from Cart singleton
  _loadCart() async {
    await Cart().loadCartItems();
  }

  // Add item to cart using Cart singleton
  void addToQuote() async {
    final cartItem = {
      'productName': widget.productName,
      'quantity': selectedValue,
      'size': selectedSize,
      'color': selectedColor,
      'price': widget.mrp,
    };

    await Cart().addToCart(cartItem); // Add the item to the cart

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.productName} added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the CartScreen without passing cartItems
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.bannerImage,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(widget.productName),
              Text('₹${widget.mrp.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  addToQuote();
                },
                child: Text('Add to Quote'),
              ),
              // Add other widgets here (like size and color selection)
            ],
          ),
        ),
      ),
    );
  }
}
