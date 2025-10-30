/// Exception thrown when seed data fails validation or parsing.
class SeedLoadException implements Exception {
  SeedLoadException({
    required this.message,
    required this.errorCount,
    required this.validCount,
    required this.items,
  });

  final String message;
  final int errorCount;
  final int validCount;
  final List<SeedLoadErrorItem> items;

  @override
  String toString() {
    final buffer = StringBuffer()
      ..writeln('SeedLoadException: $message')
      ..writeln('Valid items: $validCount, Errors: $errorCount');
    final preview = items.take(3).toList();
    if (preview.isNotEmpty) {
      buffer.writeln('Error details (first ${preview.length}):');
      for (final item in preview) {
        buffer.writeln('  • [${item.index}] ${item.errors.join('; ')}');
      }
    }
    return buffer.toString().trimRight();
  }
}

/// Individual item error summary produced during seed validation.
class SeedLoadErrorItem {
  const SeedLoadErrorItem({required this.index, required this.errors});

  final int index;
  final List<String> errors;
}
