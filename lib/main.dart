import 'package:flutter/material.dart';
import 'package:onepan/app/app.dart';
import 'package:onepan/di/locator.dart';
export 'package:onepan/app/app.dart';

void main() {
  // Set up dependency injection
  setupLocator();
  runApp(const OnePanApp());
}
