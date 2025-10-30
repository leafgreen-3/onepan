@Tags(['legacy'])
import 'package:flutter_test/flutter_test.dart';
import 'package:onepan/models/recipe.dart';

void main() {
  test('Recipe toJson/fromJson round-trip preserves fields', () {
    final recipe = Recipe(
      id: 'test-recipe-123',
      title: 'Test Recipe',
      subtitle: 'A simple test case',
      tags: Recipe.normalizeTags(['Easy', 'test', 'Test']),
      minutes: 15,
      servings: 2,
      spice: SpiceLevel.mild,
      image: 'assets/images/test.png',
      ingredients: ['1 cup water', '2 tbsp sugar'],
      steps: ['Mix ingredients', 'Serve chilled'],
      version: '1.0',
    );

    final json = recipe.toJson();
    final parsed = Recipe.fromJson(Map<String, dynamic>.from(json));

    // Compare field by field
    expect(parsed.id, recipe.id);
    expect(parsed.title, recipe.title);
    expect(parsed.subtitle, recipe.subtitle);
    expect(parsed.tags, recipe.tags);
    expect(parsed.minutes, recipe.minutes);
    expect(parsed.servings, recipe.servings);
    expect(parsed.spice, recipe.spice);
    expect(parsed.image, recipe.image);
    expect(parsed.ingredients, recipe.ingredients);
    expect(parsed.steps, recipe.steps);
    expect(parsed.version, recipe.version);
    expect(parsed.updatedAt, recipe.updatedAt);
  });
}

