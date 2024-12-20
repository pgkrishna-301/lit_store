import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductUploadPage extends StatefulWidget {
  @override
  _ProductUploadPageState createState() => _ProductUploadPageState();
}

class _ProductUploadPageState extends State<ProductUploadPage> {
  // Image fields
  File? bannerImage;
  List<File> additionalImages = [];

  // Text controllers
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


  final ImagePicker picker = ImagePicker();


  // Pick banner image
  Future<void> pickBannerImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        bannerImage = File(pickedFile.path);
      });
    }
  }

  // Pick additional images
  Future<void> pickAdditionalImages() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        additionalImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  // Upload product
  Future<void> uploadProduct() async {
    final uri = Uri.parse("http://192.168.43.92:8000/api/products");
    final request = http.MultipartRequest('POST', uri);

    try {
      // Add text fields
      request.fields['product_name'] = productNameController.text;
      request.fields['product_category'] = productCategoryController.text;
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
          'additional_images[]',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Product"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: "Product Name"),
            ),
            TextField(
              controller: productCategoryController,
              decoration: InputDecoration(labelText: "Product Category"),
            ),
            TextField(
              controller: productBrandController,
              decoration: InputDecoration(labelText: "Product Brand"),
            ),
            TextField(
              controller: productDescriptionController,
              decoration: InputDecoration(labelText: "Product Description"),
            ),
            TextField(
              controller: mrpController,
              decoration: InputDecoration(labelText: "MRP"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: discountController,
              decoration: InputDecoration(labelText: "Discount"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: offerPriceController,
              decoration: InputDecoration(labelText: "Offer Price"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickBannerImage,
              child: Text("Pick Banner Image"),
            ),
            if (bannerImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Selected Banner Image: ${bannerImage!.path.split('/').last}"),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickAdditionalImages,
              child: Text("Pick Additional Images"),
            ),
            if (additionalImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Selected Images: ${additionalImages.map((e) => e.path.split('/').last).join(', ')}"),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: uploadProduct,
              child: Text("Upload Product"),
            ),
          ],
        ),
      ),
    );
  }
}
