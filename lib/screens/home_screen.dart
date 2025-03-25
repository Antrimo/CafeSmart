import 'package:cafesmart/screens/menu_screen.dart';
import 'package:flutter/material.dart';

import '../background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [Background(), MenuCarousel()],
      ),
    );
  }
}

class menuText extends StatelessWidget {
  const menuText({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 500.0), // Adjusted position for menu text
      child: Center(
        child: Text(
          "Menu",
          style: TextStyle(fontSize: screenWidth * 0.16, color: Colors.white),
        ),
      ),
    );
  }
}
