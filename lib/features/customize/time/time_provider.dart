import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'time_mode.dart';

final timeModeProvider = StateProvider.autoDispose
    .family<TimeMode, String>((ref, recipeId) => TimeMode.regular);

