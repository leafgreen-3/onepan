/// Represents a single ingredient in a recipe for the v1 seed schema.
class Ingredient {
  const Ingredient({
    required this.id,
    required this.qty,
    required this.unit,
    required this.category,
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
  final double qty;
  final String unit;
  final String category;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: (json['id'] ?? '') as String,
      // JSON number coercion: accept int or double
      qty: (json['qty'] as num).toDouble(),
      unit: (json['unit'] ?? '') as String,
      category: (json['category'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'qty': qty,
      'unit': unit,
      'category': category,
    };
  }

  Ingredient copyWith({
    String? id,
    double? qty,
    String? unit,
    String? category,
  }) {
    return Ingredient(
      id: id ?? this.id,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      category: category ?? this.category,
    );
  }

  List<String> validate() {
    final errors = <String>[];
    if (id.trim().isEmpty) {
      errors.add('Ingredient id must be non-empty.');
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
        qty,
        unit,
        category,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Ingredient &&
            other.id == id &&
            other.qty == qty &&
            other.unit == unit &&
            other.category == category;
  }

  @override
  String toString() {
    return 'Ingredient(id: $id, qty: $qty, unit: $unit, category: $category)';
  }
}
