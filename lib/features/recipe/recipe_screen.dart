import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/ingredient.dart';
import 'package:onepan/features/recipe/recipe_providers.dart';
import 'package:onepan/theme/tokens.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key});

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id']!;
    final recipeAsync = ref.watch(recipeByIdProvider(id));
    final scheme = Theme.of(context).colorScheme;

    final titleText = recipeAsync.when(
      data: (r) => r?.title ?? 'Recipe',
      loading: () => 'Loading…',
      error: (_, __) => 'Recipe',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: AppElevation.e0,
        iconTheme: IconThemeData(color: scheme.onSurface),
        title: Text(
          titleText,
          style: AppTextStyles.title.copyWith(color: scheme.onSurface),
        ),
      ),
      body: recipeAsync.when(
        loading: () => const _LoadingState(),
        error: (e, st) => _ErrorState(onRetry: () => ref.refresh(recipeByIdProvider(id))),
        data: (recipe) {
          if (recipe == null) {
            return const _ErrorState(onRetry: null);
          }
          return _RecipeContent(recipe: recipe);
        },
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Failed to load recipe.'),
          const SizedBox(height: AppSpacing.md),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}

class _RecipeContent extends StatelessWidget {
  const _RecipeContent({required this.recipe});
  final v1.Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Header image (fixed height to avoid overflow on small viewports)
        SizedBox(
          height: 240,
          child: _RecipeImage(title: recipe.title, imageAsset: recipe.imageAsset, imageUrl: recipe.imageUrl),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.title,
                key: const Key('recipe_title'),
                style: AppTextStyles.headline.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _TimeBadge(minutes: recipe.timeTotalMin),
                  const SizedBox(width: AppSpacing.md),
                  _DietChip(diet: recipe.diet),
                ],
              ),
            ],
          ),
        ),
        Expanded(child: _IngredientsList(recipe: recipe)),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('next_button'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _StepsScreen(recipe: recipe),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.title, required this.imageAsset, required this.imageUrl});
  final String title;
  final String imageAsset;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (imageAsset.isNotEmpty) {
      return Image.asset(
        imageAsset,
        fit: BoxFit.cover,
        semanticLabel: 'Recipe image: $title',
        errorBuilder: (_, __, ___) => _PlaceholderImage(colorScheme: scheme),
      );
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        semanticLabel: 'Recipe image: $title',
        errorBuilder: (_, __, ___) => _PlaceholderImage(colorScheme: scheme),
      );
    }
    return _PlaceholderImage(colorScheme: scheme);
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh),
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          size: AppSizes.icon,
          color: colorScheme.onSurface.withValues(alpha: AppOpacity.mediumText),
        ),
      ),
    );
  }
}

class _TimeBadge extends StatelessWidget {
  const _TimeBadge({required this.minutes});
  final int minutes;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: scheme.surface.withValues(alpha: AppOpacity.focus),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        child: Text('$minutes min', style: AppTextStyles.label.copyWith(color: scheme.onSurface)),
      ),
    );
  }
}

class _DietChip extends StatelessWidget {
  const _DietChip({required this.diet});
  final String diet;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: scheme.surface.withValues(alpha: AppOpacity.focus),
        shape: StadiumBorder(side: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        child: Text(diet, style: AppTextStyles.label.copyWith(color: scheme.onSurface)),
      ),
    );
  }
}

class _IngredientsList extends StatelessWidget {
  const _IngredientsList({required this.recipe});
  final v1.Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xl),
      itemBuilder: (context, index) {
        final ing = recipe.ingredients[index];
        return _IngredientTile(ingredient: ing);
      },
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemCount: recipe.ingredients.length,
    );
  }
}

class _IngredientTile extends StatefulWidget {
  const _IngredientTile({required this.ingredient});
  final Ingredient ingredient;
  @override
  State<_IngredientTile> createState() => _IngredientTileState();
}

class _IngredientTileState extends State<_IngredientTile> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) {
    final ing = widget.ingredient;
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        key: Key('ingredient_tile_${ing.id}'),
        onTap: () => setState(() => _checked = !_checked),
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Thumbnail (if provided) or placeholder
              _IngredientThumb(thumbAsset: ing.thumbAsset),
              const SizedBox(width: AppSpacing.md),
              // Name on the left
              Expanded(
                child: Text(
                  ing.name,
                  style: AppTextStyles.body.copyWith(color: scheme.onSurface),
                ),
              ),
              // Quantity on the right
              Text(
                '${ing.qty} ${ing.unit}',
                style: AppTextStyles.label.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(width: AppSpacing.md),
              // Checkbox after quantity
              Checkbox(
                value: _checked,
                onChanged: (_) => setState(() => _checked = !_checked),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientThumb extends StatelessWidget {
  const _IngredientThumb({this.thumbAsset});
  final String? thumbAsset;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(Icons.image_outlined, size: 16, color: scheme.onSurface.withValues(alpha: AppOpacity.mediumText)),
    );

    if (thumbAsset == null || thumbAsset!.isEmpty) {
      return placeholder;
    }
    return ClipOval(
      child: Image.asset(
        thumbAsset!,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      ),
    );
  }
}

class _StepsList extends StatelessWidget {
  const _StepsList({required this.recipe});
  final v1.Recipe recipe;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xl),
      itemBuilder: (context, index) {
        final step = recipe.steps[index];
        return Row(
          key: Key('step_${step.num}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: scheme.primary,
              child: Text('${step.num}', style: AppTextStyles.label.copyWith(color: scheme.onPrimary)),
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
                      child: Row(children: [
                        const Text('⏱ '),
                        Text('${step.timerSec} sec', style: AppTextStyles.label.copyWith(color: scheme.onSurface)),
                      ]),
                    ),
                ],
              ),
            ),
          ],
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemCount: recipe.steps.length,
    );
  }
}

class _StepsScreen extends StatelessWidget {
  const _StepsScreen({required this.recipe});
  final v1.Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: AppElevation.e0,
        iconTheme: IconThemeData(color: scheme.onSurface),
        title: Text('Steps', style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
      ),
      body: _StepsList(recipe: recipe),
    );
  }
}
