// TODO(legacy): Remove after MVP once all references are gone.
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/errors.dart';
import '../models/recipe.dart';

/// Loads recipes from a JSON asset, validates each, and returns the list.
/// If any items fail validation or parsing, throws [AggregateValidationError]
/// containing all underlying [RecipeValidationError]s, annotated with index
/// and best-effort line numbers.
Future<List<Recipe>> loadRecipesFromAsset(String path) async {
  final content = await rootBundle.loadString(path);
  dynamic jsonData;
  try {
    jsonData = json.decode(content);
  } catch (e) {
    throw RecipeValidationError(
      field: 'json',
      reason: 'Root is not valid JSON array',
      value: e.toString(),
    );
  }
  if (jsonData is! List) {
    throw RecipeValidationError(field: 'json', reason: 'Root must be a JSON array');
  }

  final errors = <RecipeValidationError>[];
  final recipes = <Recipe>[];
  for (var i = 0; i < jsonData.length; i++) {
    final item = jsonData[i];
    if (item is! Map<String, dynamic>) {
      errors.add(RecipeValidationError(
        field: 'json[$i]',
        reason: 'Item is not an object',
        value: item.runtimeType.toString(),
        index: i,
        line: _estimateObjectStartLine(content, i),
      ));
      continue;
    }
    try {
      recipes.add(Recipe.fromJson(item));
    } on AggregateValidationError catch (agg) {
      for (final e in agg.errors) {
        errors.add(RecipeValidationError(
          field: e.field,
          reason: e.reason,
          value: e.value,
          index: i,
          line: _estimateObjectStartLine(content, i),
        ));
      }
    } on RecipeValidationError catch (e) {
      errors.add(RecipeValidationError(
        field: e.field,
        reason: e.reason,
        value: e.value,
        index: i,
        line: _estimateObjectStartLine(content, i),
      ));
    } catch (e) {
      errors.add(RecipeValidationError(
        field: 'json[$i]',
        reason: 'Unknown error',
        value: e.toString(),
        index: i,
        line: _estimateObjectStartLine(content, i),
      ));
    }
  }

  if (errors.isNotEmpty) {
    throw AggregateValidationError(errors, context: path);
  }
  return recipes;
}

// Best-effort estimation: count opening braces of top-level array items
int? _estimateObjectStartLine(String content, int index) {
  try {
    int line = 1;
    int depth = 0;
    int itemIndex = -1;
    bool inString = false;
    bool escape = false;
    for (var i = 0; i < content.length; i++) {
      final ch = content.codeUnitAt(i);
      if (ch == 10 /* \n */) line++;
      final c = String.fromCharCode(ch);
      if (inString) {
        if (escape) {
          escape = false;
        } else if (c == '\\') {
          escape = true;
        } else if (c == '"') {
          inString = false;
        }
        continue;
      }
      if (c == '"') {
        inString = true;
        continue;
      }
      if (c == '[') {
        depth++;
        continue;
      }
      if (c == ']') {
        depth--;
        continue;
      }
      if (c == '{' && depth == 1) {
        itemIndex++;
        if (itemIndex == index) {
          return line;
        }
      }
    }
  } catch (_) {
    // ignore
  }
  return null;
}

