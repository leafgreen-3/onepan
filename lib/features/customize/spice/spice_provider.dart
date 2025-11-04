import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'spice_level.dart';

final spiceLevelProvider = StateProvider.autoDispose
    .family<SpiceLevel, String>((ref, recipeId) => SpiceLevel.medium);
