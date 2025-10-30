import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:onepan/data/repositories/seed_recipe_repository.dart';
import 'package:onepan/data/sources/local/seed_loader.dart';

void main() {
  late SeedRecipeRepository repository;

  setUp(() async {
    final jsonString = jsonEncode([
      {
        'schemaVersion': 1,
        'id': 'veg-quick',
        'title': 'Veg Quick',
        'timeTotalMin': 15,
        'diet': 'veg',
        'imageAsset': 'assets/images/recipes/veg-quick.png',
        'ingredients': [
          {
            'id': 'oil',
            'name': 'Oil',
            'qty': 1,
            'unit': 'tbsp',
            'category': 'core',
          },
        ],
        'steps': [
          {'num': 1, 'text': 'Cook'},
        ],
      },
      {
        'schemaVersion': 1,
        'id': 'veg-medium',
        'title': 'Veg Medium',
        'timeTotalMin': 28,
        'diet': 'veg',
        'imageAsset': 'assets/images/recipes/veg-medium.png',
        'ingredients': [
          {
            'id': 'oil',
            'name': 'Oil',
            'qty': 1,
            'unit': 'tbsp',
            'category': 'core',
          },
        ],
        'steps': [
          {'num': 1, 'text': 'Cook'},
        ],
      },
      {
        'schemaVersion': 1,
        'id': 'nonveg-fast',
        'title': 'NonVeg Fast',
        'timeTotalMin': 20,
        'diet': 'nonveg',
        'imageAsset': 'assets/images/recipes/nonveg-fast.png',
        'ingredients': [
          {
            'id': 'oil',
            'name': 'Oil',
            'qty': 1,
            'unit': 'tbsp',
            'category': 'core',
          },
        ],
        'steps': [
          {'num': 1, 'text': 'Cook'},
        ],
      },
      {
        'schemaVersion': 1,
        'id': 'nonveg-regular',
        'title': 'NonVeg Regular',
        'timeTotalMin': 35,
        'diet': 'nonveg',
        'imageAsset': 'assets/images/recipes/nonveg-regular.png',
        'ingredients': [
          {
            'id': 'oil',
            'name': 'Oil',
            'qty': 1,
            'unit': 'tbsp',
            'category': 'core',
          },
        ],
        'steps': [
          {'num': 1, 'text': 'Cook'},
        ],
      },
    ]);

    final loader = SeedLoader.fromString(jsonString);
    repository = SeedRecipeRepository(seedLoader: loader);
  });

  test('sorts recipes by time then title case-insensitively', () async {
    final recipes = await repository.list();
    final ids = recipes.map((recipe) => recipe.id).toList();
    expect(ids, ['veg-quick', 'nonveg-fast', 'veg-medium', 'nonveg-regular']);
  });

  test('filters by diet', () async {
    final recipes = await repository.list(diet: 'veg');
    expect(recipes.map((recipe) => recipe.diet), everyElement(equals('veg')));
  });

  test('filters by fast time mode', () async {
    final recipes = await repository.list(timeMode: 'fast');
    expect(recipes.map((recipe) => recipe.id), containsAll(['veg-quick', 'nonveg-fast']));
    expect(recipes.every((recipe) => recipe.timeTotalMin <= FAST_THRESHOLD_MIN), isTrue);
  });

  test('filters by regular time mode', () async {
    final recipes = await repository.list(timeMode: 'regular');
    expect(recipes.map((recipe) => recipe.id), containsAll(['veg-medium', 'nonveg-regular']));
    expect(recipes.every((recipe) => recipe.timeTotalMin > FAST_THRESHOLD_MIN), isTrue);
  });

  test('getById returns recipe when found', () async {
    final recipe = await repository.getById('veg-quick');
    expect(recipe, isNotNull);
    expect(recipe!.id, 'veg-quick');
  });

  test('getById returns null when not found', () async {
    final recipe = await repository.getById('missing');
    expect(recipe, isNull);
  });
}
