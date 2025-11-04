import 'package:riverpod/riverpod.dart';

import 'skill_level.dart';

// Onboarding-wide (not per recipe)
final skillLevelProvider = StateProvider<SkillLevel?>((ref) => null);

