import 'package:cafesmart/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(const Routing());
}
