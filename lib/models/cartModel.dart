class CartItem {
  final String title;
  final double price;
  int quantity; // Add quantity field

  CartItem({required this.title, required this.price, this.quantity = 1});

  double get totalPrice =>
      price * quantity; // Calculate total price based on quantity

  // Convert CartItem to a Map for saving to SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'quantity': quantity,
    };
  }

  // Convert Map to CartItem
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      title: map['title'],
      price: map['price'],
      quantity: map['quantity'] ?? 1,
    );
  }
}
