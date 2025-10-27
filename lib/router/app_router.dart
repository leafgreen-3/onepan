import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/di/locator.dart';
import 'package:onepan/features/customize/customize_screen.dart';
import 'package:onepan/features/finalizer/finalizer_screen.dart';
import 'package:onepan/features/home/home_screen.dart';
import 'package:onepan/features/ingredients/ingredients_screen.dart';
import 'package:onepan/features/onboarding/onboarding_screen.dart';
import 'package:onepan/features/recipe/recipe_screen.dart';
import 'package:onepan/models/recipe.dart';
import 'package:onepan/dev/components_demo_screen.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/router/go_router_refresh_stream.dart';
import 'package:onepan/screens/dev/recipe_detail_screen.dart';
import 'package:onepan/screens/dev/recipes_list_screen.dart';

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
      GoRoute(
        path: Routes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.customize,
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
        path: Routes.recipe,
        name: 'recipe',
        builder: (context, state) => const RecipeScreen(),
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
