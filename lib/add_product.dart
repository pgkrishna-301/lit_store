import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lit_store/category_add.dart';
import 'package:lit_store/demo.dart';
import 'config.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  List<String> categories = ["Add Item"]; // Initial list with "Add Item"
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productCategoryController = TextEditingController();
  final TextEditingController productBrandController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController mrpController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();
  final TextEditingController sizenameController = TextEditingController();
  final TextEditingController packsizeController = TextEditingController();
  final TextEditingController lighttypeController = TextEditingController();
  final TextEditingController wattageController = TextEditingController();
  final TextEditingController specialfeatureController = TextEditingController();
  final TextEditingController bulbshapesizeController = TextEditingController();
  final TextEditingController bulbbaseController = TextEditingController();
  final TextEditingController lightcolourController = TextEditingController();
  final TextEditingController netquantityController = TextEditingController();
  final TextEditingController colourtemperatureController = TextEditingController();
  final TextEditingController aboutitemsController = TextEditingController();
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final ImagePicker picker = ImagePicker();



  File? bannerImage;
  List<File> additionalImages = [];
  List<File> colorImages = [];
  String? _responseMessage;
  String? selectedCategory;

  String? selectedBrand;
  String? selectedSize;
  String? selectedPack;
  File? _selectedImage;
  File? _selectedSmage;
  File? _selectedS1mage;
  File? _selectedS2mage;
  File? _selectedS3mage;
  File? _selected1Color;

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when the screen loads
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse('$baseUrl/api/categories/list');
    try {
      final response = await http.get(url);  // Send GET request to the API
      if (response.statusCode == 200) {
        // If the response is successful (200 OK), parse the data
        final List<dynamic> data = jsonDecode(response.body)['data'];
        setState(() {
          // Ensure the categories list has unique values
          categories = data
              .map((item) => item['category_name'].toString())
              .toSet()  // Remove duplicates
              .toList();
          if (categories.isNotEmpty) {
            selectedCategory = categories[0];  // Set the first category as default if available
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


  Future<void> uploadProduct() async {
    final uri = Uri.parse("$baseUrl/api/products");
    final request = http.MultipartRequest('POST', uri);

    try {
      // Add text fields
      request.fields['product_name'] = productNameController.text;
      request.fields['product_category'] = selectedCategory ?? '';
      request.fields['product_brand'] = productBrandController.text;
      request.fields['product_description'] = productDescriptionController.text;
      request.fields['mrp'] = mrpController.text;
      request.fields['discount'] = discountController.text;
      request.fields['offer_price'] = offerPriceController.text;
      request.fields['size_name'] = sizenameController.text;
      request.fields['pack_size'] = packsizeController.text;
      request.fields['light_type'] = lighttypeController.text;
      request.fields['wattage'] = wattageController.text;
      request.fields['special_feature'] = specialfeatureController.text;
      request.fields['bulb_shape_size'] = bulbshapesizeController.text;
      request.fields['bulb_base'] = bulbbaseController.text;
      request.fields['light_colour'] = lightcolourController.text;
      request.fields['net_quantity'] = netquantityController.text;
      request.fields['colour_temperature'] = colourtemperatureController.text;
      request.fields['about_items'] = aboutitemsController.text;

      // Add banner image
      if (bannerImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'banner_image',
          bannerImage!.path,
        ));
      }

      // Add additional images
      for (var image in additionalImages) {
        request.files.add(await http.MultipartFile.fromPath(
          'add_image[]',
          image.path,
        ));
      }

      for (var image in colorImages) {
        request.files.add(await http.MultipartFile.fromPath(
          'color_image[]', // Use appropriate key for color images
          image.path,
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
  Future<void> _pickImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        bannerImage = File(pickedFile.path);
      });
    }
  }


  Future<void> pickAdditionalImages() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        additionalImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }


  Future<void> pickcolorImages() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        colorImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }



  void openAddCategoryPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CategoryAddPopup(
              onCategoryAdded: (newCategory) {
                setState(() {
                  categories.insert(categories.length - 1, newCategory); // Add before "Add Item"
                  selectedCategory = newCategory;
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Product Image Section
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFECECEC), // Container color
                  borderRadius: BorderRadius.circular(16), // Apply circular border radius
                ),

                width: double.infinity,
                height: 150,
                child: Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Adjust to center the content
                      children: [
                        // Display image picker button or the selected image
                        bannerImage == null
                            ? SvgPicture.asset(
                          'assets/images/icons/image.svg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(8), // Optional: Adjust for rounded edges
                          child: Image.file(
                            bannerImage!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Show the selected image's file name


                      ],
                    ),
                  ),


                ),
              ),

              SizedBox(height: 20),

              // Four Circles with Add Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...List.generate(4, (index) {
                    return GestureDetector(
                      onTap: pickAdditionalImages,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFECECEC),
                          shape: BoxShape.circle,
                        ),
                        width: 60,
                        height: 60,
                        child: ClipOval(
                          child: index < additionalImages.length
                              ? Image.file(
                            additionalImages[index],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                              : SvgPicture.asset(
                            'assets/images/icons/img.svg',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: 20),

              // Dropdown for Product Category
              _buildGradientBorderTextField(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Product Category",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  value: selectedCategory,
                  items: [
                    ...categories.map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    )),
                    DropdownMenuItem(
                      value: "Add Item",
                      child: Text("Add Item"),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == "Add Item") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                height: 400,
                                child: CategoryAddPopup(
                                  onCategoryAdded: (newCategory) {
                                    setState(() {
                                      categories.add(newCategory);
                                      selectedCategory = newCategory;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      setState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),


              ),
              SizedBox(height: 20),

              // Dropdown for Product Brand
              _buildGradientBorderTextField(
                child: DropdownButtonFormField<String>(

                  decoration: InputDecoration(
                    hintText: "Product Brand",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  value: selectedBrand,
                  items: ["Brand 1", "Brand 2", "Brand 3"]
                      .map((brand) =>
                      DropdownMenuItem(value: brand, child: Text(brand)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBrand = value;
                      productBrandController.text = value ?? '';
                    });
                  },
                ),
              ),
              SizedBox(height: 20),

              // Text Field for Product Name
              _buildGradientBorderTextField(
                child: TextField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    hintText: "Product Name",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Text Field for Product Description
              _buildGradientBorderTextField(
                child: TextField(
                  controller: productDescriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Product Description..",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Two Text Fields for MRP and Discount
              Row(
                children: [
                  Expanded(
                    child: _buildGradientBorderTextField(
                      child: TextField(
                        controller: mrpController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          hintText: "MRP",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildGradientBorderTextField(
                      child: TextField(
                        controller: discountController,
                        decoration: InputDecoration(
                          hintText: "Discount",
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildGradientBorderTextField(
                child: TextField(
                  controller: offerPriceController,
                  decoration: InputDecoration(
                    hintText: "Offer Price",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildGradientBorderTextField(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Size Name",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  value: selectedSize,
                  items: ["Size  1", "Size 2", "Size 3"]
                      .map((size) =>
                      DropdownMenuItem(value: size, child: Text(size)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSize= value;
                      sizenameController.text = value ?? '';
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              _buildGradientBorderTextField(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Packing Size",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  value: selectedPack,
                  items: ["Pack of 1", "Pack of 2", "Pack of 3"]
                      .map((pack) =>
                      DropdownMenuItem(value: pack, child: Text(pack)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPack = value;
                      packsizeController.text = value ?? '';
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildGradientBorderTextField(
                      child: TextField(
                        controller: lighttypeController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          hintText: "Light Type",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildGradientBorderTextField(
                      child: TextField(
                        controller: wattageController,
                        decoration: InputDecoration(
                          hintText: "Wattage",
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildGradientBorderTextField(
                      child: TextField(
                        controller: specialfeatureController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          hintText: "Special Feature",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildGradientBorderTextField(
                      child: TextField(
                        controller: bulbshapesizeController,
                        decoration: InputDecoration(
                          hintText: "Bulb Shape size",
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildGradientBorderTextField(
                      child: TextField(
                        controller: bulbbaseController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          hintText: "Bulb Base",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildGradientBorderTextField(
                      child: TextField(
                        controller: lightcolourController,
                        decoration: InputDecoration(
                          hintText: "Light Colour",
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildGradientBorderTextField(
                child: TextField(
                  controller: netquantityController,
                  decoration: InputDecoration(
                    hintText: "Net Quantity",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildGradientBorderTextField(
                child: TextField(
                  controller: colourtemperatureController,
                  decoration: InputDecoration(
                    hintText: "Colour Temperature",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Color", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),)
                ],
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...List.generate(4, (index) {
                    return GestureDetector(
                      onTap: pickcolorImages,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFECECEC),
                          shape: BoxShape.circle,
                        ),
                        width: 60,
                        height: 60,
                        child: ClipOval(
                          child: index < colorImages.length
                              ? Image.file(
                            colorImages[index],
                            width: 10,
                            height: 30,
                            fit: BoxFit.cover,
                          )
                              : SvgPicture.asset(
                            'assets/images/icons/img.svg',
                            width: 10,
                            height: 10,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: 20),
              _buildGradientBorderTextField(
                child: TextField(
                  controller: aboutitemsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "About this Item...",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEB3030), Color(0xFF851B1B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),

                child:Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEB3030), Color(0xFF851B1B)],
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ElevatedButton(
                    onPressed: uploadProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Make the button background transparent
                      shadowColor: Colors.transparent,    // Remove shadow
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )


              )



            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Gradient Border Text Field
  Widget _buildGradientBorderTextField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Color(0xFFEB3030), Color(0xFF851B1B)],
        ),
      ),
      padding: EdgeInsets.all(1.5), // Gradient border thickness
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Inner background color
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}
