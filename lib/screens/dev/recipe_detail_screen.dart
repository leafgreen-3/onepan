import 'package:flutter/material.dart';

import 'package:onepan/models/recipe.dart';
import 'package:onepan/theme/tokens.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  String get _spiceLabel => switch (recipe.spice) {
        SpiceLevel.mild => 'Mild',
        SpiceLevel.medium => 'Medium',
        SpiceLevel.hot => 'Hot',
        SpiceLevel.inferno => 'Inferno',
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.subtitle != null && recipe.subtitle!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(recipe.subtitle!, style: theme.textTheme.titleMedium),
              ),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: [
                _StatChip(label: 'Minutes', value: '${recipe.minutes}'),
                _StatChip(label: 'Servings', value: '${recipe.servings}'),
                _StatChip(label: 'Spice', value: _spiceLabel),
                _StatChip(label: 'Ingredients', value: '${recipe.ingredients.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: scheme.primaryContainer,
      side: BorderSide(color: scheme.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
    );
  }
}

