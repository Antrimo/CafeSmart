import 'package:cafesmart/background.dart';
import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final List<Map<String, String>> recommendations = [
      {
        "title": "Pizza + Coke",
        "description":
            "A classic combo! Enjoy a cheesy, oven-fresh pizza with a chilled Coke for the perfect bite.",
        "image": "assets/images/menu/pizza.png"
      },
      {
        "title": "Dosa with Coconut Chutney",
        "description":
            "Golden crispy dosa paired with smooth, mildly sweet coconut chutney—South Indian delight at its best!",
        "image": "assets/images/menu/dosa.png"
      },
      {
        "title": "Chana Kulcha with Lassi",
        "description":
            "Spiced, flavorful chana served with soft kulchas, perfectly complemented by a creamy, chilled lassi.",
        "image": "assets/images/menu/kulcha.png"
      },
      {
        "title": "Chowmein with Tea",
        "description":
            "A fusion of flavors! Enjoy spicy, stir-fried chowmein alongside a warm cup of chai for a comforting meal.",
        "image": "assets/images/menu/chowmein.png"
      },
      {
        "title": "Paneer Patties",
        "description":
            "Crispy on the outside, stuffed with spicy paneer filling inside—a snack that’s both crunchy and creamy!",
        "image": "assets/images/menu/paneer-patties.jpg"
      },
      {
        "title": "Burger + Cold Drink",
        "description":
            "A juicy, cheesy burger served with crispy fries and a refreshing cold drink—an all-time favorite combo!",
        "image": "assets/images/menu/burger.jpg"
      },
      {
        "title": "Aloo Patties",
        "description":
            "A perfect tea-time snack! Mashed potato filling seasoned with spices, wrapped in a crispy golden crust.",
        "image": "assets/images/menu/aloo-patties.jpg"
      },
    ];

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Background(),
            ListView.builder(
              padding: EdgeInsets.all(screenWidth * 0.0301),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final food = recommendations[index];
                return Card(
                  margin: EdgeInsets.only(bottom: screenWidth * 0.035),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(screenWidth * 0.03),
                    leading: Image.asset(
                      food["image"]!,
                      width: screenWidth * 0.24,
                      height: screenWidth * 0.24,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      food["title"]!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      food["description"]!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
