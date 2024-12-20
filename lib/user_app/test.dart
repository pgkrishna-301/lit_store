import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lit_store/user_app/shipping_edit.dart';

class Shipping {
  final String id; // Added an ID field for update API
  final String address;
  final String city;
  final String mobileNumber;
  final String pincode;

  Shipping({
    required this.id,
    required this.address,
    required this.city,
    required this.mobileNumber,
    required this.pincode,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) {
    return Shipping(
      id: json['id'].toString(), // Ensure ID is treated as a string
      address: json['address'],
      city: json['city'],
      mobileNumber: json['phone_number'],
      pincode: json['pincode'],
    );
  }
}

class ShippingListPage extends StatefulWidget {
  final String userId;

  ShippingListPage({required this.userId});

  @override
  _ShippingListPageState createState() => _ShippingListPageState();
}

class _ShippingListPageState extends State<ShippingListPage> {
  late Future<List<Shipping>> _shippingData;

  @override
  void initState() {
    super.initState();
    _shippingData = fetchShippingData(widget.userId);
  }

  Future<List<Shipping>> fetchShippingData(String userId) async {
    final response = await http.get(Uri.parse('http://192.168.31.205:8000/api/shippings/get'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> shippingList = data['data'];

      return shippingList
          .where((item) => item['user_id'].toString() == userId)
          .map((json) => Shipping.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load shipping data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shipping Information"),
      ),
      body: FutureBuilder<List<Shipping>>(
        future: _shippingData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No shipping data available for this user"));
          } else {
            final shippingData = snapshot.data!;
            return ListView.builder(
              itemCount: shippingData.length,
              itemBuilder: (context, index) {
                final shipping = shippingData[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(shipping.address),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('City: ${shipping.city}'),
                        Text('Mobile: ${shipping.mobileNumber}'),
                        Text('Pincode: ${shipping.pincode}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShippingEditPage(
                              userId: widget.userId,
                              shipping: shipping,
                            ),
                          ),
                        ).then((value) {
                          if (value == true) {
                            setState(() {
                              _shippingData = fetchShippingData(widget.userId);
                            });
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
