import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

import 'models.dart';

class IngredientCatalogService {
  IngredientCatalog? _catalog;
  final Map<String, IngredientCatalogItem> _byId = {};
  final Map<String, String> _aliasToId = {};

  Future<void> init({String assetPath = 'assets/ingredient_catalog.json'}) async {
    if (_catalog != null) return;

    // Ensure bindings so rootBundle works in tests and app bootstrap.
    WidgetsFlutterBinding.ensureInitialized();

    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _catalog = IngredientCatalog.fromJson(json);

    for (final item in _catalog!.items) {
      _byId[item.id] = item;
      for (final a in item.aliases) {
        _aliasToId[a.toLowerCase()] = item.id;
      }
    }
  }

  Future<void> ensureInitialized() async {
    if (!isReady) {
      await init();
    }
  }

  bool get isReady => _catalog != null;

  bool has(String id) => _byId.containsKey(id);

  /// Return display name for id (locale fallback order: locale.languageCode, then 'en', then id)
  String displayName(String id, {Locale? locale}) {
    final item = _byId[id];
    if (item == null) return id;
    final code = locale?.languageCode;
    if (code != null && item.names[code] != null) return item.names[code]!;
    if (item.names['en'] != null) return item.names['en']!;
    // any value or fallback to id
    return item.names.values.isNotEmpty ? item.names.values.first : id;
  }

  /// Return an ImageProvider for the ingredient, or null if none.
  /// Only explicit catalog image paths are used.
  ImageProvider? imageProvider(String id) {
    final item = _byId[id];
    final path = item?.image;
    if (path == null || path.isEmpty) return null;
    return AssetImage(path);
  }

  /// Try to map free text / alias to a canonical id; returns null if unknown.
  String? resolveId(String freeText) {
    final key = freeText.toLowerCase().trim();
    if (_byId.containsKey(key)) return key;
    return _aliasToId[key];
  }
}
