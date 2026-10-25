import 'package:drift/drift.dart' show BooleanExpressionOperators, OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/core/sync/media_sync_service.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_sheet.dart';
import 'package:mobil_arici/features/media/data/media_repository.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/presentation/media_viewer_screen.dart';
import 'package:mobil_arici/features/media/presentation/widgets/media_strip.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_media.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required FakeMedia media,
  required String location,
}) async {
  final container = ProviderContainer.test(
    overrides: signedIn(db: db, media: media),
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  container.read(routerProvider).go(location);
  await tester.pumpAndSettle();
  return container;
}

/// [finder] tembel listede henüz kurulmadıysa kurulana kadar aşağı
/// kaydırır (kovan kartında kartın listesi, diğer ekranlarda dokunulabilen
/// ilk liste), sonra ilk eşleşmeyi görünür yapar.
Future<void> _reveal(WidgetTester tester, Finder finder) async {
  final card = find.descendant(
    of: find.byType(HiveCardScreen),
    matching: find.byType(Scrollable),
  );
  for (var i = 0; i < 50 && finder.evaluate().isEmpty; i++) {
    await tester.drag(
      card.evaluate().isNotEmpty
          ? card.first
          : find.byType(Scrollable).hitTestable().first,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await _reveal(tester, finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Geri al bildirimi alttaki eylem satırının üstünde durur; süresi dolunca
/// kapanır.
Future<void> _dismissSnackBar(WidgetTester tester) async {
  await tester.pump(undoSnackBarDuration + const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

Finder _photoButton() =>
    find.widgetWithIcon(BigIconButton, Icons.photo_camera_outlined);

Finder _micButton() =>
    find.widgetWithIcon(BigIconButton, Icons.mic_none_rounded);

Finder _stopButton() => find.widgetWithIcon(BigIconButton, Icons.stop_rounded);

void main() {
  late AppDatabase db;
  late FakeMedia media;
  late MediaRepository repository;
  late Apiary yayla;
  late Hive hive;

  setUp(() async {
    db = openTestDatabase();
    media = FakeMedia();
    repository = MediaRepository(db);
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
    hive = await HiveRepository(db).create(
      orgId: _orgId,
      number: '101',
      type: HiveType.langstroth,
      apiaryId: yayla.id,
    );
  });

  Future<ProviderContainer> openCard(WidgetTester tester) => _open(
    tester,
    db: db,
    media: media,
    location: AppRoutes.hive(yayla.id, hive.id),
  );

  // Drift'in watch() akışı sahte zamanda ilk değeri vermez; get() ile.
  Future<List<MediaItem>> hiveMedia() =>
      (db.select(db.media)
            ..where((t) => t.hiveId.equals(hive.id) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.capturedAt)]))
          .get();

  Future<List<MediaUpload>> uploads() => db.select(db.mediaUploads).get();

  group('Kovan kartı', () {
    testWidgets(
      'altta kamera, mikrofon ve Muayene başlat yan yana; tasarımdaki '
      'sırayla',
      (tester) async {
        await openCard(tester);

        final camera = tester.getRect(_photoButton());
        final mic = tester.getRect(_micButton());
        final start = tester.getRect(
          find.widgetWithText(BigButton, 'Start inspection'),
        );
        expect(camera.right, lessThan(mic.left));
        expect(mic.right, lessThan(start.left));
        expect(camera.height, start.height);
        expect(find.byTooltip('Take a photo'), findsOneWidget);
        expect(find.byTooltip('Record a voice note'), findsOneWidget);
      },
    );

    testWidgets('foto tek dokunuşla kovana eklenir, yükleme kuyruğuna girer, '
        'tünelde küçük resim çıkar; Geri al kaydı ve dosyayı siler', (
      tester,
    ) async {
      await openCard(tester);

      await _tap(tester, _photoButton());

      expect(find.text('Photo added to hive 101'), findsOneWidget);
      final [photo] = await hiveMedia();
      expect(photo.kind, MediaKind.photo);
      expect(photo.inspectionId, isNull);
      expect(photo.storagePath, '$_orgId/${hive.id}/${photo.id}.jpg');
      expect(photo.byteSize, tinyImage.length);
      final [upload] = await uploads();
      expect(upload.uploadStatus, MediaUploadStatus.pending);
      expect(media.fileNames, [upload.fileName]);

      await _reveal(tester, find.byType(MediaThumbnail));
      expect(find.text('Photo'), findsOneWidget);
      expect(find.bySemanticsLabel('Open photo'), findsOneWidget);

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(await hiveMedia(), isEmpty);
      expect(await uploads(), isEmpty);
      expect(media.fileNames, isEmpty);
      expect(find.byType(MediaThumbnail), findsNothing);
    });

    testWidgets('küçük resme dokununca fotoğraf tam ekran açılır', (
      tester,
    ) async {
      await openCard(tester);
      await _tap(tester, _photoButton());
      final [photo] = await hiveMedia();

      await _tap(tester, find.byType(MediaThumbnail));

      expect(
        tester
            .widget<MediaViewerScreen>(find.byType(MediaViewerScreen))
            .mediaId,
        photo.id,
      );
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    testWidgets('kamera kapatılırsa bir şey yazılmaz; izin yoksa nedeni '
        'söylenir', (tester) async {
      await openCard(tester);

      media.camera.cancel = true;
      await _tap(tester, _photoButton());
      expect(await hiveMedia(), isEmpty);

      media.camera
        ..cancel = false
        ..failure = MediaCaptureFailure.permissionDenied;
      await _tap(tester, _photoButton());
      expect(
        find.text(
          "No camera permission. You can allow it in the phone's settings.",
        ),
        findsOneWidget,
      );
      expect(await hiveMedia(), isEmpty);
    });

    testWidgets('sesli not: mikrofon kaydı başlatır, süre görünür, Kaydı '
        'bitir kovana ekler; Dinle çalar', (tester) async {
      await openCard(tester);

      await _tap(tester, _micButton());
      expect(media.recorder.recordingPath, isNotNull);
      expect(find.byTooltip('Stop recording'), findsOneWidget);
      expect(find.text('Recording · 0:00'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Recording · 0:03'), findsOneWidget);

      await _tap(tester, _stopButton());

      expect(find.text('Voice note added to hive 101'), findsOneWidget);
      expect(find.textContaining('Recording'), findsNothing);
      final [note] = await hiveMedia();
      expect(note.kind, MediaKind.audio);
      expect(note.durationMs, greaterThanOrEqualTo(3000));
      expect(note.storagePath, endsWith('.m4a'));

      final play = find.widgetWithText(BigButton, 'Play · 0:03');
      await _tap(tester, play);
      expect(media.player.played.single, endsWith('.m4a'));
      expect(find.widgetWithText(BigButton, 'Stop'), findsOneWidget);
      await _tap(tester, find.widgetWithText(BigButton, 'Stop'));
      expect(play, findsOneWidget);
    });

    testWidgets('mikrofon izni yoksa kayıt başlamaz', (tester) async {
      await openCard(tester);
      media.recorder.failure = MediaCaptureFailure.permissionDenied;

      await _tap(tester, _micButton());

      expect(
        find.text(
          "No microphone permission. You can allow it in the phone's "
          'settings.',
        ),
        findsOneWidget,
      );
      expect(_stopButton(), findsNothing);
    });

    testWidgets('kayıt sürerken karttan çıkılırsa kayıt atılır', (
      tester,
    ) async {
      final container = await openCard(tester);
      await _tap(tester, _micButton());

      container.read(routerProvider).go(AppRoutes.apiary(yayla.id));
      await tester.pumpAndSettle();

      expect(media.recorder.cancelCount, 1);
      expect(await hiveMedia(), isEmpty);
    });

    testWidgets('aktif olmayan kovanda da foto eklenir, muayene butonu yok', (
      tester,
    ) async {
      await HiveRepository(db).setStatus(hive.id, HiveStatus.dead);
      await openCard(tester);

      expect(find.widgetWithText(BigButton, 'Start inspection'), findsNothing);
      await _tap(tester, _photoButton());
      expect(await hiveMedia(), hasLength(1));
    });
  });

  group('Muayene', () {
    testWidgets('mikrofon ve kamera Kaydet’in solunda; çekilenler taslakta '
        'bekler, muayeneyle birlikte ona bağlı kaydedilir', (tester) async {
      await openCard(tester);
      await _tap(tester, find.widgetWithText(BigButton, 'Start inspection'));
      final sheet = find.byType(InspectionSheet);
      Finder inSheet(Finder finder) =>
          find.descendant(of: sheet, matching: finder);

      final mic = tester.getRect(inSheet(_micButton()));
      final camera = tester.getRect(inSheet(_photoButton()));
      final save = tester.getRect(
        inSheet(find.widgetWithText(BigButton, 'Save')),
      );
      expect(mic.right, lessThan(camera.left));
      expect(camera.right, lessThan(save.left));

      await _tap(tester, inSheet(_photoButton()));
      await _tap(tester, inSheet(_photoButton()));
      await _tap(tester, inSheet(_micButton()));
      await tester.pump(const Duration(seconds: 2));
      await _tap(tester, inSheet(_stopButton()));

      expect(
        find.text('Saved with the inspection: 2 photos, 1 voice note'),
        findsOneWidget,
      );
      // Muayene kaydedilene kadar medya kaydı yok.
      expect(await hiveMedia(), isEmpty);

      await _tap(tester, inSheet(find.widgetWithText(BigButton, 'Save')));

      final inspection = (await InspectionRepository(db)
          .latestByHive(hive.id))!;
      final saved = await hiveMedia();
      expect(saved, hasLength(3));
      expect(saved.map((m) => m.inspectionId).toSet(), {inspection.id});
      expect(await uploads(), hasLength(3));

      // Tünelde muayene satırının altında iki küçük resim ve Dinle.
      await _reveal(tester, find.byType(MediaStrip));
      expect(find.byType(MediaThumbnail), findsNWidgets(2));
      expect(find.widgetWithText(BigButton, 'Play · 0:02'), findsOneWidget);
      expect(find.text('Photo'), findsNothing);
    });

    testWidgets('Geri al medyayı da siler; taslak çekimleriyle döner', (
      tester,
    ) async {
      await openCard(tester);
      await _tap(tester, find.widgetWithText(BigButton, 'Start inspection'));
      await _tap(tester, _photoButton().last);
      await _tap(tester, find.widgetWithText(BigButton, 'Save'));
      expect(await hiveMedia(), hasLength(1));

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(await hiveMedia(), isEmpty);
      expect(await uploads(), isEmpty);
      // Dosya silinmez; taslakla geri gelir.
      expect(media.fileNames, hasLength(1));

      await _tap(tester, find.widgetWithText(BigButton, 'Start inspection'));
      expect(find.text('Saved with the inspection: 1 photo'), findsOneWidget);
    });

    testWidgets('Baştan başla taslaktaki dosyaları siler', (tester) async {
      await openCard(tester);
      await _tap(tester, find.widgetWithText(BigButton, 'Start inspection'));
      await _tap(tester, _photoButton().last);
      expect(media.fileNames, hasLength(1));

      await _tap(tester, find.text('Start over'));

      expect(media.fileNames, isEmpty);
      expect(find.textContaining('Saved with the inspection'), findsNothing);
    });
  });

  group('Başka telefonda çekilen', () {
    Future<MediaItem> remotePhoto() async {
      final at = DateTime.utc(2026, 10, 22, 9);
      final item = MediaItem(
        id: 'remote-1',
        orgId: _orgId,
        hiveId: hive.id,
        kind: MediaKind.photo,
        storagePath: '$_orgId/${hive.id}/remote-1.jpg',
        capturedAt: at,
        byteSize: tinyImage.length,
        createdAt: at,
        updatedAt: at,
        serverSeq: 9,
      );
      // Senkronla inen satır: outbox'a ve yükleme kuyruğuna girmez.
      await db.into(db.media).insert(item.toInsertable());
      return item;
    }

    testWidgets('foto meta veri olarak iner; dokununca dosya indirilir', (
      tester,
    ) async {
      final item = await remotePhoto();
      media.sync.remote[item.storagePath] = tinyImage;
      await openCard(tester);
      await _reveal(tester, find.byType(MediaThumbnail));

      expect(
        find.bySemanticsLabel('Photo not on this phone. Tap to download.'),
        findsOneWidget,
      );
      expect(media.fileNames, isEmpty);

      await _tap(tester, find.byType(MediaThumbnail));

      expect(media.fileNames, ['remote-1.jpg']);
      expect(find.bySemanticsLabel('Open photo'), findsOneWidget);
    });

    testWidgets('henüz yüklenmediyse ya da ağ yoksa nedeni söylenir', (
      tester,
    ) async {
      await remotePhoto();
      await openCard(tester);

      await _tap(tester, find.byType(MediaThumbnail));
      expect(
        find.text(
          'Not uploaded yet. It arrives when the phone that took it is '
          'online.',
        ),
        findsOneWidget,
      );

      media.sync.downloadFailure = MediaDownloadFailure.offline;
      await _tap(tester, find.byType(MediaThumbnail));
      expect(
        find.text("Couldn't download. Check your internet connection."),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Photo not on this phone. Tap to download.'),
        findsOneWidget,
      );
    });
  });

  group('Ayarlar', () {
    testWidgets('"sadece Wi‑Fi" yerel DB’ye yazılır; bekleyen dosya sayısı '
        'görünür', (tester) async {
      await repository.add(
        orgId: _orgId,
        hiveId: hive.id,
        capture: MediaCapture(
          fileName: 'p.jpg',
          kind: MediaKind.photo,
          capturedAt: DateTime.utc(2026, 10, 22),
          byteSize: 1,
        ),
      );
      await _open(tester, db: db, media: media, location: AppRoutes.settings);

      // Bölüm adı satırın üstünde; _reveal yalnız aşağı kaydırır.
      await _reveal(tester, find.text('DATA'));
      await _reveal(tester, find.text('1 file waiting to upload'));
      final toggle = find.widgetWithText(
        SwitchListTile,
        'Upload photos on Wi‑Fi only',
      );
      expect(tester.widget<SwitchListTile>(toggle).value, isFalse);

      await _tap(tester, toggle);

      expect(tester.widget<SwitchListTile>(toggle).value, isTrue);
      expect(await LocalSettingsRepository(db).mediaWifiOnly(), isTrue);
    });
  });

  testWidgets('Türkçe metinler', (tester) async {
    final container = await openCard(tester);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.byTooltip('Fotoğraf çek'), findsOneWidget);
    expect(find.byTooltip('Sesli not kaydet'), findsOneWidget);
    await _tap(tester, _photoButton());
    expect(find.text('Kovan 101: fotoğraf eklendi'), findsOneWidget);
    await _reveal(tester, find.text('Fotoğraf'));
    await _dismissSnackBar(tester);

    await _tap(tester, _micButton());
    expect(find.byTooltip('Kaydı bitir'), findsOneWidget);
    expect(find.text('Kaydediliyor · 0:00'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await _tap(tester, _stopButton());
    expect(find.text('Kovan 101: sesli not eklendi'), findsOneWidget);
    await _reveal(tester, find.text('Sesli not'));
    expect(find.widgetWithText(BigButton, 'Dinle · 0:01'), findsOneWidget);
    await _dismissSnackBar(tester);

    await _tap(tester, find.widgetWithText(BigButton, 'Muayene başlat'));
    await _tap(tester, _photoButton().last);
    expect(find.text('Muayeneyle kaydedilecek: 1 fotoğraf'), findsOneWidget);

    container.read(routerProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('VERİ'));
    await _reveal(tester, find.text('2 dosya yüklenmeyi bekliyor'));
    expect(find.text("Fotoğrafları sadece Wi‑Fi'da yükle"), findsOneWidget);
    expect(find.text('2 dosya yüklenmeyi bekliyor'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final container = await openCard(tester);

    for (final glove in [false, true]) {
      container.read(appearanceProvider.notifier).setGloveMode(enabled: glove);
      await tester.pumpAndSettle();

      await _tap(tester, _photoButton().first);
      await _dismissSnackBar(tester);
      await _tap(tester, _micButton().first);
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
      await _tap(tester, _stopButton().first);
      await _reveal(tester, find.byType(MediaStrip));
      expect(tester.takeException(), isNull);
      await _dismissSnackBar(tester);

      // Butonlar eldivenle de en az saha hedefi kadar ve kare.
      final size = tester.getSize(_photoButton().first);
      expect(size.width, size.height);
      expect(
        size.height,
        greaterThanOrEqualTo(glove ? AppTouchTargets.glove.button : 60),
      );
      expect(
        tester.getSize(find.byType(MediaThumbnail).first).height,
        greaterThanOrEqualTo(AppTouchTargets.glove.minimum),
      );

      await _tap(tester, find.widgetWithText(BigButton, 'Start inspection'));
      await _tap(tester, _photoButton().last);
      await _reveal(tester, find.textContaining('Saved with the inspection'));
      expect(tester.takeException(), isNull);
      await _tap(tester, find.byTooltip('Close'));
    }
  });
}
