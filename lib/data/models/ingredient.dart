/// Represents a single ingredient in a recipe for the v1 seed schema.
class Ingredient {
  const Ingredient({
    required this.id,
    required this.name,
    required this.qty,
    required this.unit,
    required this.category,
    this.thumbAsset,
    this.thumbUrl,
  });

  static const allowedUnits = <String>{
    'g',
    'ml',
    'tbsp',
    'tsp',
    'cup',
    'piece',
  };

  static const allowedCategories = <String>{
    'core',
    'protein',
    'vegetable',
    'spice',
    'other',
  };

  final String id;
  final String name;
  final double qty;
  final String unit;
  final String category;
  final String? thumbAsset;
  final String? thumbUrl;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      // JSON number coercion: accept int or double
      qty: (json['qty'] as num).toDouble(),
      unit: (json['unit'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      thumbAsset: json['thumbAsset'] as String?,
      thumbUrl: json['thumbUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'qty': qty,
      'unit': unit,
      'category': category,
      if (thumbAsset != null) 'thumbAsset': thumbAsset,
      if (thumbUrl != null) 'thumbUrl': thumbUrl,
    };
  }

  Ingredient copyWith({
    String? id,
    String? name,
    double? qty,
    String? unit,
    String? category,
    String? thumbAsset,
    String? thumbUrl,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      thumbAsset: thumbAsset ?? this.thumbAsset,
      thumbUrl: thumbUrl ?? this.thumbUrl,
    );
  }

  List<String> validate() {
    final errors = <String>[];
    if (id.trim().isEmpty) {
      errors.add('Ingredient id must be non-empty.');
    }
    if (name.trim().isEmpty) {
      errors.add('Ingredient name must be non-empty.');
    }
    if (qty.isNaN || qty.isNegative) {
      errors.add('Ingredient qty must be zero or positive.');
    }
    if (!allowedUnits.contains(unit)) {
      errors.add('Ingredient unit "$unit" is not supported.');
    }
    if (!allowedCategories.contains(category)) {
      errors.add('Ingredient category "$category" is not supported.');
    }
    return errors;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        qty,
        unit,
        category,
        thumbAsset,
        thumbUrl,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Ingredient &&
            other.id == id &&
            other.name == name &&
            other.qty == qty &&
            other.unit == unit &&
            other.category == category &&
            other.thumbAsset == thumbAsset &&
            other.thumbUrl == thumbUrl;
  }

  @override
  String toString() {
    return 'Ingredient(id: $id, name: $name, qty: $qty, unit: $unit, category: $category)';
  }
}
