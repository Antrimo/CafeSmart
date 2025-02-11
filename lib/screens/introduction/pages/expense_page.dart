import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/color.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Track your expenses",
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
              'assets/animations/intro2.json',
              width: 400,
            ),
          ),
        ],
      ),
    );
  }
}
