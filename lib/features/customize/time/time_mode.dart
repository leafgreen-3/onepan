enum TimeMode {
  regular,
  fast,
}

extension TimeModeX on TimeMode {
  int get index2 => this == TimeMode.regular ? 0 : 1;
  static TimeMode fromIndex2(int i) => i == 0 ? TimeMode.regular : TimeMode.fast;

  String get title => this == TimeMode.regular ? 'Regular' : 'Fast';
  String get subtitle => this == TimeMode.regular
      ? 'Standard steps · Best flavor'
      : 'Simplified steps · Ready sooner';
  String get icon => this == TimeMode.regular ? '⏳' : '⚡';
}

