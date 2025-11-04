class IngredientCatalogItem {
  final String id;
  final Map<String, String> names; // locale -> name
  final String? image; // asset path
  final List<String> aliases;

  IngredientCatalogItem({
    required this.id,
    required this.names,
    required this.image,
    required this.aliases,
  });

  factory IngredientCatalogItem.fromJson(Map<String, dynamic> j) =>
      IngredientCatalogItem(
        id: j['id'] as String,
        names: (j['names'] as Map).map(
          (k, v) => MapEntry('$k', '$v'),
        ),
        image: j['image'] as String?,
        aliases:
            (j['aliases'] as List?)?.map((e) => '$e').toList() ?? const [],
      );
}

class IngredientCatalog {
  final int version;
  final List<IngredientCatalogItem> items;
  IngredientCatalog({required this.version, required this.items});

  factory IngredientCatalog.fromJson(Map<String, dynamic> j) =>
      IngredientCatalog(
        version: j['version'] as int? ?? 1,
        items: ((j['items'] as List?) ?? const [])
            .map((e) =>
                IngredientCatalogItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

