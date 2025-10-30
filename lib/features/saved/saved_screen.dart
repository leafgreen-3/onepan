import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:onepan/features/home/home_controller.dart';
import 'package:onepan/features/home/widgets/recipe_card.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/app_button.dart';
import 'package:onepan/ui/atoms/app_skeleton.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _SavedHeader(),
            Expanded(
              child: state.recipes.when(
                data: (recipes) {
                  final savedRecipes = recipes
                      .where((recipe) => state.favorites.contains(recipe.id))
                      .toList();

                  if (savedRecipes.isEmpty) {
                    return _EmptySaved(
                      onFindRecipes: () => context.go(Routes.home),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.lg,
                        AppSpacing.xl,
                        AppSpacing.xl,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: savedRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = savedRecipes[index];
                        return RecipeCard(
                          recipe: recipe,
                          isFavorite: true,
                          onTap: () =>
                              context.push('${Routes.recipe}/${recipe.id}'),
                          onToggleFavorite: () =>
                              controller.toggleFavorite(recipe.id),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.xl),
                    ),
                  );
                },
                loading: () => const _SavedLoadingList(),
                error: (error, _) => _SavedError(
                  onRetry: () => controller.refresh(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedHeader extends StatelessWidget {
  const _SavedHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.md,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Saved',
          style: AppTextStyles.display.copyWith(
            color: scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _SavedLoadingList extends StatelessWidget {
  const _SavedLoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      itemBuilder: (context, index) => const _SavedSkeletonCard(),
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.xl),
      itemCount: 3,
    );
  }
}

class _SavedSkeletonCard extends StatelessWidget {
  const _SavedSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      elevation: AppElevation.e1,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      clipBehavior: Clip.antiAlias,
      child: const AspectRatio(
        aspectRatio: 4 / 3,
        child: AppSkeleton.rect(radius: AppRadii.lg),
      ),
    );
  }
}

class _EmptySaved extends StatelessWidget {
  const _EmptySaved({required this.onFindRecipes});

  final VoidCallback onFindRecipes;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: AppSizes.icon,
              color:
                  scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'You haven\'t saved any recipes yet.',
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Find recipes',
              onPressed: onFindRecipes,
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedError extends StatelessWidget {
  const _SavedError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off,
              size: AppSizes.icon,
              color:
                  scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'We can\'t show your saved recipes right now.',
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Try again',
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
