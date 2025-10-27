import 'package:go_router/go_router.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/features/onboarding/onboarding_screen.dart';
import 'package:onepan/features/home/home_screen.dart';
import 'package:onepan/features/customize/customize_screen.dart';
import 'package:onepan/features/ingredients/ingredients_screen.dart';
import 'package:onepan/features/finalizer/finalizer_screen.dart';
import 'package:onepan/features/recipe/recipe_screen.dart';
import 'package:onepan/screens/dev/recipe_detail_screen.dart';
import 'package:onepan/screens/dev/recipes_list_screen.dart';
import 'package:onepan/models/recipe.dart';

// Central app router configuration using go_router.
final GoRouter appRouter = GoRouter(
  // Keep home as initial to satisfy tests; dev listing accessible via Home button.
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
    // Dev-only minimal listing/detail routes
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
  ],
);
