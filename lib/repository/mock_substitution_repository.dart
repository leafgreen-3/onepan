import 'dart:convert';

import 'package:onepan/models/errors.dart';
import 'package:onepan/models/recipe.dart';
import 'package:onepan/models/substitution.dart';
import 'package:onepan/repository/recipe_repository.dart';
import 'package:onepan/repository/substitution_repository.dart';

/// Deterministic mock substitution service.
class MockSubstitutionRepository implements SubstitutionRepository {
  final RecipeRepository recipes;

  MockSubstitutionRepository({required this.recipes});

  @override
  Future<SubstitutionResponse> substitute(SubstitutionRequest req) async {
    // Basic validation of the request shape.
    req.validate();

    // Strictness on param types if provided.
    if (req.params.containsKey('servings') && req.servings == null) {
      throw RecipeValidationError(field: 'params.servings', reason: 'must be an int');
    }
    if (req.params.containsKey('time') && req.time == null) {
      throw RecipeValidationError(field: 'params.time', reason: 'must be an int (minutes)');
    }
    if (req.params.containsKey('spice') && req.spice == null) {
      throw RecipeValidationError(field: 'params.spice', reason: 'must be one of: mild, medium, hot, inferno');
    }

    // Fetch the recipe; on unknown id, throw a validation error.
    final Recipe recipe;
    try {
      recipe = await recipes.getById(req.recipeId);
    } catch (_) {
      throw RecipeValidationError(field: 'recipeId', reason: 'unknown recipe id', value: req.recipeId);
    }

    final int hash = stableHash(req);
    final Set<String> available = req.availableIds.map((e) => e.toLowerCase().trim()).toSet();
    final Set<String> missing = req.missingIds.map((e) => e.toLowerCase().trim()).toSet();

    // Deterministic substitution lookup.
    const Map<String, String> swap = <String, String>{
      'butter': 'olive oil',
      'cream': 'coconut milk',
      'chicken': 'tofu',
      'shrimp': 'mushrooms',
      'beef': 'lentils',
    };

    final List<String> finalIngredients = List<String>.from(recipe.ingredients);
    final List<SubstitutionItem> subs = <SubstitutionItem>[];

    for (int i = 0; i < recipe.ingredients.length && subs.length < 2; i++) {
      final String ing = recipe.ingredients[i];
      final String token = _coreToken(ing);
      if (!swap.containsKey(token)) continue;

      final bool isMissing = missing.contains(token);
      final bool isAvailable = available.contains(token);
      final bool bitPick = pickBit(hash, i);

      // Rule: substitute if explicitly missing, or deterministically picked and not explicitly available.
      final bool doSub = isMissing || (bitPick && !isAvailable);
      if (!doSub) continue;

      final String to = swap[token]!;
      subs.add(SubstitutionItem(from: ing, to: to, note: 'mock: availability-based'));
      finalIngredients[i] = _replaceToken(ing, token, to);
    }

    return SubstitutionResponse(finalIngredients: finalIngredients, substitutions: subs);
  }
}

/// Compute a stable 32-bit hash from normalized request fields.
int stableHash(SubstitutionRequest req) {
  final String normParams = _normalizedParams(req);
  final List<String> avail = List<String>.from(req.availableIds.map((e) => e.trim().toLowerCase()))..sort();
  final List<String> miss = List<String>.from(req.missingIds.map((e) => e.trim().toLowerCase()))..sort();
  final String payload = [
    req.recipeId.trim().toLowerCase(),
    'p:$normParams',
    'a:${avail.join(',')}',
    'm:${miss.join(',')}',
  ].join('|');
  return _fnv1a32(utf8.encode(payload));
}

/// Read param keys in a stable order; ignore unknown keys to be noise-stable.
String _normalizedParams(SubstitutionRequest req) {
  final String s = req.servings == null ? '' : req.servings.toString();
  final String t = req.time == null ? '' : req.time.toString();
  final String sp = req.spice?.name ?? '';
  return 'servings:$s,time:$t,spice:$sp';
}

/// Deterministically pick a bit out of the hash.
bool pickBit(int hash, int index) => ((hash >> (index % 32)) & 1) == 1;

/// Extract a coarse ingredient token for matching.
String _coreToken(String ingredient) {
  final lower = ingredient.toLowerCase();
  final match = RegExp(r'[a-z]+').allMatches(lower).map((m) => m.group(0)!).toList();
  // Heuristic: pick the last word (often the noun) as core token.
  return match.isEmpty ? lower.trim() : match.last;
}

String _replaceToken(String ingredient, String token, String replacement) {
  // Simple replacement: if token appears as a whole word, swap it; otherwise append replacement.
  final pattern = RegExp('(?<![a-zA-Z])${RegExp.escape(token)}(?![a-zA-Z])');
  if (pattern.hasMatch(ingredient.toLowerCase())) {
    return ingredient.replaceFirst(RegExp(token, caseSensitive: false), replacement);
  }
  return '$ingredient (swap: $replacement)';
}

int _fnv1a32(List<int> bytes) {
  const int fnvPrime = 0x01000193;
  const int fnvOffset = 0x811C9DC5;
  int hash = fnvOffset;
  for (final b in bytes) {
    hash ^= b;
    hash = (hash * fnvPrime) & 0xFFFFFFFF;
  }
  return hash;
}
