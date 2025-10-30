import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepan/features/customize/customize_state.dart';

final customizeStateProvider = StateNotifierProvider.autoDispose
    .family<CustomizeController, CustomizeState, String>((ref, recipeId) {
  return CustomizeController();
});

class CustomizeController extends StateNotifier<CustomizeState> {
  CustomizeController() : super(const CustomizeState());

  void setServings(int v) {
    final clamped = v < 1
        ? 1
        : (v > 6)
            ? 6
            : v;
    state = state.copyWith(servings: clamped);
  }

  void setTime(String t) {
    final value = (t == 'fast') ? 'fast' : 'regular';
    state = state.copyWith(time: value);
  }

  void setSpice(String s) {
    const allowed = {'mild', 'medium', 'spicy'};
    state = state.copyWith(spice: allowed.contains(s) ? s : 'medium');
  }
}

