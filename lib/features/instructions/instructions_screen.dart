import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/ingredient.dart' as v1i;
import 'package:onepan/features/ingredients/state/selected_ingredients_provider.dart'
    as picked;
import 'package:onepan/features/recipe/recipe_providers.dart';
import 'package:onepan/features/recipe/recipe_mode.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/empty_state.dart';

class InstructionsScreen extends ConsumerWidget {
  const InstructionsScreen({super.key, required this.recipeId, required this.mode});

  final String recipeId;
  final RecipeMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeByIdProvider(recipeId));
    final scheme = Theme.of(context).colorScheme;

    return recipeAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          backgroundColor: scheme.surface,
          elevation: AppElevation.e0,
          iconTheme: IconThemeData(color: scheme.onSurface),
          title: Text('Loading...', style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        appBar: AppBar(
          backgroundColor: scheme.surface,
          elevation: AppElevation.e0,
          iconTheme: IconThemeData(color: scheme.onSurface),
          title: Text('Recipe', style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Failed to load recipe.'),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () => ref.refresh(recipeByIdProvider(recipeId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (recipe) {
        if (recipe == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: scheme.surface,
              elevation: AppElevation.e0,
              iconTheme: IconThemeData(color: scheme.onSurface),
              title: Text('Recipe', style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
              centerTitle: true,
            ),
            body: const EmptyState(
              icon: Icons.local_dining,
              message: 'Recipe not found.',
            ),
          );
        }

        final ingredientsTabLabel =
            'Ingredients${mode == RecipeMode.ai ? ' (AI)' : ''}';

        final pickedIds = ref.watch(picked.selectedIngredientIdsProvider(recipeId));
        final bool isAi = mode == RecipeMode.ai;
        final List<v1i.Ingredient> visibleIngredients = (isAi && pickedIds.isNotEmpty)
            ? [
                for (final ing in recipe.ingredients)
                  if (pickedIds.contains(ing.id)) ing,
              ]
            : recipe.ingredients;
        final bool showAiBanner = isAi && pickedIds.isEmpty;

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: scheme.surface,
              elevation: AppElevation.e0,
              iconTheme: IconThemeData(color: scheme.onSurface),
              title: Text(
                recipe.title,
                style: AppTextStyles.title.copyWith(color: scheme.onSurface),
              ),
              centerTitle: true,
              actions: [
                if (isAi)
                  TextButton(
                    key: const Key('clear_picks_button'),
                    onPressed: () {
                      ref
                          .read(picked
                              .selectedIngredientIdsProvider(recipeId)
                              .notifier)
                          .state = <String>{};
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Picks cleared'),
                          duration: AppDurations.fast,
                        ),
                      );
                    },
                    child: Text(
                      'Clear picks',
                      style:
                          AppTextStyles.label.copyWith(color: scheme.primary),
                    ),
                  ),
              ],
              bottom: TabBar(
                indicatorColor: scheme.primary,
                tabs: [
                  Tab(text: ingredientsTabLabel),
                  const Tab(text: 'Recipe'),
                ],
              ),
            ),
            body: TabBarView(children: [
              _IngredientsTab(
                ingredients: visibleIngredients,
                showAiBanner: showAiBanner,
              ),
              _StepsTab(recipe: recipe),
            ]),
          ),
        );
      },
    );
  }
}

class _IngredientsTab extends StatelessWidget {
  const _IngredientsTab({
    required this.ingredients,
    required this.showAiBanner,
  });
  final List<v1i.Ingredient> ingredients;
  final bool showAiBanner;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (ingredients.isEmpty) {
      return const EmptyState(
        icon: Icons.shopping_basket_outlined,
        message: 'No ingredients available.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      itemBuilder: (context, index) {
        if (index == 0 && showAiBanner) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              'AI mode active: showing full list (no picks found).',
              style: AppTextStyles.label.copyWith(
                color: scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
              ),
            ),
          );
        }
        final item = ingredients[index - (showAiBanner ? 1 : 0)];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ThumbOrPlaceholder(ing: item),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTextStyles.body.copyWith(color: scheme.onSurface)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${item.qty} ${item.unit}',
                    style: AppTextStyles.label.copyWith(
                      color: scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemCount: ingredients.length + (showAiBanner ? 1 : 0),
    );
  }
}

class _StepsTab extends StatelessWidget {
  const _StepsTab({required this.recipe});
  final v1.Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final steps = recipe.steps;
    if (steps.isEmpty) {
      return const EmptyState(
        icon: Icons.menu_book_outlined,
        message: 'No steps available.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      itemBuilder: (context, index) {
        final step = steps[index];
        return Row(
          key: Key('step_${step.num}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: scheme.primary,
              child: Text(
                '${step.num}',
                style: AppTextStyles.label.copyWith(color: scheme.onPrimary),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.text, style: AppTextStyles.body.copyWith(color: scheme.onSurface)),
                  if (step.timerSec != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${step.timerSec} sec',
                            style: AppTextStyles.label.copyWith(color: scheme.onSurface),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemCount: steps.length,
    );
  }
}

class _ThumbOrPlaceholder extends StatelessWidget {
  const _ThumbOrPlaceholder({required this.ing});
  final v1i.Ingredient ing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const double size = AppSizes.minTouchTarget;
    final border = BorderRadius.circular(AppRadii.md);

    Widget placeholder() => Container(
          key: Key('ing_thumb_placeholder_${ing.id}'),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: border,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.image_outlined,
            size: AppSizes.icon,
            color: scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
          ),
        );

    final asset = ing.thumbAsset;
    final url = ing.thumbUrl;

    if (asset != null && asset.isNotEmpty) {
      return ClipRRect(
        borderRadius: border,
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder(),
        ),
      );
    }
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: border,
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder(),
        ),
      );
    }

    return placeholder();
  }
}

