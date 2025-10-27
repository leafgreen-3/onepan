import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/data/recipe_loader.dart';
import 'package:onepan/models/recipe.dart';
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
    _future = loadRecipesFromAsset('assets/recipes.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dev: Recipes')),
      body: FutureBuilder<List<Recipe>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Failed to load recipes:\n${snapshot.error}', style: Theme.of(context).textTheme.bodyMedium),
            );
          }
          final recipes = snapshot.data ?? const <Recipe>[];
          if (recipes.isEmpty) {
            return const Center(child: Text('No recipes found'));
          }
          return ListView.separated(
            itemCount: recipes.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final r = recipes[index];
              return ListTile(
                title: Text(r.title, style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text('${r.minutes} min · ${r.servings} servings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('${Routes.devRecipeBase}/${r.id}', extra: r),
              );
            },
          );
        },
      ),
    );
  }
}

