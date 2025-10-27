// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      minutes: (json['minutes'] as num).toInt(),
      servings: (json['servings'] as num).toInt(),
      spice: $enumDecode(_$SpiceLevelEnumMap, json['spice']),
      image: json['image'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      version: json['version'] as String? ?? '1.0',
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'tags': instance.tags,
      'minutes': instance.minutes,
      'servings': instance.servings,
      'spice': _$SpiceLevelEnumMap[instance.spice]!,
      'image': instance.image,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'version': instance.version,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$SpiceLevelEnumMap = {
  SpiceLevel.mild: 'mild',
  SpiceLevel.medium: 'medium',
  SpiceLevel.hot: 'hot',
  SpiceLevel.inferno: 'inferno',
};
