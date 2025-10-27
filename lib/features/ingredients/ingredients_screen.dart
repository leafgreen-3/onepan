import 'package:flutter/material.dart';

class IngredientsScreen extends StatelessWidget {
  const IngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Ingredients',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

