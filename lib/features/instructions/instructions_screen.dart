import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/features/recipe/recipe_providers.dart';
import 'package:onepan/theme/tokens.dart';

class InstructionsScreen extends ConsumerWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = GoRouterState.of(context).pathParameters['id'] ?? '';
    final recipeAsync = ref.watch(recipeByIdProvider(id));
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: AppElevation.e0,
        iconTheme: IconThemeData(color: scheme.onSurface),
        title: recipeAsync.when(
          data: (r) => Text(r?.title ?? 'Steps', style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
          loading: () => Text('Loading...', style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
          error: (_, __) => Text('Steps', style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
        ),
        centerTitle: true,
      ),
      body: recipeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => _ErrorState(onRetry: () => ref.refresh(recipeByIdProvider(id))),
        data: (recipe) {
          if (recipe == null) return const _ErrorState(onRetry: null);
          return _StepsList(recipe: recipe);
        },
      ),
    );
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
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
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
                        const Icon(Icons.timer_outlined, size: 14),
                        const SizedBox(width: 4),
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

