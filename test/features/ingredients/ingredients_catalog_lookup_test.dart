import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/features/ingredients/ingredients_screen.dart';
import 'package:onepan/features/ingredients/ingredients_providers.dart';
import 'package:onepan/features/ingredients/ingredient_index.dart';
import 'package:onepan/data/models/ingredient.dart' as v1i;

void main() {
  testWidgets('IngredientsScreen uses catalog-only names/images with placeholder fallback', (tester) async {
    // Build three ingredients: known in catalog, fallback with asset, and unknown
    const known = v1i.Ingredient(
      id: 'spinach',
      qty: 2,
      unit: 'cup',
      category: 'vegetable',
    );
    const fallback = v1i.Ingredient(
      id: 'not-in-catalog-asset',
      qty: 1,
      unit: 'tbsp',
      category: 'core',
    );
    const unknown = v1i.Ingredient(
      id: 'unknown-no-asset',
      qty: 1,
      unit: 'piece',
      category: 'other',
    );

    final groups = <IngredientGroup>[
      IngredientGroup(key: 'header_core', title: 'Core', items: [known, fallback, unknown]),
    ];
    final index = IngredientIndex(all: [known, fallback, unknown], groups: groups);

    final router = GoRouter(
      initialLocation: '/ingredients',
      routes: [
        GoRoute(
          path: '/ingredients',
          builder: (context, state) => const IngredientsScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ingredientIndexProvider.overrideWith((ref) async => index),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    // Catalog-known id should render catalog name ('Spinach').
    expect(find.text('Spinach'), findsWidgets);

    // Unknown-to-catalog should render id and show placeholder.
    expect(find.text('not-in-catalog-asset'), findsWidgets);
    expect(find.byKey(const Key('picker_ing_thumb_placeholder_not-in-catalog-asset')), findsOneWidget);

    // Unknown id should show placeholder in picker.
    expect(find.byKey(const Key('picker_ing_thumb_placeholder_unknown-no-asset')), findsOneWidget);
  });
}
