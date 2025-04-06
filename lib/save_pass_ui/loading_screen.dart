import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 32),
      body: Center(
        child: Text(
          'Save Pass',
          style: TextStyle(
              color: Colors.green, fontSize: 40, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}