enum SpiceLevel {
  mild,
  medium,
  spicy,
}

extension SpiceLevelX on SpiceLevel {
  int get index3 => switch (this) {
        SpiceLevel.mild => 0,
        SpiceLevel.medium => 1,
        SpiceLevel.spicy => 2,
      };

  static SpiceLevel fromIndex3(int i) => switch (i) {
        0 => SpiceLevel.mild,
        1 => SpiceLevel.medium,
        _ => SpiceLevel.spicy,
      };

  String get label => switch (this) {
        SpiceLevel.mild => 'Mild',
        SpiceLevel.medium => 'Medium',
        SpiceLevel.spicy => 'Spicy',
      };
}

