import 'package:cafesmart/firebase_options.dart';
import 'package:cafesmart/routing/routing.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(const Routing());
}
