import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'errors.dart';

part 'recipe.g.dart';

enum SpiceLevel { mild, medium, hot, inferno }

@JsonSerializable(explicitToJson: true)
class Recipe {
  final String id;
  final String title;
  final String? subtitle;
  final List<String> tags;
  final int minutes;
  final int servings;
  final SpiceLevel spice;
  final String? image;
  final List<String> ingredients;
  final List<String> steps;
  final String version;
  final DateTime? updatedAt;

  const Recipe._({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.minutes,
    required this.servings,
    required this.spice,
    required this.image,
    required this.ingredients,
    required this.steps,
    required this.version,
    required this.updatedAt,
  });

  factory Recipe({
    required String id,
    required String title,
    String? subtitle,
    List<String> tags = const [],
    required int minutes,
    required int servings,
    required SpiceLevel spice,
    String? image,
    required List<String> ingredients,
    required List<String> steps,
    String version = '1.0',
    DateTime? updatedAt,
  }) {
    final normalizedTags = normalizeTags(tags);
    final normalizedIngredients = ingredients.map((e) => e.trim()).toList();
    final normalizedSteps = steps.map((e) => e.trim()).toList();
    final trimmedTitle = title.trim();
    final Recipe candidate = Recipe._(
      id: id,
      title: trimmedTitle,
      subtitle: subtitle,
      tags: normalizedTags,
      minutes: minutes,
      servings: servings,
      spice: spice,
      image: image,
      ingredients: normalizedIngredients,
      steps: normalizedSteps,
      version: version,
      updatedAt: updatedAt,
    );
    candidate._validate();
    return candidate;
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    try {
      final recipe = _$RecipeFromJson(json);
      // normalize via factory to enforce all invariants
      return Recipe(
        id: recipe.id,
        title: recipe.title,
        subtitle: recipe.subtitle,
        tags: recipe.tags,
        minutes: recipe.minutes,
        servings: recipe.servings,
        spice: recipe.spice,
        image: recipe.image,
        ingredients: recipe.ingredients,
        steps: recipe.steps,
        version: recipe.version,
        updatedAt: recipe.updatedAt,
      );
    } on RecipeValidationError {
      rethrow;
    } catch (e) {
      throw RecipeValidationError(field: 'json', reason: 'Invalid recipe JSON', value: e.toString());
    }
  }

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  static String idFromTitle(String title) {
    final slug = _slugify(title);
    final hash = _fnv1a32(title);
    final short = hash.toRadixString(36).padLeft(7, '0').substring(0, 7);
    return '$slug-$short';
  }

  static List<String> normalizeTags(List<String> tags) {
    final set = <String>{};
    for (final t in tags) {
      final v = t.trim().toLowerCase();
      if (v.isNotEmpty) set.add(v);
    }
    final list = set.toList()..sort();
    return list;
  }

  void _validate() {
    final errors = <RecipeValidationError>[];

    // id
    final idRegex = RegExp(r'^[a-z0-9-_.]+$');
    if (id.isEmpty) {
      errors.add(RecipeValidationError(field: 'id', reason: 'must be non-empty'));
    } else {
      if (id.length > 60) {
        errors.add(RecipeValidationError(field: 'id', reason: 'must be <= 60 chars', value: id));
      }
      if (!idRegex.hasMatch(id)) {
        errors.add(RecipeValidationError(field: 'id', reason: 'invalid characters; use [a-z0-9-_.]', value: id));
      }
    }

    // title
    if (title.isEmpty || title.length > 120) {
      errors.add(RecipeValidationError(field: 'title', reason: 'length must be 1..120', value: title));
    }

    // subtitle
    if (subtitle != null && subtitle!.length > 140) {
      errors.add(RecipeValidationError(field: 'subtitle', reason: 'length must be <= 140', value: subtitle));
    }

    // minutes
    if (minutes < 1 || minutes > 240) {
      errors.add(RecipeValidationError(field: 'minutes', reason: 'must be 1..240', value: minutes));
    }

    // servings
    if (servings < 1 || servings > 12) {
      errors.add(RecipeValidationError(field: 'servings', reason: 'must be 1..12', value: servings));
    }

    // image
    if (image?.isNotEmpty == true) {
      final v = image!;
      if (v.startsWith('http')) {
        final uri = Uri.tryParse(v);
        if (uri == null || !(uri.isScheme('http') || uri.isScheme('https')) || uri.host.isEmpty) {
          errors.add(RecipeValidationError(field: 'image', reason: 'invalid URL', value: v));
        }
      } else {
        final lower = v.toLowerCase();
        final ok = lower.endsWith('.png') ||
            lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg') ||
            lower.endsWith('.webp') ||
            lower.endsWith('.gif') ||
            lower.endsWith('.svg');
        if (!ok) {
          errors.add(RecipeValidationError(field: 'image', reason: 'must end with a common image extension', value: v));
        }
      }
    }

    // tags: 0..12, each 1..20, lowercase, deduped
    if (tags.length > 12) {
      errors.add(RecipeValidationError(field: 'tags', reason: 'no more than 12 tags', value: tags));
    }
    for (final t in tags) {
      if (t.isEmpty || t.length > 20) {
        errors.add(RecipeValidationError(field: 'tags', reason: 'each tag length must be 1..20', value: t));
      }
      if (t != t.toLowerCase()) {
        errors.add(RecipeValidationError(field: 'tags', reason: 'tags must be lowercase', value: t));
      }
    }
    if (!_isDedupeSorted(tags)) {
      errors.add(RecipeValidationError(field: 'tags', reason: 'tags must be deduped and sorted', value: tags));
    }

    // ingredients
    if (ingredients.isEmpty) {
      errors.add(RecipeValidationError(field: 'ingredients', reason: 'must be non-empty list'));
    }
    for (final ing in ingredients) {
      if (ing.isEmpty || ing.length > 100) {
        errors.add(RecipeValidationError(field: 'ingredients', reason: 'each must be 1..100 chars', value: ing));
      }
    }

    // steps
    if (steps.isEmpty) {
      errors.add(RecipeValidationError(field: 'steps', reason: 'must be non-empty list'));
    }
    for (final step in steps) {
      if (step.isEmpty || step.length > 400) {
        errors.add(RecipeValidationError(field: 'steps', reason: 'each must be 1..400 chars', value: step));
      }
    }

    // version
    if (version != '1.0') {
      errors.add(RecipeValidationError(field: 'version', reason: 'must equal 1.0', value: version));
    }

    if (errors.isNotEmpty) {
      throw AggregateValidationError(errors, context: 'Recipe');
    }
  }

  static bool _isDedupeSorted(List<String> items) {
    final seen = <String>{};
    String? prev;
    for (final v in items) {
      if (seen.contains(v)) return false;
      seen.add(v);
      if (prev != null && v.compareTo(prev!) < 0) return false;
      prev = v;
    }
    return true;
  }

  static String _slugify(String input) {
    final lower = input.toLowerCase();
    final buffer = StringBuffer();
    bool prevDash = false;
    for (final codeUnit in lower.codeUnits) {
      final c = String.fromCharCode(codeUnit);
      final isAlnum = (codeUnit >= 48 && codeUnit <= 57) || // 0-9
          (codeUnit >= 97 && codeUnit <= 122); // a-z
      if (isAlnum) {
        buffer.write(c);
        prevDash = false;
      } else {
        if (!prevDash) {
          buffer.write('-');
          prevDash = true;
        }
      }
    }
    var slug = buffer.toString().replaceAll(RegExp(r'-{2,}'), '-');
    slug = slug.replaceAll(RegExp(r'^-+'), '').replaceAll(RegExp(r'-+$'), '');
    if (slug.isEmpty) slug = 'recipe';
    if (slug.length > 40) slug = slug.substring(0, 40);
    return slug;
  }

  static int _fnv1a32(String input) {
    const int fnvPrime = 0x01000193;
    const int fnvOffset = 0x811C9DC5;
    int hash = fnvOffset;
    for (final byte in utf8.encode(input)) {
      hash ^= byte;
      hash = (hash * fnvPrime) & 0xFFFFFFFF;
    }
    return hash;
  }
}
