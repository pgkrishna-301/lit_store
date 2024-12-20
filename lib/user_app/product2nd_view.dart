import 'package:flutter/material.dart';
import 'dart:convert';

class Product2ndViewScreen extends StatefulWidget {
  final Map<String, dynamic> product; // Receive the product data

  Product2ndViewScreen({required this.product});

  @override
  _Product2ndViewScreenState createState() => _Product2ndViewScreenState();
}

class _Product2ndViewScreenState extends State<Product2ndViewScreen> {
  List<String> additionalImages = [];
  List<String> colorImages = [];
  String selectedSize = "";
  String selected2Size = "";
  int selectedValue = 1;
  int? selectedIndex;// Default selected value for the dropdown

  @override
  @override
  void initState() {
    super.initState();

    // Parse the add_image JSON array if it's not null
    if (widget.product['add_image'] != null &&
        widget.product['add_image'] is String) {
      try {
        additionalImages = List<String>.from(
          jsonDecode(widget.product['add_image']),
        );
      } catch (e) {
        print('Error decoding add_image: $e');
      }
    }

    // Parse the color_image JSON array if it's not null
    if (widget.product['color_image'] != null &&
        widget.product['color_image'] is String) {
      try {
        colorImages = List<String>.from(
          jsonDecode(widget.product['color_image']),
        );
      } catch (e) {
        print('Error decoding color_image: $e');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['product_name'] ?? 'Product Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'http://192.168.31.205:8000/storage/${product['banner_image']}',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 50, color: Colors.red);
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 60, // Set the height for the image row
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: additionalImages.length,
                  itemBuilder: (context, index) {
                    final imageUrl =
                        'http://192.168.31.205:8000/storage/${additionalImages[index]}';
                    return Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFECECEC),
                          shape: BoxShape.circle,
                        ),
                        height: 60,
                        width: 60,
                        child: ClipOval(
                          child: Image.network(
                            imageUrl,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(
                                  Icons.broken_image,
                                  size: 10,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Public light is beautiful",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Price: ₹${product['mrp'] ?? '0.00'}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        Text("Qty"),
                        SizedBox(width: 4),
                        DropdownButton<int>(
                          value: selectedValue,
                          items: List.generate(500, (index) => index + 1)
                              .map<DropdownMenuItem<int>>(
                                (value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            ),
                          )
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue = newValue!;
                            });
                          },
                          underline: SizedBox(),
                          dropdownColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Text(
                "Size Name: ($selectedSize)", // Display selected size
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Column(
                children: [
                  // Text Title

                  SizedBox(height: 16),

                  // Row 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildSelectableContainer("Pack of 4"),
                      buildSelectableContainer("7W"),
                      buildSelectableContainer("7W|B22"),
                      buildSelectableContainer("7W|B27"),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Row 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildSelectableContainer("9W"),
                      buildSelectableContainer("9W|B27"),
                      buildSelectableContainer("10W|B22"),
                      buildSelectableContainer("9W|B22"),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Row 3
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildSelectableContainer("10W|E27"),
                      buildSelectableContainer("B22"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),

              Text(
                "Size ($selected2Size)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      build2SelectableContainer("Pack of 1"),
                      build2SelectableContainer("1 Count (Pack of 1)"),
                      build2SelectableContainer("Pack of 2"),
                      build2SelectableContainer("Pack of 3"),

                    ],
                  ),
                  SizedBox(height: 16),

                  // Row 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      build2SelectableContainer("1 Count (Pack of 12)"),
                      build2SelectableContainer("Small"),
                      build2SelectableContainer("Medium"),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Row 3

                ],
              ),
              Text("color:"),
              Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: colorImages.length,
                  itemBuilder: (context, index) {
                    final imageUrl =
                        'http://192.168.31.205:8000/storage/${colorImages[index]}';
                    final isSelected = selectedIndex == index; // Check if this item is selected

                    return Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index; // Update the selected index
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFECECEC),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.red : Colors.transparent,
                              width: 3, // Set border width
                            ),
                          ),
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30), // Keep the shape circular
                            child: Image.network(
                              '$imageUrl',
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.broken_image,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10,),
              Text("Configuration"),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets. only(right: 80.0,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes evenly between start and end
                      children: [
                        Text(
                          "Brand",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          product['product_brand'] ?? 'Product Brand',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          "Light Type",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          product['light_type'] ?? 'light_type',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Special Feature",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          product['special_feature'] ?? 'special_feature',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Wattage",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          product['wattage'] ?? 'Wattage',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bulb Shape Size",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          product['bulb_shape_size'] ?? 'bulb_shape_size',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bulb Base",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          product['bulb_base'] ?? 'bulb_base',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Light Color",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          product['light_colour'] ?? 'light_colour',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Color Temperature",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          product['colour_temperature'] ?? 'colour_temperature',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text("About item"),
                    SizedBox(height: 10),
                    Text( product['about_items'] ?? 'about_items',
                    )

                  ],
                ),
              ),
              // Product Name

            ],
          ),
        ),
      ),
    );
  }
  Widget buildSelectableContainer(String text) {
    bool isSelected = selectedSize == text; // Check if this container is selected
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = text; // Update the selected size
        });
      },
      child: Container(
        height: 35,
        width: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFFFEBEB), // Light red background
          border: Border.all(
            color: isSelected ? Colors.red : Colors.transparent, // Highlight if selected
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black, // Text color
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  Widget build2SelectableContainer(String text) {
    bool isSelected = selected2Size == text; // Check if this container is selected
    return GestureDetector(
      onTap: () {
        setState(() {
          selected2Size = text; // Update the selected size
        });
      },
      child: Container(
        height: 40,
        width: 78,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFFFEBEB), // Light red background
          border: Border.all(
            color: isSelected ? Colors.red : Colors.transparent, // Highlight if selected
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black, // Text color
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
