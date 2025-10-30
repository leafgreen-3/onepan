import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:onepan/features/home/home_controller.dart';
import 'package:onepan/features/home/widgets/recipe_card.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/app_button.dart';
import 'package:onepan/ui/atoms/app_skeleton.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _HomeHeader(),
            Expanded(
              child: state.recipes.when(
                data: (recipes) {
                  if (recipes.isEmpty) {
                    return _EmptyState(
                      message: 'Fresh recipes are on the way.',
                      action: AppButton(
                        key: const Key('home_refresh_button'),
                        label: 'Refresh',
                        onPressed: () => controller.refresh(),
                        variant: AppButtonVariant.tonal,
                      ),
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
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        final isFavorite = state.favorites.contains(recipe.id);
                        return RecipeCard(
                          key: Key('recipe_card_${recipe.id}'),
                          recipe: recipe,
                          isFavorite: isFavorite,
                          onTap: () => context.push('${Routes.recipe}/${recipe.id}'),
                          onToggleFavorite: () =>
                              controller.toggleFavorite(recipe.id),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.xl),
                    ),
                  );
                },
                loading: () => const _LoadingList(),
                error: (error, _) => _ErrorState(
                  message: 'We could not load recipes right now.',
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

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
      child: Row(
        children: [
          Expanded(
            child: Text(
              'OnePan',
              style: AppTextStyles.display.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search is coming soon.'),
                  duration: AppDurations.fast,
                ),
              );
            },
            icon: const Icon(Icons.search),
            iconSize: AppSizes.icon,
            padding: const EdgeInsets.all(AppSpacing.sm),
            constraints: const BoxConstraints(
              minWidth: AppSizes.minTouchTarget,
              minHeight: AppSizes.minTouchTarget,
            ),
            tooltip: 'Search recipes',
          ),
        ],
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const Key('home_loading_skeleton'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      itemBuilder: (context, index) => const _RecipeCardSkeleton(),
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.xl),
      itemCount: 3,
    );
  }
}

class _RecipeCardSkeleton extends StatelessWidget {
  const _RecipeCardSkeleton();

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

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
    this.action,
  });

  final String message;
  final Widget? action;

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
              Icons.local_dining,
              size: AppSizes.icon,
              color:
                  scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              key: const Key('home_empty_message'),
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                color: scheme.onSurface,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
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
              key: const Key('home_error_message'),
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Try again',
              onPressed: onRetry,
              key: const Key('home_retry_button'),
            ),
          ],
        ),
      ),
    );
  }
}
