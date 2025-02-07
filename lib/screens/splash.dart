import 'package:cafesmart/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Navbar(),
              ),
            );
          },
          child: Lottie.asset(
            'assets/splash.json',
          ),
        ),
      ),
    );
  }
}
