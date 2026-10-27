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
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_file_view.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_documents.dart';
import '../../../helpers/fake_media.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_reminder_notifications.dart';
import '../../../helpers/fake_screen_awake.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Finder _button(String label) => find.widgetWithText(BigButton, label);

Finder _field(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is LabeledField && w.label == label),
  matching: find.byType(TextField),
);

/// PDF sayfası; sahte zamanda görüntü çözülmediği için boyutsuz, anlam
/// ağacında değil ve listede görünür sayılmıyor.
Finder _pdfPage(int page, int count) => find.byWidgetPredicate(
  (w) => w is Semantics && w.properties.label == 'Page $page of $count',
  skipOffstage: false,
);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  // Kaydırılan listede henüz kurulmamış olabilir.
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  late AppDatabase db;
  late FakeDocuments documents;
  late FakeMedia media;
  late FakeReminderNotifications reminders;
  late FakeScreenAwake awake;
  late DocumentRepository repository;

  setUp(() {
    db = openTestDatabase();
    documents = FakeDocuments();
    media = FakeMedia();
    reminders = FakeReminderNotifications();
    awake = FakeScreenAwake();
    repository = DocumentRepository(db);
  });

  Future<ProviderContainer> open(
    WidgetTester tester, {
    String location = AppRoutes.documents,
    RegionConfig? region,
  }) async {
    final container = ProviderContainer.test(
      overrides: [
        ...signedIn(
          db: db,
          documents: documents,
          media: media,
          reminders: reminders,
          screenAwake: awake,
        ),
        if (region != null) regionConfigProvider.overrideWithValue(region),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    container.read(routerProvider).go(location);
    await tester.pumpAndSettle();
    return container;
  }

  /// Dosyası bu telefonda olan (ya da olmayan) bir belge yazar.
  Future<VaultDocument> seed(
    String name, {
    DocumentType type = DocumentType.healthReport,
    String? customTypeName,
    String? description,
    DateTime? expiresOn,
    DocumentFileKind kind = DocumentFileKind.photo,
    bool withFile = true,
  }) async {
    final file = (fileId: 'file-$name', kind: kind, byteSize: 100);
    if (withFile) documents.addFile(file.fileName);
    return await repository.create(
      orgId: _orgId,
      type: type,
      customTypeName: customTypeName,
      name: name,
      description: description,
      expiresOn: expiresOn,
      file: file,
    );
  }

  DateTime inDays(int days) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + days);
  }

  Future<List<VaultDocument>> saved() async =>
      (await db.select(db.documents).get())
          .where((d) => d.deletedAt == null)
          .toList();

  testWidgets("Daha fazla'dan açılır; boşken belge eklemeyi önerir", (
    tester,
  ) async {
    await open(tester, location: AppRoutes.more);

    await _tap(tester, find.text('Document vault'));

    expect(find.text('No documents yet'), findsOneWidget);
    expect(find.byTooltip('Add document'), findsOneWidget);
    expect(_button('Road check · show documents'), findsNothing);
  });

  testWidgets('TR profilinde hazır türden belge eklenir: ad türden dolar, '
      'fotoğraf ve geçerlilik tarihi; hatırlatma izni istenir', (tester) async {
    reminders.permitted = false;
    await open(tester, location: AppRoutes.documentNew);

    // Hazır türler var, serbest tür alanı yok.
    expect(find.text('Migratory beekeeper certificate'), findsOneWidget);
    expect(find.text('e.g. Insurance policy'), findsNothing);
    expect(tester.widget<BigButton>(_button('Save')).onPressed, isNull);

    await _tap(tester, find.text('Health report'));
    expect(
      tester.widget<TextField>(_field('Name')).controller!.text,
      'Health report',
    );
    await tester.enterText(_field('Description'), 'Ula · 152 hives');
    await _tap(tester, _button('Take photo'));
    expect(find.textContaining('PHOTO · 1 KB'), findsOneWidget);
    await _tap(tester, find.text('Pick a date'));
    await _tap(tester, find.text('OK'));
    expect(
      find.text("You'll be reminded 30, 7 and 1 day before it expires."),
      findsOneWidget,
    );
    await _tap(tester, _button('Save'));

    final document = (await saved()).single;
    expect(document.type, DocumentType.healthReport);
    expect(document.name, 'Health report');
    expect(document.description, 'Ula · 152 hives');
    expect(document.expiresOn, isNotNull);
    expect(document.fileKind, DocumentFileKind.photo);
    expect(documents.fileNames, [documentFileName(document.storagePath)]);
    expect(await repository.pendingUploadCount(), 1);
    expect(reminders.permissionRequests, 1);

    // Kasaya döner.
    expect(find.text('Document vault'), findsOneWidget);
    expect(find.text('Health report'), findsOneWidget);
    expect(find.text('Ula · 152 hives'), findsOneWidget);
    expect(find.text('1 document · all open offline'), findsOneWidget);
  });

  testWidgets('diğer bölgede tür yazılır; önceki türler önerilir; not '
      'bölgeye göre', (tester) async {
    await seed(
      'Hive insurance',
      type: DocumentType.custom,
      customTypeName: 'Insurance',
    );
    await open(tester, region: resolveRegionConfig('DE'));

    expect(
      find.text(
        'You define the document types; the types you enter are suggested '
        'next time.',
      ),
      findsOneWidget,
    );
    // Açıklamasız belgede alt satır türün adı.
    expect(find.text('Insurance'), findsOneWidget);
    expect(find.text('Hive insurance'), findsOneWidget);

    await _tap(tester, find.byTooltip('Add document'));
    expect(find.text('Health report'), findsNothing);
    await _tap(tester, find.text('Insurance'));
    expect(
      tester.widget<TextField>(_field('Name')).controller!.text,
      'Insurance',
    );
    await tester.enterText(_field('Name'), 'Truck insurance');
    await _tap(tester, _button('From gallery'));
    await _tap(tester, _button('Save'));

    final added = (await saved()).firstWhere(
      (d) => d.name == 'Truck insurance',
    );
    expect(added.type, DocumentType.custom);
    expect(added.customTypeName, 'Insurance');
    expect(added.expiresOn, isNull);
    // Süresiz belge izin istemez.
    expect(reminders.permissionRequests, 0);
    expect(find.text('No expiry'), findsNWidgets(2));
  });

  testWidgets('PDF seçilir ve sayfaları internetsiz açılır; 20 MB üstü '
      'reddedilir', (tester) async {
    await open(tester, location: AppRoutes.documentNew);
    await _tap(tester, find.text('Analysis report'));

    documents.picker.byteSize = maxDocumentFileBytes + 1;
    await _tap(tester, _button('Choose PDF'));
    expect(
      find.text('The file is larger than 20 MB; choose a smaller one.'),
      findsOneWidget,
    );
    expect(documents.fileNames, isEmpty);

    // Hata bildirimi Kaydet'in üstünden kalksın.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    documents.picker.byteSize = 3 * 1024 * 1024;
    await _tap(tester, _button('Choose PDF'));
    expect(find.textContaining('PDF · 3 MB'), findsOneWidget);
    await _tap(tester, _button('Save'));

    final document = (await saved()).single;
    expect(document.fileKind, DocumentFileKind.pdf);
    expect(document.byteSize, 3 * 1024 * 1024);
    expect(find.text('PDF'), findsOneWidget);

    await _tap(tester, find.text('Analysis report'));
    expect(_pdfPage(1, 2), findsOneWidget);
    expect(_pdfPage(2, 2), findsOneWidget);
    expect(find.text('No expiry'), findsOneWidget);
  });

  testWidgets('kaydedilmeden kapanan formun dosyası silinir; izin '
      'verilmezse söylenir', (tester) async {
    media.camera.failure = MediaCaptureFailure.permissionDenied;
    await open(tester, location: AppRoutes.documentNew);

    await _tap(tester, _button('Take photo'));
    expect(find.textContaining('Permission denied.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    media.camera.failure = null;
    await _tap(tester, _button('Take photo'));
    expect(documents.fileNames, hasLength(1));
    await _tap(tester, find.byTooltip('Close'));

    expect(documents.fileNames, isEmpty);
    expect(await saved(), isEmpty);
  });

  testWidgets('kasa: süresi önce dolan önce, rozet renk + kelimeyle; '
      'indirilmemiş dosya sayılır', (tester) async {
    // Bütün kartlar bir ekrana sığsın.
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await seed('Tescil');
    await seed('Nakil evrakı', expiresOn: inDays(60));
    await seed('Sağlık raporu', expiresOn: inDays(5), withFile: false);
    await seed('Arazi izni', expiresOn: inDays(400));
    await seed('Eski izin', expiresOn: inDays(-1));
    await open(tester);

    final names = [
      for (final name in [
        'Eski izin',
        'Sağlık raporu',
        'Nakil evrakı',
        'Arazi izni',
        'Tescil',
      ])
        tester.getTopLeft(find.text(name)).dy,
    ];
    expect(names, [...names]..sort());
    expect(find.widgetWithText(StatusBadge, '5 days'), findsOneWidget);
    expect(find.widgetWithText(StatusBadge, '2 months'), findsOneWidget);
    expect(find.widgetWithText(StatusBadge, 'Expired'), findsOneWidget);
    expect(find.widgetWithText(StatusBadge, 'No expiry'), findsOneWidget);
    expect(
      find.text('5 documents · 1 file not on this phone yet'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<StatusBadge>(find.widgetWithText(StatusBadge, '5 days'))
          .status,
      AppStatus.critical,
    );

    // Dosyası henüz inmeyen belge nedenini söyler.
    await _tap(tester, find.text('Sağlık raporu'));
    expect(
      find.text(
        "The file isn't on this phone yet. It downloads when you're online.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('düzenleme: ad ve dosya değişir, eski dosya telefondan silinir; '
      'silme onaylıdır ve kasaya döner', (tester) async {
    // Form, alttaki sabit Kaydet çubuğunun altına kaymadan sığsın.
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final document = await seed('Nakil evrakı', expiresOn: inDays(60));
    final oldFile = documentFileName(document.storagePath);
    await open(tester, location: AppRoutes.document(document.id));

    await _tap(tester, find.text('Edit'));
    expect(find.textContaining('PHOTO'), findsOneWidget);
    await tester.enterText(_field('Name'), 'Nakil evrakı · Köyceğiz');
    await _tap(tester, _button('Choose PDF'));
    await _tap(tester, _button('Save'));

    final updated = (await saved()).single;
    expect(updated.name, 'Nakil evrakı · Köyceğiz');
    expect(updated.fileKind, DocumentFileKind.pdf);
    expect(documents.fileNames, [documentFileName(updated.storagePath)]);
    expect(documents.fileNames, isNot(contains(oldFile)));
    expect(find.text('Nakil evrakı · Köyceğiz'), findsWidgets);

    await _tap(tester, find.text('Edit'));
    await _tap(tester, _button('Delete document'));
    expect(find.text('Delete this document?'), findsOneWidget);
    await _tap(tester, find.widgetWithText(TextButton, 'Delete'));

    expect(await saved(), isEmpty);
    expect(documents.fileNames, isEmpty);
    expect(find.text('Document vault'), findsOneWidget);
    expect(find.text('No documents yet'), findsOneWidget);
  });

  testWidgets('yol kontrolü: tam ekran, kaydırarak ve butonlarla geçilir; '
      'ekran açık kalır', (tester) async {
    await seed('Sağlık raporu', expiresOn: inDays(5));
    await seed(
      'Nakil evrakı',
      expiresOn: inDays(60),
      kind: DocumentFileKind.pdf,
    );
    await open(tester);

    await _tap(tester, _button('Road check · show documents'));

    expect(find.text('Road check'), findsOneWidget);
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('Sağlık raporu'), findsOneWidget);
    expect(awake.keptOn, isTrue);
    // Alt gezinme yok.
    expect(find.text('Today'), findsNothing);
    expect(
      tester.widget<BigIconButton>(find.byType(BigIconButton).first).onPressed,
      isNull,
    );

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('2 / 2'), findsOneWidget);
    expect(find.text('Nakil evrakı'), findsOneWidget);
    expect(_pdfPage(1, 2), findsOneWidget);

    await _tap(tester, find.byTooltip('Previous document'));
    expect(find.text('1 / 2'), findsOneWidget);
    await _tap(tester, find.byTooltip('Next document'));
    expect(find.text('2 / 2'), findsOneWidget);

    await _tap(tester, find.byTooltip('Close'));
    expect(awake.keptOn, isFalse);
    expect(find.text('Document vault'), findsOneWidget);
  });

  testWidgets('viewer belge ekleyemez ve düzenleyemez, ama açar', (
    tester,
  ) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.viewer);
    final document = await seed('Sağlık raporu');
    await open(tester);

    expect(find.byTooltip('Add document'), findsNothing);
    await _tap(tester, find.text('Sağlık raporu'));
    expect(find.text('Edit'), findsNothing);
    expect(find.byType(DocumentFileView), findsOneWidget);
    expect(find.text(document.name), findsOneWidget);
  });

  testWidgets('Türkçe metinler', (tester) async {
    await seed('Sağlık raporu', expiresOn: inDays(5));
    final container = await open(tester);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Belge kasası'), findsOneWidget);
    expect(find.text('1 belge · hepsi internetsiz açılır'), findsOneWidget);
    expect(find.text('5 gün'), findsOneWidget);
    expect(
      find.text(
        'Belge türleri ülkeye göre gelir. Türkiye dışında kendi belge '
        'türlerini oluşturursun.',
      ),
      findsOneWidget,
    );
    expect(_button('Yol kontrolü · belgeleri göster'), findsOneWidget);

    await _tap(tester, find.byTooltip('Belge ekle'));
    expect(find.text('Gezginci arıcı belgesi'), findsOneWidget);
    expect(_button('PDF seç'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await seed(
      'Gezginci arıcı belgesi',
      description: 'Birlik onaylı',
      expiresOn: inDays(60),
    );

    final container = await open(tester);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tap(tester, _button('Road check · show documents'));
    expect(tester.takeException(), isNull);
    await _tap(tester, find.byTooltip('Close'));

    await _tap(tester, find.byTooltip('Add document'));
    await _tap(tester, find.text('Migratory beekeeper certificate'));
    await _tap(tester, _button('Choose PDF'));
    await tester.scrollUntilVisible(
      _button('Choose PDF'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
