import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/dev/components_demo_screen.dart';
import 'package:onepan/di/locator.dart';
import 'package:onepan/features/customize/customize_screen.dart';
import 'package:onepan/features/finalizer/finalizer_screen.dart';
import 'package:onepan/features/home/home_screen.dart';
import 'package:onepan/features/ingredients/ingredients_screen.dart';
import 'package:onepan/features/onboarding/onboarding_screen.dart';
import 'package:onepan/features/instructions/instructions_screen.dart';
import 'package:onepan/features/saved/saved_screen.dart';
import 'package:onepan/features/settings/settings_screen.dart';
import 'package:onepan/models/recipe.dart';
import 'package:onepan/router/go_router_refresh_stream.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/screens/dev/recipe_detail_screen.dart';
import 'package:onepan/screens/dev/recipes_list_screen.dart';
import 'package:onepan/theme/tokens.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingNotifier = ref.read(onboardingControllerProvider.notifier);
  final refreshListenable = GoRouterRefreshStream(onboardingNotifier.stream);
  ref.onDispose(refreshListenable.dispose);

  const onboardingPaths = <String>{
    Routes.onboarding,
    Routes.onboardingCountry,
    Routes.onboardingLevel,
    Routes.onboardingDiet,
  };

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.onboardingCountry,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final isComplete = ref.read(onboardingControllerProvider).isComplete;
      final location = state.uri.path.isEmpty
          ? Routes.onboardingCountry
          : state.uri.path;
      final inOnboarding = onboardingPaths.contains(location);

      if (!isComplete && !inOnboarding) {
        return Routes.onboardingCountry;
      }

      if (isComplete && inOnboarding) {
        return Routes.home;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: Routes.onboarding,
        redirect: (_, __) => Routes.onboardingCountry,
      ),
      GoRoute(
        path: Routes.onboardingCountry,
        name: 'onboarding_country',
        builder: (context, state) => const OnboardingCountryScreen(),
      ),
      GoRoute(
        path: Routes.onboardingLevel,
        name: 'onboarding_level',
        builder: (context, state) => const OnboardingLevelScreen(),
      ),
      GoRoute(
        path: Routes.onboardingDiet,
        name: 'onboarding_diet',
        builder: (context, state) => const OnboardingDietScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _RootShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.saved,
                name: 'saved',
                builder: (context, state) => const SavedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '${Routes.customize}/:id',
        name: 'customize',
        builder: (context, state) => const CustomizeScreen(),
      ),
      GoRoute(
        path: Routes.ingredients,
        name: 'ingredients',
        builder: (context, state) => const IngredientsScreen(),
      ),
      GoRoute(
        path: Routes.finalizer,
        name: 'finalizer',
        builder: (context, state) => const FinalizerScreen(),
      ),
      GoRoute(
        path: '${Routes.recipe}/:id',
        name: 'recipe',
        builder: (context, state) => const InstructionsScreen(),
      ),
      GoRoute(
        path: Routes.devRecipes,
        name: 'dev_recipes',
        builder: (context, state) => const RecipesListScreen(),
      ),
      GoRoute(
        path: '${Routes.devRecipeBase}/:id',
        name: 'dev_recipe_detail',
        builder: (context, state) =>
            RecipeDetailScreen(recipe: state.extra as Recipe),
      ),
      GoRoute(
        path: Routes.devComponents,
        name: 'dev_components',
        builder: (context, state) => const ComponentsDemoScreen(),
      ),
    ],
  );
});

class _RootShell extends StatelessWidget {
  const _RootShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
          child: Material(
            color: scheme.surface,
            elevation: AppElevation.e1,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  _NavItem(
                    navigationShell: navigationShell,
                    index: 0,
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    label: 'Home',
                  ),
                  _NavItem(
                    navigationShell: navigationShell,
                    index: 1,
                    icon: Icons.bookmark_border,
                    selectedIcon: Icons.bookmark,
                    label: 'Saved',
                  ),
                  _NavItem(
                    navigationShell: navigationShell,
                    index: 2,
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.navigationShell,
    required this.index,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final StatefulNavigationShell navigationShell;
  final int index;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = navigationShell.currentIndex == index;
    final color = selected
        ? scheme.primary
        : scheme.onSurface.withValues(alpha: AppOpacity.mediumText);

    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        label: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.md),
          onTap: () {
            navigationShell.goBranch(
              index,
              initialLocation: navigationShell.currentIndex == index,
            );
          },
          child: SizedBox(
            height: AppSizes.minTouchTarget,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected ? selectedIcon : icon,
                  size: AppSizes.icon,
                  color: color,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  textHeightBehavior: const TextHeightBehavior(applyHeightToLastDescent: false),
                  style: AppTextStyles.label.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
