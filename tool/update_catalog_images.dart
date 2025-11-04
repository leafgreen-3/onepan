import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final overwrite = args.contains('--overwrite');

  const catalogPath = 'assets/ingredient_catalog.json';
  final imgDir = Directory('assets/ingredients');

  if (!imgDir.existsSync()) {
    stderr.writeln('❌ ${imgDir.path} not found. Create it and add images first.');
    exit(1);
  }

  const allowedExt = <String>{'.png', '.jpg', '.jpeg', '.webp', '.svg'};

  final files = <String, String>{}; // id -> path
  for (final f in imgDir.listSync(recursive: false).whereType<File>()) {
    final name = f.uri.pathSegments.last;
    final dot = name.lastIndexOf('.');
    if (dot <= 0) continue;
    final base = name.substring(0, dot);
    final ext = name.substring(dot).toLowerCase();
    if (!allowedExt.contains(ext)) continue;
    files[base] = 'assets/ingredients/$name';
  }

  if (files.isEmpty) {
    stdout.writeln('ℹ️ No image files found in ${imgDir.path}. Nothing to do.');
    return;
  }

  final catalogFile = File(catalogPath);
  if (!catalogFile.existsSync()) {
    stderr.writeln('❌ $catalogPath not found.');
    exit(1);
  }
  final catalogJson = jsonDecode(await catalogFile.readAsString()) as Map<String, dynamic>;
  final items = (catalogJson['items'] as List).cast<Map<String, dynamic>>();

  var updated = 0;
  var matched = 0;
  for (final item in items) {
    final id = (item['id'] as String).trim();
    if (id.isEmpty) continue;
    final path = files[id];
    if (path == null) continue;
    matched++;

    final current = (item['image'] as String?) ?? '';
    if (current.isEmpty || overwrite) {
      item['image'] = path;
      updated++;
    }
  }

  // Sort items by id for stable diffs
  items.sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
  // Pretty print
  const encoder = JsonEncoder.withIndent('  ');
  await catalogFile.writeAsString('${encoder.convert(catalogJson)}\n');

  stdout.writeln('✅ Sync complete. Matched: $matched, Updated: $updated, Total items: ${items.length}');
  if (!overwrite) {
    stdout.writeln('ℹ️ Use --overwrite to replace existing image paths when needed.');
  }
}
