import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What is CaféSmart?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              const SizedBox(height: 10),
              const Text(
                "CaféSmart is a smart cafeteria solution designed to simplify ordering and budget tracking for college students and staff. "
                "With features like menu browsing, personalized food suggestions, and expense tracking, it enhances the overall dining experience.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                "Why CaféSmart?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              const SizedBox(height: 10),
              const Text(
                "- Difficulty in tracking expenses and setting limits\n"
                "- No meal suggestions based on remaining budget\n"
                "- Menu changes not easily accessible\n"
                "- No seat reservation system for staff\n"
                "- Manual effort needed to view daily menu\n",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                "Built With",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              const SizedBox(height: 10),
              const Text(
                "• Flutter for frontend\n"
                "• Firebase & Spring Boot for backend\n"
                "• MySQL for database\n"
                "• Designed using Figma\n",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                "Vision",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              const SizedBox(height: 10),
              const Text(
                "To create a seamless cafeteria experience with digital ordering, personalized food recommendations, "
                "and effective budget management for both students and staff.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
