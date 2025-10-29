import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepan/di/locator.dart';
import 'package:onepan/models/recipe.dart';
import 'package:onepan/repository/recipe_repository.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController(locator<RecipeRepository>());
});

class HomeState {
  const HomeState({
    this.recipes = const AsyncValue.loading(),
    this.favorites = const <String>{},
  });

  final AsyncValue<List<Recipe>> recipes;
  final Set<String> favorites;

  HomeState copyWith({
    AsyncValue<List<Recipe>>? recipes,
    Set<String>? favorites,
  }) {
    return HomeState(
      recipes: recipes ?? this.recipes,
      favorites: favorites ?? this.favorites,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  HomeController(this._repository) : super(const HomeState()) {
    _load();
  }

  final RecipeRepository _repository;

  Future<void> refresh() {
    return _load();
  }

  Future<void> _load() async {
    state = state.copyWith(recipes: const AsyncValue.loading());
    try {
      final recipes = await _repository.list();
      state = state.copyWith(recipes: AsyncValue.data(recipes));
    } catch (error, stackTrace) {
      state = state.copyWith(
        recipes: AsyncValue.error(error, stackTrace),
      );
    }
  }

  void toggleFavorite(String id) {
    final updated = Set<String>.from(state.favorites);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    // TODO: Persist favorites to storage once available.
    state = state.copyWith(favorites: updated);
  }
}
