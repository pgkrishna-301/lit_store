import 'package:flutter/material.dart';

import 'package:lit_store/user_app/card_model.dart'; // Import the Cart singleton

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() async {
    await Cart().loadCartItems(); // Load the cart items
    setState(() {}); // Trigger rebuild to show updated cart items
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cartItems = Cart().cartItems;

    double totalPrice = cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('No items in the cart'))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            title: Text(item['productName']),
            subtitle: Text('Qty: ${item['quantity']}  Size: ${item['size']}  Color: ${item['color']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('₹${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await Cart().removeFromCart(index); // Remove item from cart
                    setState(() {}); // Rebuild the screen after removal
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: ₹${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                // Implement checkout functionality here
              },
              child: Text('Proceed to Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
