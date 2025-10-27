import 'package:json_annotation/json_annotation.dart';

import 'package:onepan/models/errors.dart';
import 'package:onepan/models/recipe.dart';

part 'substitution.g.dart';

@JsonSerializable()
class SubstitutionRequest {
  final String recipeId;
  final Map<String, dynamic> params;
  final List<String> availableIds;
  final List<String> missingIds;

  const SubstitutionRequest({
    required this.recipeId,
    this.params = const {},
    this.availableIds = const [],
    this.missingIds = const [],
  });

  /// Convenience getters with loose typing safeguards.
  int? get servings => _readInt('servings');
  int? get time => _readInt('time');
  SpiceLevel? get spice => _readSpice('spice');

  void validate() {
    if (recipeId.trim().isEmpty) {
      throw RecipeValidationError(field: 'recipeId', reason: 'must be non-empty');
    }
    final s = servings;
    if (s != null && s <= 0) {
      throw RecipeValidationError(field: 'params.servings', reason: 'must be > 0', value: s);
    }
    final t = time;
    if (t != null && t < 0) {
      throw RecipeValidationError(field: 'params.time', reason: 'must be >= 0', value: t);
    }
    // Ensure ids are simple non-empty tokens and not in both lists.
    final a = availableIds.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final m = missingIds.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final overlap = a.toSet().intersection(m.toSet());
    if (overlap.isNotEmpty) {
      throw RecipeValidationError(
        field: 'availableIds/missingIds',
        reason: 'same id present in both',
        value: overlap.join(','),
      );
    }
  }

  int? _readInt(String key) {
    final v = params[key];
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final parsed = int.tryParse(v);
      return parsed;
    }
    return null;
  }

  SpiceLevel? _readSpice(String key) {
    final v = params[key];
    if (v == null) return null;
    if (v is SpiceLevel) return v;
    if (v is String) {
      final norm = v.trim().toLowerCase();
      for (final s in SpiceLevel.values) {
        if (s.name == norm) return s;
      }
    }
    return null;
  }

  factory SubstitutionRequest.fromJson(Map<String, dynamic> json) => _$SubstitutionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SubstitutionRequestToJson(this);
}

@JsonSerializable()
class SubstitutionItem {
  final String from;
  final String to;
  final String note;

  const SubstitutionItem({required this.from, required this.to, this.note = ''});

  factory SubstitutionItem.fromJson(Map<String, dynamic> json) => _$SubstitutionItemFromJson(json);
  Map<String, dynamic> toJson() => _$SubstitutionItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SubstitutionResponse {
  final List<String> finalIngredients;
  final List<SubstitutionItem> substitutions;

  const SubstitutionResponse({
    required this.finalIngredients,
    this.substitutions = const [],
  });

  factory SubstitutionResponse.fromJson(Map<String, dynamic> json) => _$SubstitutionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SubstitutionResponseToJson(this);
}

