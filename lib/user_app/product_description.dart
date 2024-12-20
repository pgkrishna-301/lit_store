// import 'package:flutter/material.dart';
// import 'config.dart';
//
// class ProductDescriptionPage extends StatefulWidget {
//
//
//
//   final String bannerImage;
//   final List<String> addImage;
//   final String productCategory;
//   final String productBrand;
//   final String productName;
//   final String productDescription;
//   final double mrp;
//   final String lightType;
//   final List<String> colorImage;
//   final String specialFeature;
//   final String wattage;
//   final String bulbShapeSize;
//   final String bulbBase;
//   final String lightColour;
//   final String colourTemperature;
//   final String aboutItems;
//
//
//   ProductDescriptionPage({
//     required this.bannerImage,
//     required this.addImage,
//     required this.productCategory,
//     required this.productBrand,
//     required this.productName,
//     required this.productDescription,
//     required this.mrp,
//     required this.colorImage,
//     required this.specialFeature,
//     required this.lightType,
//     required this.wattage,
//     required this.bulbShapeSize,
//     required this.bulbBase,
//     required this.lightColour,
//     required this.colourTemperature,
//     required this.aboutItems,
//   });
//
//   @override
//   _ProductDescriptionPageState createState() => _ProductDescriptionPageState();
// }
//
// class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
//   String selectedSize = "";
//   String selected2Size = "";
//   int selectedValue = 1;
//   int? selectedIndex;
//   List<Map<String, dynamic>> cartItems = [];// Default value for the dropdown
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.productName)),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//           // Banner Image
//           Image.network(
//           '$baseUrl/storage/${widget.bannerImage}',
//             height: 200,
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//           SizedBox(height: 16),
//
//           // Horizontal Image List
//           Container(
//             height: 100,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: widget.addImage.length,
//               itemBuilder: (context, index) {
//                 final imageUrl = widget.addImage[index];
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 25.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Color(0xFFECECEC),
//                       shape: BoxShape.circle,
//                     ),
//                     height: 60,
//                     width: 60,
//                     child: ClipOval(
//                       child: Image.network(
//                         '$baseUrl/storage/$imageUrl',
//                         height: 60,
//                         width: 60,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => Icon(
//                           Icons.broken_image,
//                           size: 10,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         child: Text(
//                           widget.productName,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Text(
//                         ' \₹${widget.mrp.toStringAsFixed(2)}/-',
//                         textAlign: TextAlign.start,
//                         style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     height: 35,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.red, width: 2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 4,),
//                     child: Row(
//                       children: [
//                         Text("Qty"),
//                         SizedBox(width: 4,),
//                         DropdownButton<int>(
//                           value: selectedValue,
//                           items: List.generate(500, (index) => index + 1)
//                               .map<DropdownMenuItem<int>>(
//                                 (value) => DropdownMenuItem<int>(
//                               value: value,
//                               child: Text(value.toString()),
//                             ),
//                           )
//                               .toList(),
//                           onChanged: (newValue) {
//                             setState(() {
//                               selectedValue = newValue!;
//                             });
//                           },
//                           underline: SizedBox(),
//                           dropdownColor: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 10,),
//               Text(
//                 "Size Name: ($selectedSize)", // Display selected size
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//               ),
//               Column(
//                 children: [
//                   // Text Title
//
//                   SizedBox(height: 16),
//
//                   // Row 1
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       buildSelectableContainer("Pack of 4"),
//                       buildSelectableContainer("7W"),
//                       buildSelectableContainer("7W|B22"),
//                       buildSelectableContainer("7W|B27"),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//
//                   // Row 2
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       buildSelectableContainer("9W"),
//                       buildSelectableContainer("9W|B27"),
//                       buildSelectableContainer("10W|B22"),
//                       buildSelectableContainer("9W|B22"),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//
//                   // Row 3
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       buildSelectableContainer("10W|E27"),
//                       buildSelectableContainer("B22"),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//
//               Text(
//                 "Size ($selected2Size)",
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//               ),
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       build2SelectableContainer("Pack of 1"),
//                       build2SelectableContainer("1 Count (Pack of 1)"),
//                       build2SelectableContainer("Pack of 2"),
//                       build2SelectableContainer("Pack of 3"),
//
//                     ],
//                   ),
//                   SizedBox(height: 16),
//
//                   // Row 2
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       build2SelectableContainer("1 Count (Pack of 12)"),
//                       build2SelectableContainer("Small"),
//                       build2SelectableContainer("Medium"),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//
//                   // Row 3
//
//                 ],
//               ),
//               SizedBox(height: 16),
//               Text("color:"),
//               Container(
//                 height: 60,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: widget.colorImage.length,
//                   itemBuilder: (context, index) {
//                     final imageUrl = widget.colorImage[index];
//                     final isSelected = selectedIndex == index; // Check if this item is selected
//
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 25.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedIndex = index; // Update the selected index
//                           });
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Color(0xFFECECEC),
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: isSelected ? Colors.red : Colors.transparent,
//                               width: 3, // Set border width
//                             ),
//                           ),
//                           height: 60,
//                           width: 60,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(30), // Keep the shape circular
//                             child: Image.network(
//                               '$baseUrl/storage/$imageUrl',
//                               height: 60,
//                               width: 60,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) => Icon(
//                                 Icons.broken_image,
//                                 size: 30,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Text("Configuration"),
//               SizedBox(height: 10,),
//               Padding(
//                 padding: const EdgeInsets. only(right: 80.0,),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes evenly between start and end
//                       children: [
//                         Text(
//                           "Brand",
//                           style: TextStyle(color: Colors.grey, fontSize: 16),
//                         ),
//                         Text(
//                           widget.productBrand,
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//
//                         Text(
//                           "Light Type",
//                           style: TextStyle(color: Colors.grey, fontSize: 16),
//                         ),
//                         Text(
//                           widget.lightType,
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Special Feature",
//                           style: TextStyle(color: Colors.grey, fontSize: 16),
//                         ),
//                         Text(
//                           widget.specialFeature,
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Wattage",
//                           style: TextStyle(color: Colors.grey, fontSize: 16),
//                         ),
//                         Text(
//                           widget.wattage,
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Bulb Shape Size",
//                           style: TextStyle(color: Colors.grey, fontSize: 16),
//                         ),
//                         Text(
//                           widget.bulbShapeSize,
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Bulb Base",
//                           style: TextStyle(color: Colors.grey, fontSize: 16),
//                         ),
//                         Text(
//                           widget.bulbBase,
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Light Color",
//                           style: TextStyle(color: Colors.grey, fontSize: 16),
//                         ),
//                         Text(
//                           widget.lightColour,
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Color Temperature",
//                           style: TextStyle(color: Colors.grey, fontSize: 16),
//                         ),
//                         Text(
//                           widget.colourTemperature,
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     Text("About item"),
//                     SizedBox(height: 10),
//                     Text(widget.aboutItems,
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         addToQuote();
//                       },
//                       child: Text('Add to Quote'),
//                     ),
//
//                   ],
//                 ),
//               ),
//
//
//
//
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   void addToQuote() {
//     final cartItem = {
//       'productName': widget.productName,
//       'quantity': selectedValue,
//       'size': selectedSize,
//       'color': selectedIndex,
//       'price': widget.mrp,
//     };
//
//     setState(() {
//       cartItems.add(cartItem); // Add the product to the cart
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('${widget.productName} added to quote!')),
//     );
//   }
//
//   Widget buildSelectableContainer(String text) {
//     bool isSelected = selectedSize == text; // Check if this container is selected
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedSize = text; // Update the selected size
//         });
//       },
//       child: Container(
//         height: 35,
//         width: 70,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Color(0xFFFFEBEB), // Light red background
//           border: Border.all(
//             color: isSelected ? Colors.red : Colors.transparent, // Highlight if selected
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(8), // Rounded corners
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: Colors.black, // Text color
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
//   Widget build2SelectableContainer(String text) {
//     bool isSelected = selected2Size == text; // Check if this container is selected
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selected2Size = text; // Update the selected size
//         });
//       },
//       child: Container(
//         height: 40,
//         width: 78,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Color(0xFFFFEBEB), // Light red background
//           border: Border.all(
//             color: isSelected ? Colors.red : Colors.transparent, // Highlight if selected
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(8), // Rounded corners
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: Colors.black, // Text color
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
//
//
// // Text and Dropdown Row
//     }