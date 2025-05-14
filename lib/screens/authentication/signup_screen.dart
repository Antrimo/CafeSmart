import 'package:cafesmart/screens/authentication/auth.dart';
import 'package:cafesmart/utils/mytextfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/color.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.person, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to CaféSmart",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                MyTextfield(
                  hintText: "Enter your name",
                  obscureText: false,
                  controller: nameController,
                ),
                const SizedBox(height: 15),
                MyTextfield(
                  hintText: "Enter your email",
                  obscureText: false,
                  controller: emailController,
                ),
                const SizedBox(height: 15),
                MyTextfield(
                  hintText: "Enter your password",
                  obscureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final user = await AuthService().signUp(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          nameController.text.trim(),
                        );
                        if (user != null) {
                          context.go('/home');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: ColorConstants.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
