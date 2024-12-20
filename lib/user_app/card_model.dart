import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Cart {
  static final Cart _singleton = Cart._internal();

  factory Cart() {
    return _singleton;
  }

  Cart._internal();

  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Load cart items from SharedPreferences
  Future<void> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartList = prefs.getStringList('cartItems');
    if (cartList != null) {
      _cartItems = cartList.map((item) {
        return Map<String, dynamic>.from(json.decode(item));
      }).toList();
    }
  }

  // Add item to the cart
  Future<void> addToCart(Map<String, dynamic> item) async {
    _cartItems.add(item);
    _saveCartItems();
  }

  // Remove item from the cart
  Future<void> removeFromCart(int index) async {
    _cartItems.removeAt(index);
    _saveCartItems();
  }

  // Save cart items to SharedPreferences
  Future<void> _saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsStrings = _cartItems
        .map((cartItem) => json.encode(cartItem)) // Convert cart items to JSON
        .toList();
    await prefs.setStringList('cartItems', cartItemsStrings); // Save list to shared preferences
  }
}
