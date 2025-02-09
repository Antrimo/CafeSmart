import 'package:cafesmart/screens/about_us_screen.dart';
import 'package:cafesmart/screens/profile_screen.dart';
import 'package:cafesmart/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  List<ScreenHiddenDrawer> items = [
    ScreenHiddenDrawer(
      ItemHiddenMenu(
        name: "CaféSmart",
        baseStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 20.0),
        colorLineSelected: Colors.deepPurple,
        selectedStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const Navbar(),
    ),
    ScreenHiddenDrawer(
      ItemHiddenMenu(
        name: "Profile",
        baseStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 20.0),
        colorLineSelected: Colors.deepPurple,
        selectedStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const ProfileScreen(),
    ),
    ScreenHiddenDrawer(
      ItemHiddenMenu(
        name: "About Us",
        baseStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 20.0),
        colorLineSelected: Colors.deepPurple,
        selectedStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const AboutUsScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      screens: items,
      backgroundColorMenu: Colors.deepPurple,
      slidePercent: 60.0,
      contentCornerRadius: 15.0,
      disableAppBarDefault: false,
    );
  }
}
