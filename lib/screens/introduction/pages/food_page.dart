import 'package:cafesmart/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Choose your favorite food",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Center(
            child: Lottie.asset(
              'assets/animations/intro1.json',
              width: 400,
            ),
          ),
        ],
      ),
    );
  }
}
