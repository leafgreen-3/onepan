import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: AppElevation.e0,
        iconTheme: IconThemeData(color: scheme.onSurface),
        title: Text(
          'Recipe',
          style: AppTextStyles.title.copyWith(color: scheme.onSurface),
        ),
      ),
      body: const Center(
        child: Text(
          'Recipe',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

