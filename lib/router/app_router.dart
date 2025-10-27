import 'package:go_router/go_router.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/features/onboarding/onboarding_screen.dart';
import 'package:onepan/features/home/home_screen.dart';
import 'package:onepan/features/customize/customize_screen.dart';
import 'package:onepan/features/ingredients/ingredients_screen.dart';
import 'package:onepan/features/finalizer/finalizer_screen.dart';
import 'package:onepan/features/recipe/recipe_screen.dart';

// Central app router configuration using go_router.
final GoRouter appRouter = GoRouter(
  // Use home as the initial route to satisfy the current smoke test.
  initialLocation: Routes.home,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
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
  ],
);
