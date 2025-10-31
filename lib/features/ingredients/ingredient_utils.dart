/// Computes the list of missing ingredient IDs given the full list of
/// recipe ingredient IDs and the IDs the user has marked as available.
///
/// This is a pure helper and does no IO. Order is preserved from
/// `recipeIngredients` to keep UX expectations stable.
List<String> computeMissingIds({
  required List<String> recipeIngredients,
  required List<String> availableIds,
}) {
  if (recipeIngredients.isEmpty) return const <String>[];
  if (availableIds.isEmpty) return List<String>.from(recipeIngredients);
  final available = availableIds.toSet();
  final missing = <String>[];
  for (final id in recipeIngredients) {
    if (!available.contains(id)) {
      missing.add(id);
    }
  }
  return missing;
}
