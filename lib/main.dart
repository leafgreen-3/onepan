import 'package:flutter/material.dart';

void main() {
  runApp(const OnePanApp());
}

class OnePanApp extends StatelessWidget {
  const OnePanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnePan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const OnePanHomePage(),
    );
  }
}

class OnePanHomePage extends StatelessWidget {
  const OnePanHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'OnePan',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
