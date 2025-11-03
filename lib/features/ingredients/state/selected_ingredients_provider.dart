import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stores picked ingredient ids per recipe during the AI flow.
/// Keyed by `recipeId` so selections persist across screens within a session.
final selectedIngredientIdsProvider =
    StateProvider.family<Set<String>, String>((ref, recipeId) => <String>{});
