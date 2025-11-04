import 'package:riverpod/riverpod.dart';
import 'ingredient_catalog_service.dart';

final ingredientCatalogProvider = Provider<IngredientCatalogService>((ref) {
  return IngredientCatalogService();
});

