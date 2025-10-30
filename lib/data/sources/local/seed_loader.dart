import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../core/seed_load_exception.dart';
import '../../models/recipe.dart';

/// Loads recipe seeds from bundled JSON and validates them.
class SeedLoader {
  SeedLoader({AssetBundle? bundle, String assetPath = 'assets/recipes.json'})
      : _bundle = bundle ?? rootBundle,
        _assetPath = assetPath,
        _overrideJson = null;

  SeedLoader.fromString(String json)
      : _bundle = rootBundle,
        _assetPath = '',
        _overrideJson = json;

  final AssetBundle _bundle;
  final String _assetPath;
  final String? _overrideJson;

  Future<List<Recipe>> load() async {
    final rawJson = _overrideJson ?? await _bundle.loadString(_assetPath);
    return _parse(rawJson);
  }

  Future<List<Recipe>> _parse(String jsonString) async {
    dynamic decoded;
    try {
      decoded = jsonDecode(jsonString);
    } catch (error) {
      throw SeedLoadException(
        message: 'Seed JSON is not valid.',
        errorCount: 1,
        validCount: 0,
        items: const [
          SeedLoadErrorItem(index: -1, errors: ['Root JSON must be an array.']),
        ],
      );
    }

    if (decoded is! List) {
      throw SeedLoadException(
        message: 'Seed JSON root must be a list.',
        errorCount: 1,
        validCount: 0,
        items: const [
          SeedLoadErrorItem(index: -1, errors: ['Root JSON must be an array.']),
        ],
      );
    }

    final recipes = <Recipe>[];
    final errors = <SeedLoadErrorItem>[];

    for (var i = 0; i < decoded.length; i++) {
      final entry = decoded[i];
      if (entry is! Map<String, dynamic>) {
        errors.add(
          SeedLoadErrorItem(
            index: i,
            errors: ['Item is not an object (found ${entry.runtimeType}).'],
          ),
        );
        continue;
      }

      try {
        final recipe = Recipe.fromJson(entry);
        final validationErrors = recipe.validate();
        if (validationErrors.isEmpty) {
          recipes.add(recipe);
        } else {
          errors.add(SeedLoadErrorItem(index: i, errors: validationErrors));
        }
      } catch (error) {
        errors.add(
          SeedLoadErrorItem(
            index: i,
            errors: ['Failed to parse recipe: ${error.toString()}'],
          ),
        );
      }
    }

    if (errors.isNotEmpty) {
      throw SeedLoadException(
        message: 'Seed data contained ${errors.length} invalid item(s).',
        errorCount: errors.length,
        validCount: recipes.length,
        items: errors,
      );
    }

    return recipes;
  }
}
