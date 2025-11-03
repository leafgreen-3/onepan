import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/app_button.dart';
import 'package:onepan/router/routes.dart';

class FinalizerScreen extends StatelessWidget {
  const FinalizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final idFromPath = state.pathParameters['id'];
    final recipeId = (idFromPath ??
            ((state.extra is Map) ? (state.extra as Map)['recipeId'] as String? : null)) ??
        '';

    return Scaffold(
      appBar: AppBar(title: const Text('Finalize')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No AI call yet — mock only'),
              const SizedBox(height: AppSpacing.lg),
              if (recipeId.isNotEmpty)
                AppButton(
                  label: 'Continue to Recipe',
                  onPressed: () {
                    context.pushReplacement('${Routes.recipe}/$recipeId/view?mode=ai');
                  },
                )
              else
                const Text('Recipe id not available, cannot navigate.'),
            ],
          ),
        ),
      ),
    );
  }
}

