import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/app/services/preferences_service.dart';

@immutable
class OnboardingState {
  const OnboardingState({
    this.country,
    this.level,
    this.diet,
  });

  final String? country;
  final String? level;
  final String? diet;

  bool get isComplete => country != null && level != null && diet != null;

  OnboardingState copyWith({
    String? country,
    String? level,
    String? diet,
  }) {
    return OnboardingState(
      country: country ?? this.country,
      level: level ?? this.level,
      diet: diet ?? this.diet,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(this._preferences) : super(const OnboardingState()) {
    _restoreFromPreferences();
  }

  final PreferencesService _preferences;

  Future<void> _restoreFromPreferences() async {
    final saved = await _preferences.readOnboarding();
    if (saved == null) {
      return;
    }

    state = OnboardingState(
      country: saved['country'],
      level: saved['level'],
      diet: saved['diet'],
    );
  }

  void selectCountry(String country) {
    state = state.copyWith(country: country);
  }

  void selectLevel(String level) {
    state = state.copyWith(level: level);
  }

  void selectDiet(String diet) {
    state = state.copyWith(diet: diet);
  }

  Future<void> complete() async {
    final current = state;
    if (!current.isComplete) {
      throw ArgumentError('Cannot complete onboarding without all selections.');
    }

    await _preferences.saveOnboarding(
      country: current.country!,
      level: current.level!,
      diet: current.diet!,
    );

    state = OnboardingState(
      country: current.country,
      level: current.level,
      diet: current.diet,
    );
  }

  Future<void> clear() async {
    await _preferences.clearOnboarding();
    state = const OnboardingState();
  }
}
