import 'dart:convert';
import 'dart:io';

/// Script to merge ingredient IDs from assets/recipes.json into
/// assets/ingredient_catalog.json, appending stub entries for any missing IDs.
///
/// Usage:
///   dart run tool/generate_catalog.dart
Future<void> main(List<String> args) async {
  const recipesPath = 'assets/recipes.json';
  const catalogPath = 'assets/ingredient_catalog.json';

  final recipesFile = File(recipesPath);
  final catalogFile = File(catalogPath);

  if (!await recipesFile.exists()) {
    stderr.writeln('ERROR: $recipesPath not found.');
    exitCode = 1;
    return;
  }
  if (!await catalogFile.exists()) {
    stderr.writeln('ERROR: $catalogPath not found.');
    exitCode = 1;
    return;
  }

  // Read and parse recipes
  final recipesRaw = await recipesFile.readAsString();
  final recipesJson = jsonDecode(recipesRaw);
  if (recipesJson is! List) {
    stderr.writeln('ERROR: $recipesPath must be a JSON array.');
    exitCode = 1;
    return;
  }

  final Map<String, String> idToName = <String, String>{};
  for (final r in recipesJson) {
    if (r is! Map<String, dynamic>) continue;
    final ingredients = r['ingredients'];
    if (ingredients is! List) continue;
    for (final ing in ingredients) {
      if (ing is! Map<String, dynamic>) continue;
      final String id = (ing['id'] ?? '').toString();
      if (id.isEmpty) continue;
      final String name = (ing['name'] ?? id).toString();
      idToName.putIfAbsent(id, () => name);
    }
  }

  // Read and parse existing catalog
  final catalogRaw = await catalogFile.readAsString();
  final catalogJson = jsonDecode(catalogRaw);
  if (catalogJson is! Map<String, dynamic>) {
    stderr.writeln('ERROR: $catalogPath must be a JSON object.');
    exitCode = 1;
    return;
  }

  final int version = (catalogJson['version'] as int?) ?? 1;
  final List<dynamic> items = (catalogJson['items'] as List?)?.toList() ?? <dynamic>[];

  // Build index of existing items by id
  final Map<String, Map<String, dynamic>> existingById = <String, Map<String, dynamic>>{};
  for (final it in items) {
    if (it is Map<String, dynamic>) {
      final String id = (it['id'] ?? '').toString();
      if (id.isNotEmpty) existingById[id] = it;
    }
  }

  // Append stubs for missing IDs collected from recipes
  int added = 0;
  for (final entry in idToName.entries) {
    final id = entry.key;
    if (existingById.containsKey(id)) continue;
    final name = entry.value.isNotEmpty ? entry.value : id;
    final stub = <String, dynamic>{
      'id': id,
      'names': <String, String>{'en': name},
      'image': '',
      'aliases': <String>[],
    };
    items.add(stub);
    added++;
  }

  // Sort by id
  items.sort((a, b) {
    final String ai = (a is Map && a['id'] != null) ? a['id'].toString() : '';
    final String bi = (b is Map && b['id'] != null) ? b['id'].toString() : '';
    return ai.compareTo(bi);
  });

  final Map<String, dynamic> merged = <String, dynamic>{
    'version': version,
    'items': items,
  };

  const encoder = JsonEncoder.withIndent('  ');
  final out = '${encoder.convert(merged)}\n';
  await catalogFile.writeAsString(out);

  stdout.writeln('Updated $catalogPath. Added $added new item(s). Total: ${items.length}.');
}
