import 'dart:convert';

class CartItem {
  final String title;
  final double price;
  final int quantity;

  CartItem({
    required this.title,
    required this.price,
    required this.quantity,
  });

  // Total price of this item (price * quantity)
  double get totalPrice => price * quantity;

  // Create a CartItem from JSON data
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      title: json['title'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'quantity': quantity,
    };
  }

  // String representation for SharedPreferences
  String toSharedPreferencesString() {
    return json.encode(toJson());
  }

  // Create CartItem from SharedPreferences string
  factory CartItem.fromSharedPreferencesString(String data) {
    Map<String, dynamic> json = jsonDecode(data);
    return CartItem.fromJson(json);
  }

  // Create a copy of this CartItem with modified properties
  CartItem copyWith({
    String? title,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'CartItem{title: $title, price: $price, quantity: $quantity}';
  }
}