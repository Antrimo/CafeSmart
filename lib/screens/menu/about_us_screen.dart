import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "About Us",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
      ),
    );
  }
}
