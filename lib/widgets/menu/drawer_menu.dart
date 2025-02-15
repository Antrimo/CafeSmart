import 'package:cafesmart/constants/color.dart';
import 'package:cafesmart/screens/menu/about_us_screen.dart';
import 'package:cafesmart/screens/menu/profile_screen.dart';
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
        baseStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        colorLineSelected: Colors.deepPurple,
        selectedStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const Navbar(),
    ),
    ScreenHiddenDrawer(
      ItemHiddenMenu(
        name: "Profile",
        baseStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        colorLineSelected: Colors.deepPurple,
        selectedStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const ProfileScreen(),
    ),
    ScreenHiddenDrawer(
      ItemHiddenMenu(
        name: "About Us",
        baseStyle: TextStyle(color: Colors.white, fontSize: 20.0),
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
      backgroundColorMenu: Colors.brown,
      slidePercent: 60.0,
      contentCornerRadius: 15.0,
      disableAppBarDefault: false,
    );
  }
}
