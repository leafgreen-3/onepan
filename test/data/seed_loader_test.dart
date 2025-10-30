import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:onepan/core/seed_load_exception.dart';
import 'package:onepan/data/sources/local/seed_loader.dart';

void main() {
  group('SeedLoader.fromString', () {
    test('parses valid recipes', () async {
      final jsonString = jsonEncode([
        {
          'schemaVersion': 1,
          'id': 'veg-one',
          'title': 'Veg One',
          'timeTotalMin': 15,
          'diet': 'veg',
          'imageAsset': 'assets/images/recipes/veg-one.png',
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
            {'num': 1, 'text': 'Do a thing'},
          ],
        },
        {
          'schemaVersion': 1,
          'id': 'veg-two',
          'title': 'Veg Two',
          'timeTotalMin': 18,
          'diet': 'veg',
          'imageAsset': 'assets/images/recipes/veg-two.png',
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
            {'num': 1, 'text': 'Do a thing'},
          ],
        },
        {
          'schemaVersion': 1,
          'id': 'nonveg-one',
          'title': 'NonVeg One',
          'timeTotalMin': 25,
          'diet': 'nonveg',
          'imageAsset': 'assets/images/recipes/nonveg-one.png',
          'imageUrl': 'https://example.com/nonveg.png',
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
            {'num': 1, 'text': 'Do a thing'},
          ],
        },
      ]);

      final loader = SeedLoader.fromString(jsonString);
      final recipes = await loader.load();
      expect(recipes, hasLength(3));
      final first = recipes.first;
      expect(first.id, 'veg-one');
      expect(first.imageAsset, 'assets/images/recipes/veg-one.png');
      expect(first.imageUrl, isNull);
    });

    test('throws SeedLoadException with aggregated errors', () async {
      final jsonString = jsonEncode([
        {
          'schemaVersion': 1,
          'id': 'valid',
          'title': 'Valid Recipe',
          'timeTotalMin': 10,
          'diet': 'veg',
          'imageAsset': 'assets/images/recipes/valid.png',
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
            {'num': 1, 'text': 'Do a thing'},
          ],
        },
        {
          'schemaVersion': 1,
          'id': 'bad-unit',
          'title': 'Bad Unit',
          'timeTotalMin': 10,
          'diet': 'veg',
          'imageAsset': 'assets/images/recipes/bad.png',
          'ingredients': [
            {
              'id': 'oil',
              'name': 'Oil',
              'qty': 1,
              'unit': 'ounces',
              'category': 'core',
            },
          ],
          'steps': [
            {'num': 1, 'text': 'Do a thing'},
          ],
        },
        {
          'id': 'missing-version',
          'title': 'Missing Version',
          'timeTotalMin': 10,
          'diet': 'veg',
          'imageAsset': 'assets/images/recipes/missing.png',
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
            {'num': 1, 'text': 'Do a thing'},
          ],
        },
      ]);

      final loader = SeedLoader.fromString(jsonString);
      try {
        await loader.load();
        fail('Expected SeedLoadException');
      } on SeedLoadException catch (error) {
        expect(error.errorCount, 2);
        expect(error.validCount, 1);
        expect(error.items, hasLength(2));
        final messages = error.items.expand((item) => item.errors).join(' ');
        expect(messages, contains('ounces'));
        expect(messages, contains('schemaVersion'));
      }
    });
  });
}
