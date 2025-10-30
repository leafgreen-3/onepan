import 'ingredient.dart';
import 'step.dart';

/// Root recipe DTO used for the seed data set (schema version 1).
class Recipe {
  const Recipe({
    required this.schemaVersion,
    required this.id,
    required this.title,
    required this.timeTotalMin,
    required this.diet,
    required this.imageAsset,
    this.imageUrl,
    required this.ingredients,
    required this.steps,
  });

  static const allowedDiets = <String>{'veg', 'nonveg'};

  final int schemaVersion;
  final String id;
  final String title;
  final int timeTotalMin;
  final String diet;
  final String imageAsset;
  final String? imageUrl;
  final List<Ingredient> ingredients;
  final List<StepItem> steps;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredientsJson = json['ingredients'] as List<dynamic>?;
    final stepsJson = json['steps'] as List<dynamic>?;
    return Recipe(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 0,
      id: (json['id'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      timeTotalMin: (json['timeTotalMin'] as num?)?.toInt() ?? 0,
      diet: (json['diet'] ?? '') as String,
      imageAsset: (json['imageAsset'] ?? '') as String,
      imageUrl: json['imageUrl'] as String?,
      ingredients: ingredientsJson == null
          ? const []
          : ingredientsJson
              .whereType<Map<String, dynamic>>()
              .map(Ingredient.fromJson)
              .toList(growable: false),
      steps: stepsJson == null
          ? const []
          : stepsJson
              .whereType<Map<String, dynamic>>()
              .map(StepItem.fromJson)
              .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'schemaVersion': schemaVersion,
      'id': id,
      'title': title,
      'timeTotalMin': timeTotalMin,
      'diet': diet,
      'imageAsset': imageAsset,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }

  Recipe copyWith({
    int? schemaVersion,
    String? id,
    String? title,
    int? timeTotalMin,
    String? diet,
    String? imageAsset,
    String? imageUrl,
    List<Ingredient>? ingredients,
    List<StepItem>? steps,
  }) {
    return Recipe(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      id: id ?? this.id,
      title: title ?? this.title,
      timeTotalMin: timeTotalMin ?? this.timeTotalMin,
      diet: diet ?? this.diet,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }

  List<String> validate() {
    final errors = <String>[];
    if (schemaVersion != 1) {
      errors.add('Recipe schemaVersion must be 1 (found $schemaVersion).');
    }
    if (id.trim().isEmpty) {
      errors.add('Recipe id must be non-empty.');
    }
    if (title.trim().isEmpty) {
      errors.add('Recipe title must be non-empty.');
    }
    if (timeTotalMin <= 0) {
      errors.add('Recipe timeTotalMin must be > 0.');
    }
    if (!allowedDiets.contains(diet)) {
      errors.add('Recipe diet "$diet" is not supported.');
    }
    if (imageAsset.trim().isEmpty) {
      errors.add('Recipe imageAsset must be non-empty.');
    }
    if (ingredients.isEmpty) {
      errors.add('Recipe must have at least one ingredient.');
    }
    for (var i = 0; i < ingredients.length; i++) {
      final ingredientErrors = ingredients[i].validate();
      for (final error in ingredientErrors) {
        errors.add('ingredient[$i]: $error');
      }
    }
    if (steps.isEmpty) {
      errors.add('Recipe must have at least one step.');
    }
    for (var i = 0; i < steps.length; i++) {
      final stepErrors = steps[i].validate();
      for (final error in stepErrors) {
        errors.add('step[$i]: $error');
      }
    }
    return errors;
  }

  @override
  int get hashCode => Object.hash(
        schemaVersion,
        id,
        title,
        timeTotalMin,
        diet,
        imageAsset,
        imageUrl,
        Object.hashAll(ingredients),
        Object.hashAll(steps),
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Recipe &&
            other.schemaVersion == schemaVersion &&
            other.id == id &&
            other.title == title &&
            other.timeTotalMin == timeTotalMin &&
            other.diet == diet &&
            other.imageAsset == imageAsset &&
            other.imageUrl == imageUrl &&
            _listEquals(other.ingredients, ingredients) &&
            _listEquals(other.steps, steps);
  }

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, timeTotalMin: $timeTotalMin, diet: $diet)';
  }
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
