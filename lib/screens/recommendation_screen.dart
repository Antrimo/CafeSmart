import 'package:cafesmart/background.dart';
import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> recommendations = [
      {
        "title": "Dosa with Coconut Chutney",
        "description": "Crispy dosa served with flavorful coconut chutney.",
        "image": "assets/images/menu/dosa.png"
      },
      {
        "title": "Classic Margherita Pizza + Coke",
        "description":
            "Simple yet delicious pizza with fresh basil, cheese, and a chilled Coke.",
        "image": "assets/images/menu/pizza.png"
      },
      {
        "title": "Chana Kulcha with Lassi",
        "description":
            "A perfect North Indian combo of spiced chana with soft kulchas and a refreshing lassi.",
        "image": "assets/images/menu/kulcha.png"
      },
      {
        "title": "Chowmin with tea",
        "description":
            "Creamy pasta served with a side of crispy garlic bread.",
        "image": "assets/images/menu/chwomin.png"
      },
      {
        "title": "Burger + Cold Drink",
        "description":
            "A juicy burger paired with crispy fries and a refreshing cold drink.",
        "image": "assets/images/menu/burger.jpg"
      },
      {
        "title": "Aloo patties",
        "description": "Allo pattie",
        "image": "assets/images/menu/aloo-patties.jpg"
      },
    ];

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Background(),
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final food = recommendations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Image.asset(
                      food["image"]!,
                      width: 60,
                      height: 60,
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
