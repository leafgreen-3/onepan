// Defines route names and paths for the app.

class Routes {
  Routes._();

  static const onboarding = '/onboarding';
  static const home = '/home';
  static const customize = '/customize';
  static const ingredients = '/ingredients';
  static const finalizer = '/finalizer';
  static const recipe = '/recipe';

  // Dev routes
  static const devRecipes = '/dev/recipes';
  static const devRecipeBase = '/dev/recipe'; // used for building detail path
  static const devComponents = '/dev/components';
}
