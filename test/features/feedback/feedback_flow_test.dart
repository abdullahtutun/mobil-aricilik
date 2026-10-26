import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';
import 'package:mobil_arici/features/feedback/presentation/feedback_screen.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_media.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/test_database.dart';

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required FakeMedia media,
}) async {
  final container = ProviderContainer.test(
    overrides: signedIn(db: db, media: media),
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  container.read(routerProvider).go(AppRoutes.feedback);
  await tester.pumpAndSettle();
  return container;
}

Finder _button(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(BigButton));

/// Form tembel bir liste; ekranın altındaki öğe önce kaydırılarak kurulur.
Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find
          .descendant(
            of: find.byType(FeedbackScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
  }
  await tester.ensureVisible(finder);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await _scrollTo(tester, finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  late AppDatabase db;
  late FakeMedia media;

  setUp(() {
    db = openTestDatabase();
    media = FakeMedia();
  });

  testWidgets('Daha fazla > Görüş bildir ekranı açar', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: signedIn(db: db),
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Send feedback'));

    expect(find.byType(FeedbackScreen), findsOneWidget);
    expect(find.text('WHAT IS IT ABOUT?'), findsOneWidget);
  });

  testWidgets('mesaj yazılınca Gönder açılır; görüş kuyruğa yazılır', (
    tester,
  ) async {
    await _open(tester, db: db, media: media);

    final send = _button('Send');
    expect(tester.widget<BigButton>(send).onPressed, isNull);
    await tester.enterText(find.byType(TextField), '   ');
    await tester.pumpAndSettle();
    expect(tester.widget<BigButton>(send).onPressed, isNull);

    await _tap(tester, find.text('Suggestion'));
    await tester.enterText(
      find.byType(TextField),
      '  Tur özetinde kovan numaraları sıralı olsun.  ',
    );
    await _tap(tester, send);

    expect(find.byType(FeedbackScreen), findsNothing);
    expect(
      find.text('Thank you! Your message is queued to be sent.'),
      findsOneWidget,
    );
    final [row] = await db.select(db.feedbackQueue).get();
    expect(row.orgId, testOrganization.id);
    expect(row.kind, FeedbackKind.suggestion);
    expect(row.message, 'Tur özetinde kovan numaraları sıralı olsun.');
    expect(row.screenshotFileName, isNull);
    expect(jsonDecode(row.deviceInfo!), {
      'app_version': '1.0.0+1',
      'platform': 'android',
      'os_version': 'Android 14 (SDK 34)',
      'model': 'Google Pixel 7',
      'locale': 'en',
    });
    expect(await readOutbox(db), isEmpty);
  });

  testWidgets('cihaz bilgisi kutusu kaldırılırsa bilgi eklenmez', (
    tester,
  ) async {
    await _open(tester, db: db, media: media);

    await _tap(tester, find.text('Include device and version info'));
    await tester.enterText(find.byType(TextField), 'Teşekkürler');
    await _tap(tester, _button('Send'));

    final [row] = await db.select(db.feedbackQueue).get();
    expect(row.kind, FeedbackKind.bug);
    expect(row.deviceInfo, isNull);
  });

  testWidgets('ekran görüntüsü galeriden eklenir, kaldırılır ve gönderilir', (
    tester,
  ) async {
    await _open(tester, db: db, media: media);

    await _tap(tester, _button('Add screenshot'));
    expect(media.camera.pickCount, 1);
    expect(find.text('Screenshot attached'), findsOneWidget);
    final first = media.fileNames.single;

    await _tap(tester, _button('Remove'));
    expect(find.text('Screenshot attached'), findsNothing);
    expect(media.fileNames, isEmpty);

    await _tap(tester, _button('Add screenshot'));
    final second = media.fileNames.single;
    expect(second, isNot(first));
    await tester.enterText(find.byType(TextField), 'Liste açılmıyor');
    await _tap(tester, _button('Send'));

    final [row] = await db.select(db.feedbackQueue).get();
    expect(row.screenshotFileName, second);
    expect(media.fileNames, [second]);
  });

  testWidgets('gönderilmeden kapanırsa ekran görüntüsü silinir', (
    tester,
  ) async {
    await _open(tester, db: db, media: media);
    await _tap(tester, _button('Add screenshot'));
    expect(media.fileNames, hasLength(1));

    await _tap(tester, find.byType(CloseButton));

    expect(find.byType(FeedbackScreen), findsNothing);
    expect(media.fileNames, isEmpty);
    expect(await db.select(db.feedbackQueue).get(), isEmpty);
  });

  testWidgets('galeri izni yoksa nedeni söylenir', (tester) async {
    media.camera.failure = MediaCaptureFailure.permissionDenied;
    await _open(tester, db: db, media: media);

    await _tap(tester, _button('Add screenshot'));

    expect(
      find.text(
        "Photo access wasn't allowed. To attach a screenshot, allow it in "
        'Settings.',
      ),
      findsOneWidget,
    );
    expect(media.fileNames, isEmpty);
  });

  testWidgets('Türkçe metinler', (tester) async {
    final container = await _open(tester, db: db, media: media);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    for (final text in [
      'Görüş bildir',
      'Uygulamayı arıcılar için birlikte geliştiriyoruz. Her mesajı okuyoruz.',
      'NE HAKKINDA?',
      'Hata',
      'Öneri',
      'Eksik özellik',
      'Teşekkür',
      'Mesajın',
      'Ekran görüntüsü ekle',
      'Cihaz ve sürüm bilgisini ekle',
      'İnternet yoksa mesaj sıraya alınır, bağlanınca gider.',
      'Gönder',
    ]) {
      await _scrollTo(tester, find.text(text));
      expect(find.text(text), findsOneWidget, reason: text);
    }

    await tester.enterText(find.byType(TextField), 'Eldivenle zor');
    await _tap(tester, _button('Gönder'));
    expect(
      find.text('Teşekkürler! Mesajın gönderilmek üzere sıraya alındı.'),
      findsOneWidget,
    );
    final [row] = await db.select(db.feedbackQueue).get();
    expect((jsonDecode(row.deviceInfo!) as Map)['locale'], 'tr');
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final container = await _open(tester, db: db, media: media);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tap(tester, _button('Add screenshot'));
    await _scrollTo(
      tester,
      find.text(
        "Without internet, the message is queued and sent once you're online.",
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
