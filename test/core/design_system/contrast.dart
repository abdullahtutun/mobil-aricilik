import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.x kontrast oranı (1–21).
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (light, dark) = la > lb ? (la, lb) : (lb, la);
  return (light + 0.05) / (dark + 0.05);
}

void expectContrast(
  Color foreground,
  Color background, {
  required double atLeast,
  required String reason,
}) {
  expect(
    contrastRatio(foreground, background),
    greaterThanOrEqualTo(atLeast),
    reason: reason,
  );
}
