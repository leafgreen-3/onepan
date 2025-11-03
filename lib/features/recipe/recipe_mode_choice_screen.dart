import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/features/recipe/recipe_providers.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/app_button.dart';
import 'package:onepan/ui/atoms/empty_state.dart';

class RecipeModeChoiceScreen extends ConsumerWidget {
  const RecipeModeChoiceScreen({super.key, required this.recipeId});

  final String recipeId;

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
                AppButton(
                  label: 'Retry',
                  onPressed: () => ref.refresh(recipeByIdProvider(recipeId)),
                  variant: AppButtonVariant.tonal,
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

        return Scaffold(
          appBar: AppBar(
            backgroundColor: scheme.surface,
            elevation: AppElevation.e0,
            iconTheme: IconThemeData(color: scheme.onSurface),
            title: Text(recipe.title, style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
            centerTitle: true,
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                math.max(AppSpacing.xl, MediaQuery.viewPaddingOf(context).bottom),
              ),
              children: [
                // Hero image
                Material(
                  elevation: AppElevation.e1,
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  clipBehavior: Clip.antiAlias,
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: recipe.imageAsset.isNotEmpty
                        ? Image.asset(
                            recipe.imageAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: scheme.surface,
                              alignment: Alignment.center,
                              child: Icon(Icons.image_not_supported, color: scheme.onSurface.withValues(alpha: AppOpacity.mediumText)),
                            ),
                          )
                        : Container(
                            color: scheme.surface,
                            alignment: Alignment.center,
                            child: Icon(Icons.image, color: scheme.onSurface.withValues(alpha: AppOpacity.mediumText)),
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Title
                Text(
                  recipe.title,
                  style: AppTextStyles.display.copyWith(color: scheme.onSurface),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Time row
                Text(
                  '${recipe.timeTotalMin} min',
                  style: AppTextStyles.label.copyWith(
                    color: scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Short description (placeholder for now)
                Text(
                  'A simple, one-pan recipe. Customize with AI or view the base version.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Simple View',
                  onPressed: () => context.pushReplacement('${Routes.recipe}/$recipeId/view?mode=simple'),
                  variant: AppButtonVariant.filled,
                  size: AppButtonSize.lg,
                  expand: true,
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'AI Mode (Beta)',
                  onPressed: () => context.push('${Routes.customize}/$recipeId'),
                  variant: AppButtonVariant.filled,
                  role: AppButtonRole.aiAccent,
                  size: AppButtonSize.lg,
                  expand: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
