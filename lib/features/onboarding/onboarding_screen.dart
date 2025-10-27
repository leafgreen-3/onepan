import 'package:flutter/widgets.dart';

import 'step_country.dart';

export 'step_country.dart';
export 'step_diet.dart';
export 'step_level.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingCountryScreen();
  }
}
