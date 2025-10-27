import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/di/locator.dart';
import 'package:onepan/models/recipe.dart';
import 'package:onepan/models/substitution.dart';
import 'package:onepan/repository/recipe_repository.dart';
import 'package:onepan/repository/substitution_repository.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';

class RecipesListScreen extends StatefulWidget {
  const RecipesListScreen({super.key});

  @override
  State<RecipesListScreen> createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends State<RecipesListScreen> {
  late Future<List<Recipe>> _future;

  @override
  void initState() {
    super.initState();
    _future = locator<RecipeRepository>().list();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: _future,
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        final recipes = snapshot.data ?? const <Recipe>[];
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dev: Recipes'),
            actions: [
              if (kDebugMode && recipes.isNotEmpty)
                IconButton(
                  tooltip: 'Debug substitutions',
                  icon: const Icon(Icons.science),
                  onPressed: () => _showDebugSubstitutions(recipes.first),
                ),
            ],
          ),
          body: () {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text('Failed to load recipes:\n${snapshot.error}', style: theme.textTheme.bodyMedium),
              );
            }
            if (recipes.isEmpty) {
              return const Center(child: Text('No recipes found'));
            }
            return ListView.separated(
              itemCount: recipes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final r = recipes[index];
                return ListTile(
                  title: Text(r.title, style: theme.textTheme.titleMedium),
                  subtitle: Text('${r.minutes} min • ${r.servings} servings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('${Routes.devRecipeBase}/${r.id}', extra: r),
                );
              },
            );
          }(),
        );
      },
    );
  }

  Future<void> _showDebugSubstitutions(Recipe recipe) async {
    if (!kDebugMode) return;
    final subsRepo = locator<SubstitutionRepository>();
    final req = SubstitutionRequest(
      recipeId: recipe.id,
      params: <String, Object?>{
        'servings': recipe.servings,
        'time': recipe.minutes,
        'spice': recipe.spice.name,
      },
      availableIds: const <String>['pan', 'knife', 'salt'],
      missingIds: const <String>['butter'],
    );
    try {
      final resp = await subsRepo.substitute(req);
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (ctx) {
          final t = Theme.of(ctx).textTheme;
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Substitutions for "${recipe.title}"', style: t.titleMedium),
                const SizedBox(height: AppSpacing.md),
                if (resp.substitutions.isEmpty)
                  const Text('No substitutions proposed (mock)'),
                if (resp.substitutions.isNotEmpty)
                  ...resp.substitutions.map((s) => Text('• ${s.from} → ${s.to} (${s.note})')),
                const SizedBox(height: AppSpacing.md),
                Text('Final ingredients (${resp.finalIngredients.length}):', style: t.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: resp.finalIngredients
                      .map((ing) => Chip(label: Text(ing)))
                      .toList(growable: false),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Substitution error: $e')),
      );
    }
  }
}

