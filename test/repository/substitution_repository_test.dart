import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:onepan/models/errors.dart';
import 'package:onepan/models/substitution.dart';
import 'package:onepan/repository/mock_substitution_repository.dart';
import 'package:onepan/repository/seed_recipe_repository.dart';
import 'package:onepan/repository/substitution_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MockSubstitutionRepository determinism and validation', () {
    late SubstitutionRepository subs;

    setUp(() {
      subs = MockSubstitutionRepository(recipes: SeedRecipeRepository());
    });

    SubstitutionRequest canonical({List<String>? available, List<String>? missing}) {
      return SubstitutionRequest(
        recipeId: 'spicy-tomato-pasta',
        params: const {
          'servings': 2,
          'time': 30,
          'spice': 'medium',
        },
        availableIds: available ?? const ['pan', 'knife', 'salt'],
        missingIds: missing ?? const ['butter'],
      );
    }

    test('determinism: same request yields identical JSON twice', () async {
      final req = canonical();
      final r1 = await subs.substitute(req);
      final r2 = await subs.substitute(req);
      expect(jsonEncode(r1.toJson()), equals(jsonEncode(r2.toJson())));
    });

    test('determinism: different order in sets yields identical result', () async {
      final req1 = canonical(available: const ['salt', 'pan', 'knife'], missing: const ['butter']);
      final req2 = canonical(available: const ['knife', 'salt', 'pan'], missing: const ['butter']);
      final r1 = await subs.substitute(req1);
      final r2 = await subs.substitute(req2);
      expect(jsonEncode(r1.toJson()), equals(jsonEncode(r2.toJson())));
    });

    test('stability under noise: unknown param key is ignored', () async {
      final base = canonical();
      final noisy = SubstitutionRequest(
        recipeId: base.recipeId,
        params: {
          ...base.params,
          'noop': 'ignored',
        },
        availableIds: base.availableIds,
        missingIds: base.missingIds,
      );
      final r1 = await subs.substitute(base);
      final r2 = await subs.substitute(noisy);
      expect(jsonEncode(r1.toJson()), equals(jsonEncode(r2.toJson())));
    });

    test('invalid: empty recipeId', () async {
      const bad = SubstitutionRequest(recipeId: '', params: {}, availableIds: [], missingIds: []);
      await expectLater(
        () => subs.substitute(bad),
        throwsA(isA<RecipeValidationError>().having((e) => e.field, 'field', 'recipeId')),
      );
    });

    test('invalid: negative servings', () async {
      const bad = SubstitutionRequest(
        recipeId: 'spicy-tomato-pasta',
        params: {'servings': -1},
        availableIds: [],
        missingIds: [],
      );
      await expectLater(
        () => subs.substitute(bad),
        throwsA(isA<RecipeValidationError>().having((e) => e.field, 'field', 'params.servings')),
      );
    });

    test('invalid: negative time', () async {
      const bad = SubstitutionRequest(
        recipeId: 'spicy-tomato-pasta',
        params: {'time': -1},
        availableIds: [],
        missingIds: [],
      );
      await expectLater(
        () => subs.substitute(bad),
        throwsA(isA<RecipeValidationError>().having((e) => e.field, 'field', 'params.time')),
      );
    });

    test('invalid: unknown recipe id', () async {
      const bad = SubstitutionRequest(
        recipeId: 'no-such-id',
        params: {'servings': 2},
        availableIds: [],
        missingIds: [],
      );
      await expectLater(
        () => subs.substitute(bad),
        throwsA(isA<RecipeValidationError>().having((e) => e.field, 'field', 'recipeId')),
      );
    });
  });
}
