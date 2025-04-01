import 'package:cafesmart/models/cartModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartHelper {
  // Save cart items to SharedPreferences
  static Future<void> saveCart(List<CartItem> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert the list of CartItems to a list of maps, then encode as JSON string
    List<String> cartData =
        cart.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList('cart', cartData);
  }

  // Load cart items from SharedPreferences
  static Future<List<CartItem>> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartData = prefs.getStringList('cart') ?? [];

    // Decode the list of maps back to CartItems
    List<CartItem> cart = cartData.map((data) {
      Map<String, dynamic> map = json.decode(data);
      return CartItem.fromMap(map);
    }).toList();

    return cart;
  }
}
