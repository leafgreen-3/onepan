import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/app/services/preferences_service.dart';

@immutable
class OnboardingState {
  const OnboardingState({
    this.country,
    this.level,
    this.diet,
    this.hasFinished = false,
  });

  final String? country;
  final String? level;
  final String? diet;
  final bool hasFinished;

  bool get hasAllSelections => country != null && level != null && diet != null;

  bool get isComplete => hasFinished && hasAllSelections;

  OnboardingState copyWith({
    String? country,
    String? level,
    String? diet,
    bool? hasFinished,
  }) {
    return OnboardingState(
      country: country ?? this.country,
      level: level ?? this.level,
      diet: diet ?? this.diet,
      hasFinished: hasFinished ?? this.hasFinished,
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
      hasFinished: true,
    );
  }

  void selectCountry(String country) {
    state = state.copyWith(
      country: country,
      hasFinished: false,
    );
  }

  void selectLevel(String level) {
    state = state.copyWith(
      level: level,
      hasFinished: false,
    );
  }

  void selectDiet(String diet) {
    state = state.copyWith(
      diet: diet,
      hasFinished: false,
    );
  }

  Future<void> complete() async {
    final current = state;
    if (!current.hasAllSelections) {
      throw ArgumentError('Cannot complete onboarding without all selections.');
    }

    await _preferences.saveOnboarding(
      country: current.country!,
      level: current.level!,
      diet: current.diet!,
    );

    state = state.copyWith(hasFinished: true);
  }

  Future<void> clear() async {
    await _preferences.clearOnboarding();
    state = const OnboardingState();
  }
}
