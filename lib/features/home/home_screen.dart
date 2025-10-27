import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'OnePan',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => context.push(Routes.devRecipes),
              child: const Text('Dev: View Recipes'),
            ),
          ],
        ),
      ),
    );
  }
}

