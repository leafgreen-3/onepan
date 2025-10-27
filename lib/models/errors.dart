class RecipeValidationError implements Exception {
  final String field;
  final String reason;
  final Object? value;
  final int? index; // optional index in a list (e.g., loader position)
  final int? line; // optional line number in source (best-effort)

  RecipeValidationError({
    required this.field,
    required this.reason,
    this.value,
    this.index,
    this.line,
  });

  @override
  String toString() {
    final location = [
      if (index != null) 'index=$index',
      if (line != null) 'line=$line',
    ].join(', ');
    final loc = location.isEmpty ? '' : ' ($location)';
    return 'RecipeValidationError{field=$field, reason=$reason, value=$value}$loc';
  }
}

class AggregateValidationError implements Exception {
  final List<RecipeValidationError> errors;
  final String? context;

  AggregateValidationError(this.errors, {this.context});

  @override
  String toString() {
    final header = context == null
        ? 'AggregateValidationError: ${errors.length} error(s)'
        : 'AggregateValidationError[$context]: ${errors.length} error(s)';
    final details = errors.map((e) => '- $e').join('\n');
    return '$header\n$details';
  }
}

