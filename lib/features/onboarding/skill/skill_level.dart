enum SkillLevel {
  beginner,
  intermediate,
  advanced,
}

extension SkillLevelX on SkillLevel {
  String get title => switch (this) {
        SkillLevel.beginner => 'Beginner',
        SkillLevel.intermediate => 'Intermediate',
        SkillLevel.advanced => 'Advanced',
      };

  String get subtitle => switch (this) {
        SkillLevel.beginner => '“I’m new / want clearer guidance”',
        SkillLevel.intermediate => '“I cook sometimes and understand basics”',
        SkillLevel.advanced => '“I’m comfortable improvising”',
      };
}

