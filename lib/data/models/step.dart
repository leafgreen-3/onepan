/// Represents a step in the recipe directions for the v1 seed schema.
class StepItem {
  const StepItem({
    required this.num,
    required this.text,
    this.timerSec,
    this.temperatureC,
  });

  final int num;
  final String text;
  final int? timerSec;
  final int? temperatureC;

  factory StepItem.fromJson(Map<String, dynamic> json) {
    final Object? rawNum = json['num'];
    final int stepNum = rawNum is int
        ? rawNum
        : rawNum is double
            ? rawNum.toInt()
            : 0;

    final Object? rawTimer = json['timerSec'];
    final int? stepTimer = rawTimer is int
        ? rawTimer
        : rawTimer is double
            ? rawTimer.toInt()
            : null;

    final Object? rawTemp = json['temperatureC'];
    final int? stepTemp = rawTemp is int
        ? rawTemp
        : rawTemp is double
            ? rawTemp.toInt()
            : null;

    return StepItem(
      num: stepNum,
      text: (json['text'] ?? '') as String,
      timerSec: stepTimer,
      temperatureC: stepTemp,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'num': num,
      'text': text,
      if (timerSec != null) 'timerSec': timerSec,
      if (temperatureC != null) 'temperatureC': temperatureC,
    };
  }

  StepItem copyWith({
    int? num,
    String? text,
    int? timerSec,
    int? temperatureC,
  }) {
    return StepItem(
      num: num ?? this.num,
      text: text ?? this.text,
      timerSec: timerSec ?? this.timerSec,
      temperatureC: temperatureC ?? this.temperatureC,
    );
  }

  List<String> validate() {
    final errors = <String>[];
    if (num <= 0) {
      errors.add('Step num must be > 0.');
    }
    if (text.trim().isEmpty) {
      errors.add('Step text must be non-empty.');
    }
    if (timerSec != null && timerSec! < 0) {
      errors.add('Step timerSec must be >= 0 when provided.');
    }
    if (temperatureC != null && temperatureC! < 0) {
      errors.add('Step temperatureC must be >= 0 when provided.');
    }
    return errors;
  }

  @override
  int get hashCode => Object.hash(num, text, timerSec, temperatureC);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StepItem &&
            other.num == num &&
            other.text == text &&
            other.timerSec == timerSec &&
            other.temperatureC == temperatureC;
  }

  @override
  String toString() {
    return 'StepItem(num: $num, text: $text, timerSec: $timerSec, temperatureC: $temperatureC)';
  }
}
