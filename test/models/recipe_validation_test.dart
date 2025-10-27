import 'package:flutter_test/flutter_test.dart';
import 'package:onepan/models/recipe.dart';

void main() {
  test('Happy-case Recipe validates and constructs', () {
    final recipe = Recipe(
      id: Recipe.idFromTitle('Cozy Tomato Soup'),
      title: 'Cozy Tomato Soup',
      subtitle: 'Simple, bright, and warming',
      tags: Recipe.normalizeTags(['soup', 'Vegetarian', 'quick']),
      minutes: 20,
      servings: 2,
      spice: SpiceLevel.mild,
      image: 'assets/images/tomato_soup.jpg',
      ingredients: [
        '1 tbsp olive oil',
        '1 onion, diced',
        '2 cloves garlic, minced',
        '400g canned tomatoes',
        '1 cup vegetable broth',
        'Salt and pepper',
      ],
      steps: [
        'Sauté onion in oil until softened; add garlic briefly.',
        'Add tomatoes and broth; simmer 10 minutes.',
        'Blend or mash to desired texture; season to taste.',
      ],
      version: '1.0',
    );

    expect(recipe.title, 'Cozy Tomato Soup');
    expect(recipe.tags, equals(['quick', 'soup', 'vegetarian']));
    expect(recipe.minutes, 20);
    expect(recipe.servings, 2);
  });
}

