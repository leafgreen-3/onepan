enum RecipeMode { simple, ai }

extension RecipeModeX on RecipeMode {
  static RecipeMode fromQuery(String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'ai':
        return RecipeMode.ai;
      case 'simple':
      default:
        return RecipeMode.simple;
    }
  }

  String get label => this == RecipeMode.ai ? 'AI' : 'Simple';
}

