import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/color.dart';

class RecommendPage extends StatelessWidget {
  const RecommendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Recommendation for you",
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
              'assets/animations/intro3.json',
              width: 400,
            ),
          ),
        ],
      ),
    );
  }
}
