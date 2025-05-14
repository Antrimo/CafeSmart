import 'package:cafesmart/models/cartModel.dart';
import 'package:cafesmart/screens/menu/order_history.dart';
import 'package:cafesmart/utils/cartHelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import OrderHistoryHelper

class CartPage extends StatefulWidget {
  final List<CartItem> cart;
  final Function? onCheckout; // Optional callback for parent widgets

  const CartPage({Key? key, required this.cart, this.onCheckout}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartItem> _cart;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _cart = List.from(widget.cart); // Create a copy of the cart
  }

  // Method to place an order
  Future<void> _placeOrder(BuildContext context) async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your cart is empty")),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    double totalAmount = 0.0;
    _cart.forEach((item) {
      totalAmount += item.price * item.quantity;
    });

    // Get the current budget
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double currentBudget = prefs.getDouble('budget') ?? 0.0;

    if (currentBudget < totalAmount) {
      setState(() {
        _isProcessing = false;
      });
      
      // Notify user about insufficient budget
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Insufficient Budget",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              "You don't have enough budget (₹${currentBudget.toStringAsFixed(2)}) for this order (₹${totalAmount.toStringAsFixed(2)}).",
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

    try {
      // Save order to history before updating anything else
      await OrderHistoryHelper.addOrder(List.from(_cart));
      
      // Deduct from budget
      double newBudget = currentBudget - totalAmount;
      await prefs.setDouble('budget', newBudget);

      // Save the order as an expense
      List<String> expenses = prefs.getStringList('expenses') ?? [];
      expenses.add('Food Order|${totalAmount.toStringAsFixed(2)}');
      await prefs.setStringList('expenses', expenses);

      // Clear the cart
      await CartHelper.saveCart([]);
      
      // Call the onCheckout callback if provided
      if (widget.onCheckout != null) {
        widget.onCheckout!();
      }

      setState(() {
        _cart = [];
        _isProcessing = false;
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Order Placed Successfully",
              style: TextStyle(color: Color(0xFFC02626)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  "Your total is ₹${totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text("Remaining budget: ₹${newBudget.toStringAsFixed(2)}"),
                SizedBox(height: 16),
                Text(
                  "Your order has been saved to your order history!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Go back to menu screen
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error placing order: $e")),
      );
    }
  }

  // Method to update cart item quantity
  Future<void> _updateQuantity(int index, int newQuantity) async {
    if (newQuantity <= 0) {
      // Remove item if quantity is zero or negative
      setState(() {
        _cart.removeAt(index);
      });
    } else {
      // Update quantity
      setState(() {
        _cart[index] = CartItem(
          title: _cart[index].title,
          price: _cart[index].price,
          quantity: newQuantity,
        );
      });
    }
    
    // Save updated cart
    await CartHelper.saveCart(_cart);
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;
    _cart.forEach((item) {
      totalAmount += item.price * item.quantity;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFC02626),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFC02626)),
                  SizedBox(height: 16),
                  Text("Processing your order..."),
                ],
              ),
            )
          : Column(
              children: [
                if (_cart.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
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
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFC02626),
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Return to Menu',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListView.builder(
                        itemCount: _cart.length,
                        itemBuilder: (context, index) {
                          final item = _cart[index];
                          return Card(
                            color: Colors.white,
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "₹${item.price.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 68, 134, 70),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove_circle),
                                        color: Color(0xFFC02626),
                                        onPressed: () => _updateQuantity(index, item.quantity - 1),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${item.quantity}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add_circle),
                                        color: Color(0xFFC02626),
                                        onPressed: () => _updateQuantity(index, item.quantity + 1),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _updateQuantity(index, 0),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                if (_cart.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 68, 134, 70),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _placeOrder(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFC02626),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Place Order",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}