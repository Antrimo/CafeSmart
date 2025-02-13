import 'package:cafesmart/screens/expense_screen.dart';
import 'package:cafesmart/screens/home_screen.dart';
import 'package:cafesmart/screens/recommendation_screen.dart';
import 'package:cafesmart/widgets/menu/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    RecommendationScreen(),
    ExpenseScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      drawer: DrawerMenu(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFFC02626),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Color(0xFFC02626),
            ),
          ],
        ),
        child: GNav(
          backgroundColor: Color(0xFFC02626),
          color: Colors.black,
          activeColor: Colors.black,
          // tabBackgroundColor: Colors.grey.shade800,
          tabBackgroundColor: Colors.white,
          gap: 8,
          padding: const EdgeInsets.all(16),
          onTabChange: _onItemTapped,
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.search, text: 'Recommendation'),
            GButton(icon: Icons.person, text: 'Expense'),
          ],
        ),
      ),
    );
  }
}
