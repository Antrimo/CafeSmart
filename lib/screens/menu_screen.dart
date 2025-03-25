import 'package:cafesmart/models/menuModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuCarousel extends StatefulWidget {
  const MenuCarousel({super.key});

  @override
  _MenuCarouselState createState() => _MenuCarouselState();
}

class _MenuCarouselState extends State<MenuCarousel> {
  late PageController _pageController;
  TextEditingController _searchController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    filteredMenus = menus;
    _searchController.addListener(_filterMenus);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  Future<void> placeOrder(String title, int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double budget = prefs.getDouble('budget') ?? 0.0;

    if (amount > budget) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Insufficient Budget"),
            content: const Text(
              "You do not have enough budget to place this order.",
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

    // Deduct amount and save
    budget -= amount;
    await prefs.setDouble('budget', budget);

    List<String> expenses = prefs.getStringList('expenses') ?? [];
    expenses.add('$title|$amount');
    await prefs.setStringList('expenses', expenses);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Order Placed"),
          content: Text("$title ordered successfully!  ₹$amount deducted."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _searchController,
            onChanged: (value) =>
                _filterMenus(), // Calls filter function on each keystroke
            decoration: InputDecoration(
              hintText: "Search for items...",
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: Colors.white, // White background
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none, // No border outline
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
                    const EdgeInsets.symmetric(vertical: 10.01, horizontal: 16),
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
                            Text(
                              menu.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              menu.subtitle,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              "₹${menu.price}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white, // Set background color to white
                          ),
                          onPressed: () => placeOrder(menu.title, menu.price),
                          child: const Text(
                            "Order",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
