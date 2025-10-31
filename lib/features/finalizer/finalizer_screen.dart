import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/app_button.dart';

class FinalizerScreen extends StatelessWidget {
  const FinalizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    final payload = (extra is Map) ? extra : const {};
    final recipeId = payload['recipeId'] as String?;

    return Scaffold(
      appBar: AppBar(title: const Text('Finalize')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Finalizer'),
              const SizedBox(height: AppSpacing.lg),
              if (recipeId != null && recipeId.isNotEmpty)
                AppButton(
                  label: 'Start Cooking',
                  onPressed: () {
                    // Navigate to instructions route
                    context.push('/recipe/$recipeId');
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

