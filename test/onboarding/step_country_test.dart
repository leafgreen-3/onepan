import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:onepan/app/services/preferences_service.dart';
import 'package:onepan/di/locator.dart';
import 'package:onepan/features/onboarding/step_country.dart';
import 'package:onepan/router/routes.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders country dropdown', (tester) async {
    final preferences = PreferencesService();
    final container = ProviderContainer(
      overrides: [
        preferencesServiceProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: OnboardingCountryScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Country'), findsOneWidget);
  });

  testWidgets('selecting a country enables Next', (tester) async {
    final preferences = PreferencesService();
    final container = ProviderContainer(
      overrides: [
        preferencesServiceProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: OnboardingCountryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Country'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Spain').last);
    await tester.pumpAndSettle();

    expect(container.read(onboardingControllerProvider).country, 'Spain');

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Next navigates to level step', (tester) async {
    final preferences = PreferencesService();
    final container = ProviderContainer(
      overrides: [
        preferencesServiceProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: Routes.onboardingCountry,
          builder: (context, state) => const OnboardingCountryScreen(),
        ),
        GoRoute(
          path: Routes.onboardingLevel,
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text(
                'Level Screen',
                key: ValueKey('level-screen'),
              ),
            ),
          ),
        ),
      ],
      initialLocation: Routes.onboardingCountry,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Country'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Spain').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('level-screen')), findsOneWidget);
  });

  testWidgets('restores saved country selection on reopen', (tester) async {
    final preferences = PreferencesService();
    final firstContainer = ProviderContainer(
      overrides: [
        preferencesServiceProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(firstContainer.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: firstContainer,
        child: const MaterialApp(
          home: OnboardingCountryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Country'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Spain').last);
    await tester.pumpAndSettle();

    final notifier = firstContainer.read(onboardingControllerProvider.notifier);
    notifier.selectLevel('Beginner');
    notifier.selectDiet('Omnivore');
    await notifier.complete();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    final secondContainer = ProviderContainer(
      overrides: [
        preferencesServiceProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(secondContainer.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: secondContainer,
        child: const MaterialApp(
          home: OnboardingCountryScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    expect(secondContainer.read(onboardingControllerProvider).country, 'Spain');
    expect(find.text('Spain'), findsOneWidget);
  });
}
