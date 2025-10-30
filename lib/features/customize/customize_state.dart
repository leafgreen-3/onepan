import 'package:flutter/foundation.dart';

@immutable
class CustomizeState {
  final int servings; // 1..6 (default 2)
  final String time; // "fast" | "regular" (default "regular")
  final String spice; // "mild" | "medium" | "spicy" (default "medium")

  const CustomizeState({
    this.servings = 2,
    this.time = 'regular',
    this.spice = 'medium',
  });

  CustomizeState copyWith({int? servings, String? time, String? spice}) {
    return CustomizeState(
      servings: servings ?? this.servings,
      time: time ?? this.time,
      spice: spice ?? this.spice,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomizeState &&
        other.servings == servings &&
        other.time == time &&
        other.spice == spice;
  }

  @override
  int get hashCode => Object.hash(servings, time, spice);
}

