import 'package:cafesmart/models/cartModel.dart';
import 'package:cafesmart/utils/cartHelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatelessWidget {
  final List<CartItem> cart;
  CartPage({Key? key, required this.cart}) : super(key: key);

  // Method to place an order
  Future<void> _placeOrder(BuildContext context) async {
    if (cart.isEmpty) return; // Don't proceed if cart is empty

    double totalAmount = 0.0;
    cart.forEach((item) {
      totalAmount += item.totalPrice;
    });

    // Get the current budget
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double currentBudget = prefs.getDouble('budget') ?? 0.0;

    if (currentBudget < totalAmount) {
      // Notify user about insufficient budget
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Insufficient Budget"),
            content: Text(
              "You don't have enough budget (₹$currentBudget) for this order (₹$totalAmount).",
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Deduct from budget
    double newBudget = currentBudget - totalAmount;
    await prefs.setDouble('budget', newBudget);

    // Save the order as an expense
    List<String> expenses = prefs.getStringList('expenses') ?? [];
    expenses.add('Food Order|${totalAmount.toStringAsFixed(2)}');
    await prefs.setStringList('expenses', expenses);

    // Clear the cart
    await CartHelper.saveCart([]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Order Placed"),
          content: Text(
              "Your total is ₹$totalAmount. Your order has been placed. Remaining budget: ₹${newBudget.toStringAsFixed(2)}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Close both dialogs
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;
    cart.forEach((item) {
      totalAmount += item.totalPrice;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          if (cart.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your cart is empty",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add some delicious items from the menu",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final item = cart[index];
                    return Card(
                      color: Colors.white,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        title: Text(
                          item.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          "₹${item.price} x ${item.quantity}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            cart.removeAt(index);
                            await CartHelper.saveCart(
                                cart); // Update cart after removal
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage(cart: cart)),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          if (cart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Total: ₹${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => _placeOrder(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC02626),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Place Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
