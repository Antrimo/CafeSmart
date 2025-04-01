import 'package:flutter/material.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "OrderHistory",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
      ),
    );
  }
}
