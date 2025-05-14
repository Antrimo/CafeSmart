import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cafesmart/models/cartModel.dart';
import 'package:cafesmart/models/menuModel.dart';
import 'package:cafesmart/utils/cartHelper.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<FrequentOrderItem> _frequentOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
  }

  Future<void> _loadOrderHistory() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      List<FrequentOrderItem> orders = await OrderHistoryHelper.loadFrequentOrders();
      
      setState(() {
        _frequentOrders = orders;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading order history: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addToCart(FrequentOrderItem order) async {
    List<CartItem> currentCart = await CartHelper.loadCart();
    
    // Add all items from the frequent order to the cart
    for (var item in order.items) {
      currentCart.add(CartItem(
        title: item.title,
        price: item.price,
        quantity: item.quantity,
      ));
    }
    
    // Save the updated cart
    await CartHelper.saveCart(currentCart);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${order.items.length} items to cart'),
        backgroundColor: Color(0xFFC02626),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order History",
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFC02626),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _frequentOrders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "No order history yet",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your frequent orders will appear here",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _frequentOrders.length,
                  padding: EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final order = _frequentOrders[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Row(
                              children: [
                                Text(
                                  "Order #${index + 1}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC02626),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Ordered ${order.orderCount} times",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12),
                                Text(
                                  "Total: ₹${order.getTotalPrice().toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green[700],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Last ordered: ${order.lastOrderedDate ?? 'Unknown'}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _addToCart(order),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFC02626),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              child: Text(
                                "Reorder",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Divider(height: 0),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: order.items.length,
                            itemBuilder: (context, itemIndex) {
                              final item = order.items[itemIndex];
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                title: Text(
                                  item.title,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text("₹${item.price} × ${item.quantity}"),
                                trailing: Text(
                                  "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class FrequentOrderItem {
  final List<CartItem> items;
  final int orderCount;
  final String? lastOrderedDate;

  FrequentOrderItem({
    required this.items,
    required this.orderCount,
    this.lastOrderedDate,
  });

  // Calculate total price of all items in the order
  double getTotalPrice() {
    double total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // From JSON for SharedPreferences
  factory FrequentOrderItem.fromJson(Map<String, dynamic> json) {
    return FrequentOrderItem(
      items: (json['items'] as List)
          .map((item) => CartItem(
                title: item['title'],
                price: item['price'],
                quantity: item['quantity'],
              ))
          .toList(),
      orderCount: json['orderCount'],
      lastOrderedDate: json['lastOrderedDate'],
    );
  }

  // To JSON for SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => {
            'title': item.title,
            'price': item.price,
            'quantity': item.quantity,
          }).toList(),
      'orderCount': orderCount,
      'lastOrderedDate': lastOrderedDate,
    };
  }
}

// Helper class to manage order history
class OrderHistoryHelper {
  static const String _frequentOrdersKey = 'frequent_orders';

  // Load frequent orders from SharedPreferences
  static Future<List<FrequentOrderItem>> loadFrequentOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedOrders = prefs.getStringList(_frequentOrdersKey);

    if (storedOrders == null || storedOrders.isEmpty) {
      return [];
    }

    List<FrequentOrderItem> orders = storedOrders.map((orderStr) {
      Map<String, dynamic> orderMap = json.decode(orderStr);
      return FrequentOrderItem.fromJson(orderMap);
    }).toList();

    // Sort by order count (most frequent first)
    orders.sort((a, b) => b.orderCount.compareTo(a.orderCount));
    
    return orders;
  }

  // Save frequent orders to SharedPreferences
  static Future<void> saveFrequentOrders(List<FrequentOrderItem> orders) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> serializedOrders = orders.map((order) => json.encode(order.toJson())).toList();
    await prefs.setStringList(_frequentOrdersKey, serializedOrders);
  }

  // Add a new order to history
  static Future<void> addOrder(List<CartItem> items) async {
    if (items.isEmpty) return;

    // Format current date
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}/${now.month}/${now.year}";

    List<FrequentOrderItem> existingOrders = await loadFrequentOrders();
    
    // Check if this exact order combination exists
    bool orderExists = false;
    
    for (int i = 0; i < existingOrders.length; i++) {
      if (_areOrdersEqual(existingOrders[i].items, items)) {
        // Update existing order
        existingOrders[i] = FrequentOrderItem(
          items: items,
          orderCount: existingOrders[i].orderCount + 1,
          lastOrderedDate: formattedDate,
        );
        orderExists = true;
        break;
      }
    }

    if (!orderExists) {
      // Add as new order
      existingOrders.add(FrequentOrderItem(
        items: items,
        orderCount: 1,
        lastOrderedDate: formattedDate,
      ));
    }

    // Sort by frequency and save
    existingOrders.sort((a, b) => b.orderCount.compareTo(a.orderCount));
    
    // Keep only top 20 frequent orders
    if (existingOrders.length > 20) {
      existingOrders = existingOrders.sublist(0, 20);
    }
    
    await saveFrequentOrders(existingOrders);
  }

  // Helper method to check if two orders have the same items
  static bool _areOrdersEqual(List<CartItem> order1, List<CartItem> order2) {
    if (order1.length != order2.length) return false;
    
    // Create a map of items from order1 for efficient lookup
    Map<String, CartItem> order1Map = {};
    for (var item in order1) {
      order1Map[item.title] = item;
    }
    
    // Check if all items in order2 match items in order1
    for (var item2 in order2) {
      if (!order1Map.containsKey(item2.title)) return false;
      
      CartItem item1 = order1Map[item2.title]!;
      if (item1.quantity != item2.quantity || item1.price != item2.price) {
        return false;
      }
    }
    
    return true;
  }
}