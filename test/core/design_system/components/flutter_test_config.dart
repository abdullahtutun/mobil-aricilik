import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Bu klasördeki testler gerçek yazı tipleriyle (Inter, Material Icons)
/// çizilsin; varsayılan test yazı tipi her harfi kutu yapar ve golden
/// görüntüler gözle incelenemez.
///
/// Yazı çizimi platforma göre piksel düzeyinde değişebilir; goldenlar
/// macOS'ta üretildi.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final manifest = jsonDecode(
    await rootBundle.loadString('FontManifest.json'),
  ) as List<dynamic>;
  for (final family in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(family['family'] as String);
    final fonts = (family['fonts'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    for (final font in fonts) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }

  await testMain();
}
