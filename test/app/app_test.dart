import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/app/app.dart';

void main() {
  group('App', () {
    testWidgets('açılışta uygulama adını gösterir', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      expect(find.text('Mobil Arıcılık'), findsOneWidget);
    });

    testWidgets('Türkçe yerelde de uygulama adını gösterir', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('tr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      expect(find.text('Mobil Arıcılık'), findsOneWidget);
    });
  });
}
