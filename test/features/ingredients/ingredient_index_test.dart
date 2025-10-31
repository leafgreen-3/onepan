import 'package:flutter_test/flutter_test.dart';
import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/step.dart' as v1;
import 'package:onepan/data/repositories/recipe_repository.dart' as v1;
import 'package:onepan/features/ingredients/ingredient_index.dart';

class _FakeRepo implements v1.RecipeRepository {
  _FakeRepo(this._recipes);
  final List<v1.Recipe> _recipes;
  @override
  Future<v1.Recipe?> getById(String id) async =>
      _recipes.firstWhere((e) => e.id == id, orElse: () => _recipes.first);
  @override
  Future<List<v1.Recipe>> list({String? diet, String? timeMode}) async => _recipes;
}

v1.Recipe makeRecipe({
  required String id,
  required List<v1.Ingredient> ings,
}) => v1.Recipe(
      schemaVersion: 1,
      id: id,
      title: id,
      timeTotalMin: 10,
      diet: 'veg',
      imageAsset: 'x',
      ingredients: ings,
      steps: const [v1.StepItem(num: 1, text: 'step')],
    );

void main() {
  test('buildIngredientIndex dedupes by id, sorts by name, pins core group', () async {
    final repo = _FakeRepo([
      makeRecipe(id: 'r1', ings: const [
        v1.Ingredient(id: 'garlic', name: 'Garlic', qty: 1, unit: 'piece', category: 'spice'),
        v1.Ingredient(id: 'onion-yellow', name: 'Yellow onion', qty: 1, unit: 'piece', category: 'vegetable'),
        v1.Ingredient(id: 'oil-olive', name: 'Olive oil', qty: 1, unit: 'tbsp', category: 'core'),
      ]),
      makeRecipe(id: 'r2', ings: const [
        v1.Ingredient(id: 'garlic', name: 'Garlic', qty: 2, unit: 'piece', category: 'spice'),
        v1.Ingredient(id: 'spinach', name: 'Baby spinach', qty: 1, unit: 'cup', category: 'vegetable'),
        v1.Ingredient(id: 'salt', name: 'Salt', qty: 1, unit: 'tsp', category: 'spice'),
      ]),
    ]);

    final index = await buildIngredientIndex(repo);
    // Deduped: garlic only once
    expect(index.all.where((i) => i.id == 'garlic').length, 1);
    // Sorted A->Z by name
    final names = index.all.map((e) => e.name).toList();
    final sorted = List<String>.from(names)..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    expect(names, sorted);
    // Core group contains category core and pinned ids (garlic, onion-yellow, salt)
    final coreGroup = index.groups.firstWhere((g) => g.key == 'header_core');
    final coreIds = coreGroup.items.map((e) => e.id).toSet();
    expect(coreIds.contains('oil-olive'), true);
    expect(coreIds.contains('garlic'), true);
    expect(coreIds.contains('onion-yellow'), true);
    expect(coreIds.contains('salt'), true);
  });
}

