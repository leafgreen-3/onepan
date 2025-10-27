// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'substitution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubstitutionRequest _$SubstitutionRequestFromJson(Map<String, dynamic> json) =>
    SubstitutionRequest(
      recipeId: json['recipeId'] as String,
      params: json['params'] as Map<String, dynamic>? ?? const {},
      availableIds: (json['availableIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      missingIds: (json['missingIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SubstitutionRequestToJson(
        SubstitutionRequest instance) =>
    <String, dynamic>{
      'recipeId': instance.recipeId,
      'params': instance.params,
      'availableIds': instance.availableIds,
      'missingIds': instance.missingIds,
    };

SubstitutionItem _$SubstitutionItemFromJson(Map<String, dynamic> json) =>
    SubstitutionItem(
      from: json['from'] as String,
      to: json['to'] as String,
      note: json['note'] as String? ?? '',
    );

Map<String, dynamic> _$SubstitutionItemToJson(SubstitutionItem instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'note': instance.note,
    };

SubstitutionResponse _$SubstitutionResponseFromJson(
        Map<String, dynamic> json) =>
    SubstitutionResponse(
      finalIngredients: (json['finalIngredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      substitutions: (json['substitutions'] as List<dynamic>?)
              ?.map((e) => SubstitutionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SubstitutionResponseToJson(
        SubstitutionResponse instance) =>
    <String, dynamic>{
      'finalIngredients': instance.finalIngredients,
      'substitutions': instance.substitutions.map((e) => e.toJson()).toList(),
    };
