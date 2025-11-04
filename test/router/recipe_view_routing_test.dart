import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/step.dart' as v1;
import 'package:onepan/data/repositories/recipe_repository.dart' as v1;
import 'package:onepan/features/finalizer/finalizer_screen.dart';
import 'package:onepan/features/instructions/instructions_screen.dart';
import 'package:onepan/features/recipe/recipe_mode.dart';

class _MockRepo extends Mock implements v1.RecipeRepository {}

void main() {
  testWidgets('finalizer continue lands on nested /recipe/:id/view?mode=ai', (tester) async {
    final getIt = GetIt.instance;
    await getIt.reset();
    final repo = _MockRepo();
    getIt.registerSingleton<v1.RecipeRepository>(repo);

    const recipe = v1.Recipe(
      schemaVersion: 1,
      id: 'r1',
      title: 'Sample',
      timeTotalMin: 10,
      diet: 'veg',
      imageAsset: 'x',
      ingredients: [v1.Ingredient(id: 'oil', qty: 1, unit: 'tbsp', category: 'core')],
      steps: [v1.StepItem(num: 1, text: 'Cook')],
    );
    when(() => repo.getById('r1')).thenAnswer((_) async => recipe);

    late final GoRouter router;
    router = GoRouter(
      initialLocation: '/finalizer/r1',
      routes: [
        GoRoute(
          path: '/finalizer/:id',
          builder: (context, state) => const FinalizerScreen(),
        ),
        GoRoute(
          path: '/recipe/:id',
          builder: (context, state) => const Scaffold(body: SizedBox.shrink()),
          routes: [
            GoRoute(
              path: 'view',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                final mode =
                    RecipeModeX.fromQuery(state.uri.queryParameters['mode']);
                return ProviderScope(
                  child: Scaffold(
                    body: Column(
                      children: [
                        Expanded(
                          child:
                              InstructionsScreen(recipeId: id, mode: mode),
                        ),
                        Text('loc:${state.uri}', key: const Key('route_loc')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    // Tap Continue to Recipe on the finalizer
    await tester.tap(find.text('Continue to Recipe'));
    await tester.pumpAndSettle();

    final locText =
        tester.widget<Text>(find.byKey(const Key('route_loc'))).data ?? '';
    expect(locText, endsWith('/recipe/r1/view?mode=ai'));
    expect(find.text('Ingredients (AI)'), findsOneWidget);
  });
}
