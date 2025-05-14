import 'package:cafesmart/models/cartModel.dart';
import 'package:cafesmart/models/menuModel.dart';
import 'package:cafesmart/screens/introduction/pages/cartPage.dart';
import 'package:cafesmart/screens/menu/order_history.dart';
import 'package:cafesmart/utils/cartHelper.dart';
import 'package:flutter/material.dart';

// Import the OrderHistoryHelper

class MenuCarousel extends StatefulWidget {
  const MenuCarousel({super.key});

  @override
  _MenuCarouselState createState() => _MenuCarouselState();
}

class _MenuCarouselState extends State<MenuCarousel> {
  late PageController _pageController;
  TextEditingController _searchController = TextEditingController();
  List<CartItem> cart = [];

  List<MenuModel> menus = [
    MenuModel(
        title: "Chana Kulcha",
        subtitle: "Special",
        image: "assets/images/menu/kulcha.png",
        price: 35),
    MenuModel(
        title: "Pizza",
        subtitle: "Hot & Spicy",
        image: "assets/images/menu/pizza.png",
        price: 80),
    MenuModel(
        title: "Dosa",
        subtitle: "Refreshing",
        image: "assets/images/menu/dosa.png",
        price: 30),
    MenuModel(
        title: "Burger",
        subtitle: "Spicy",
        image: "assets/images/menu/burger.jpg",
        price: 30),
    MenuModel(
        title: "Aloo Patties",
        subtitle: "Hot & Spicy",
        image: "assets/images/menu/aloo-patties.jpg",
        price: 16),
    MenuModel(
        title: "Paneer Patties",
        subtitle: "Refreshing",
        image: "assets/images/menu/paneer-patties.jpg",
        price: 25),
    MenuModel(
        title: "Chowmein",
        subtitle: "Refreshing",
        image: "assets/images/menu/chowmein.png",
        price: 22),
  ];

  List<MenuModel> filteredMenus = [];
  // Add this variable to track active SnackBars
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _activeSnackBar;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    filteredMenus = menus;

    // Load the cart from SharedPreferences
    _loadCart();
    _searchController.addListener(_filterMenus);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load the cart from SharedPreferences
  void _loadCart() async {
    List<CartItem> savedCart = await CartHelper.loadCart();
    setState(() {
      cart = savedCart;
    });
  }

  void _filterMenus() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredMenus = menus
          .where((menu) =>
              menu.title.toLowerCase().contains(query) ||
              menu.subtitle.toLowerCase().contains(query))
          .toList();
    });
  }

  // Show a dialog to ask for the quantity
  void _showQuantityDialog(MenuModel menu) {
    int quantity = 1; // Start with quantity 1

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Quantity for ${menu.title}'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  Text(
                    '$quantity',
                    style: TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (quantity > 0) {
                      // Add the item to the cart with the specified quantity
                      _addToCart(menu, quantity);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Quantity must be at least 1")),
                      );
                    }
                  },
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Modified method to add items to cart and show SnackBar without Hero conflict
  void _addToCart(MenuModel menu, int quantity) async {
    setState(() {
      cart.add(
          CartItem(title: menu.title, price: menu.price, quantity: quantity));
    });

    // Save updated cart to SharedPreferences
    await CartHelper.saveCart(cart);
    
    // Dismiss any existing SnackBar before showing a new one
    if (_activeSnackBar != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    
    // Show success message and store the controller
    _activeSnackBar = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${menu.title} added to cart"),
        backgroundColor: Color(0xFFC02626),
        duration: Duration(seconds: 1),
        // Add a unique key to each SnackBar
        key: UniqueKey(),
      ),
    );
  }

  // Method to place an order (called when user checkout from cart page)
  void placeOrder() async {
    if (cart.isNotEmpty) {
      // Save the order to order history
      await OrderHistoryHelper.addOrder(List.from(cart));
      
      // Clear the cart
      setState(() {
        cart = [];
      });
      
      // Save empty cart to SharedPreferences
      await CartHelper.saveCart(cart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterMenus(),
              decoration: InputDecoration(
                hintText: "Search for items...",
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Menu List
          Expanded(
            child: ListView.builder(
              itemCount: filteredMenus.length,
              itemBuilder: (context, index) {
                final menu = filteredMenus[index];
                return Card(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            menu.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(menu.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text(menu.subtitle,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black)),
                              Text("₹${menu.price}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 68, 134, 70))),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _showQuantityDialog(
                              menu), // Show the quantity dialog
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFC02626),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: const Text("Add to Cart",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(
                cart: cart,
                onCheckout: placeOrder, // Pass the checkout callback
              ),
            ),
          );
        },
        backgroundColor: Color(0xFFC02626),
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
      ),
    );
  }
}