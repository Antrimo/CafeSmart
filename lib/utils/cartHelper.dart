import 'dart:convert';
import 'package:cafesmart/models/cartModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartHelper {
  static const String _cartKey = 'user_cart';
  
  // Load cart from SharedPreferences
  static Future<List<CartItem>> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartData = prefs.getStringList(_cartKey);
    
    if (cartData == null || cartData.isEmpty) {
      return [];
    }
    
    try {
      List<CartItem> cart = cartData.map((itemString) {
        Map<String, dynamic> itemMap = json.decode(itemString);
        return CartItem(
          title: itemMap['title'],
          price: itemMap['price'].toDouble(),
          quantity: itemMap['quantity'],
        );
      }).toList();
      
      return cart;
    } catch (e) {
      print('Error loading cart: $e');
      return [];
    }
  }
  
  // Save cart to SharedPreferences
  static Future<void> saveCart(List<CartItem> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    List<String> cartData = cart.map((item) {
      return json.encode({
        'title': item.title,
        'price': item.price,
        'quantity': item.quantity,
      });
    }).toList();
    
    await prefs.setStringList(_cartKey, cartData);
  }
  
  // Add item to cart
  static Future<void> addToCart(CartItem newItem) async {
    List<CartItem> currentCart = await loadCart();
    
    // Check if the item already exists in the cart
    bool itemExists = false;
    for (int i = 0; i < currentCart.length; i++) {
      if (currentCart[i].title == newItem.title) {
        // Update the quantity of the existing item
        currentCart[i] = CartItem(
          title: currentCart[i].title,
          price: currentCart[i].price,
          quantity: currentCart[i].quantity + newItem.quantity,
        );
        itemExists = true;
        break;
      }
    }
    
    // If the item doesn't exist, add it to the cart
    if (!itemExists) {
      currentCart.add(newItem);
    }
    
    await saveCart(currentCart);
  }
  
  // Remove item from cart
  static Future<void> removeFromCart(String itemTitle) async {
    List<CartItem> currentCart = await loadCart();
    currentCart.removeWhere((item) => item.title == itemTitle);
    await saveCart(currentCart);
  }
  
  // Update item quantity
  static Future<void> updateQuantity(String itemTitle, int newQuantity) async {
    List<CartItem> currentCart = await loadCart();
    
    for (int i = 0; i < currentCart.length; i++) {
      if (currentCart[i].title == itemTitle) {
        if (newQuantity <= 0) {
          // Remove item if quantity is zero or negative
          currentCart.removeAt(i);
        } else {
          // Update quantity
          currentCart[i] = CartItem(
            title: currentCart[i].title,
            price: currentCart[i].price,
            quantity: newQuantity,
          );
        }
        break;
      }
    }
    
    await saveCart(currentCart);
  }
  
  // Clear the cart
  static Future<void> clearCart() async {
    await saveCart([]);
  }
  
  // Get total cart value
  static Future<double> getCartTotal() async {
    List<CartItem> cart = await loadCart();
    double total = 0;
    for (var item in cart) {
      total += item.price * item.quantity;
    }
    return total;
  }
}