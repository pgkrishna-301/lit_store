import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
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


  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      // Implement your upload logic here.
      print("Image Selected: ${image.path}");
    }
  }
  Future<void> _picksImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedSmage = File(image.path);
      });
      // Implement your upload logic here.
      print("Image Selected: ${image.path}");
    }
  }

  Future<void> _picks1Image() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedS1mage = File(image.path);
      });
      // Implement your upload logic here.
      print("Image Selected: ${image.path}");
    }
  }
  Future<void> _picks2Image() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedS2mage = File(image.path);
      });
      // Implement your upload logic here.
      print("Image Selected: ${image.path}");
    }
  }
  Future<void> _picks3Image() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedS3mage = File(image.path);
      });
      // Implement your upload logic here.
      print("Image Selected: ${image.path}");
    }
  }

  Future<void> _pick1Color() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selected1Color = File(image.path);
      });
      // Implement your upload logic here.
      print("Image Selected: ${image.path}");
    }
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
                    child: _selectedImage == null
                        ? SvgPicture.asset(
                      'assets/images/icons/image.svg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(0), // Optional: Adjust for rounded edges
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover, // Ensures the image covers the entire container
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Four Circles with Add Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFECECEC),
                      shape: BoxShape.circle,
                    ),
                    width: 60,
                    height: 60,
                    child: ClipOval(
                      child: GestureDetector(
                        onTap: _picksImage,
                        child: _selectedSmage == null
                            ? SvgPicture.asset(
                          'assets/images/icons/img.svg',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          _selectedSmage!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFECECEC),
                      shape: BoxShape.circle,
                    ),
                    width: 60,
                    height: 60,
                    child: ClipOval(
                      child: GestureDetector(
                        onTap: _picks1Image,
                        child: _selectedS1mage == null
                            ? SvgPicture.asset(
                          'assets/images/icons/img.svg',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          _selectedS1mage!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFECECEC),
                      shape: BoxShape.circle,
                    ),
                    width: 60,
                    height: 60,
                    child: ClipOval(
                      child: GestureDetector(
                        onTap: _picks2Image,
                        child: _selectedS2mage == null
                            ? SvgPicture.asset(
                          'assets/images/icons/img.svg',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          _selectedS2mage!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFECECEC),
                      shape: BoxShape.circle,
                    ),
                    width: 60,
                    height: 60,
                    child: ClipOval(
                      child: GestureDetector(
                        onTap: _picks3Image,
                        child: _selectedS3mage == null
                            ? SvgPicture.asset(
                          'assets/images/icons/img.svg',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          _selectedS3mage!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),


                ],
              ),
              SizedBox(height: 20),

              // Dropdown for Product Category
              _buildGradientBorderTextField(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Product Category",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  value: selectedCategory,
                  items: ["Category 1", "Category 2", "Category 3"]
                      .map((category) =>
                      DropdownMenuItem(value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
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
                    });
                  },
                ),
              ),
              SizedBox(height: 20),

              // Text Field for Product Name
              _buildGradientBorderTextField(
                child: TextField(
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

              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFECECEC),
                  shape: BoxShape.circle,
                ),
                width: 60,
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    ClipOval(
                      child: GestureDetector(
                        onTap: _pick1Color,
                        child: _selected1Color == null
                            ? SvgPicture.asset(
                          'assets/images/icons/img.svg',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          _selected1Color!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildGradientBorderTextField(
                child: TextField(
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

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Your onPressed function here
                    print("Save button pressed");
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
