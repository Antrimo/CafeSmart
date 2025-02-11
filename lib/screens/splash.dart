import 'package:cafesmart/screens/app_introduction_screen.dart';
import 'package:cafesmart/widgets/menu/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/navbar/navbar.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const (),
            //   ),
            // );
          },
          child: Lottie.asset(
            'assets/splash.json',
          ),
        ),
      ),
    );
  }
}
