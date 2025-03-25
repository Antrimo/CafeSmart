import 'package:flutter/material.dart';

import '../constants/image.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity, // Ensures the container takes the full width
        height: double.infinity, // Ensures the container takes the full height
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageManager.background),
            fit: BoxFit.cover, // Ensures the image covers the entire area
          ),
        ),
      ),
    );
  }
}