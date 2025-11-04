import 'dart:convert';
import 'dart:io';

// Normalizes ingredient catalog display names (non-breaking):
// - Strips non-essential prep words (e.g., diced, chopped, fresh)
// - Applies Title Case (e.g., "RED BELL PEPPER" -> "Red Bell Pepper")
// - Ensures color/variant tokens in id (e.g., -red, -yellow) appear in name
//   if missing (e.g., onion-yellow -> "Yellow Onion").
//
// Usage: dart run tool/normalize_catalog_names.dart

const String kCatalogPath = 'assets/ingredient_catalog.json';

final Set<String> kPrepWords = <String>{
  'diced', 'chopped', 'minced', 'fresh', 'ripe', 'sliced', 'peeled', 'crushed',
};

final Map<String, String> kVariantWords = <String, String>{
  'red': 'Red',
  'yellow': 'Yellow',
  'green': 'Green',
  'black': 'Black',
  'white': 'White',
  'baby': 'Baby',
};

String _titleCase(String input) {
  if (input.trim().isEmpty) return input;
  final parts = input.split(RegExp(r"\s+"));
  return parts
      .map((w) => w.isEmpty
          ? w
          : (w[0].toUpperCase() + (w.length > 1 ? w.substring(1).toLowerCase() : '')))
      .join(' ')
      .trim();
}

String _normalizeNameFromExisting(String name) {
  // Lower for token ops; strip punctuation except hyphen and letters/spaces.
  final lower = name.toLowerCase();
  final cleaned = lower.replaceAll(RegExp(r"[^a-z\-\s]"), ' ');
  final tokens = cleaned.split(RegExp(r"\s+"));
  final kept = <String>[];
  for (final t in tokens) {
    if (t.isEmpty) continue;
    if (kPrepWords.contains(t)) continue;
    kept.add(t);
  }
  final result = kept.join(' ').replaceAll(RegExp(r"\s+"), ' ').trim();
  return _titleCase(result);
}

String _ensureVariantFromId(String id, String name) {
  final idTokens = id.split('-').toSet();
  final nameLower = name.toLowerCase();
  String out = name;
  for (final entry in kVariantWords.entries) {
    final tok = entry.key;
    final word = entry.value;
    if (idTokens.contains(tok) && !nameLower.contains(tok)) {
      out = '$word $out';
    }
  }
  return _titleCase(out.replaceAll(RegExp(r"\s+"), ' ').trim());
}

Future<void> main() async {
  final file = File(kCatalogPath);
  if (!await file.exists()) {
    stderr.writeln('ERROR: $kCatalogPath not found');
    exit(1);
  }
  final raw = await file.readAsString();
  final json = jsonDecode(raw);
  if (json is! Map<String, dynamic>) {
    stderr.writeln('ERROR: $kCatalogPath must be a JSON object');
    exit(1);
  }

  final List<dynamic> items = (json['items'] as List?)?.toList() ?? <dynamic>[];
  int changed = 0;
  for (final it in items) {
    if (it is! Map<String, dynamic>) continue;
    final id = (it['id'] ?? '').toString();
    final names = (it['names'] as Map?)?.map((k, v) => MapEntry('$k', '$v')) ?? <String, dynamic>{};
    final en = (names['en'] ?? '').toString();
    if (id.isEmpty) continue;
    final before = en;

    String next = en.isEmpty ? id : en;
    next = _normalizeNameFromExisting(next);
    next = _ensureVariantFromId(id, next);

    if (next != before) {
      names['en'] = next;
      it['names'] = names;
      changed++;
    }
  }

  // Pretty print back
  const encoder = JsonEncoder.withIndent('  ');
  final out = '${encoder.convert(<String, dynamic>{
    'version': json['version'] ?? 1,
    'items': items,
  })}\n';
  await file.writeAsString(out);
  stdout.writeln('Normalized catalog names. Changed $changed item(s).');
}
