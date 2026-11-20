import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/export/domain/document_archive.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_documents.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/fake_share_service.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeShareService share;
  late FakeDocuments documents;

  setUp(() {
    db = openTestDatabase();
    share = FakeShareService();
    documents = FakeDocuments();
  });

  Future<void> open(WidgetTester tester) async {
    final container = ProviderContainer.test(
      overrides: signedIn(db: db, share: share, documents: documents),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    container.read(routerProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();
  }

  Finder inSettings(Finder finder) =>
      find.descendant(of: find.byType(SettingsScreen), matching: finder);

  Future<void> tapInSettings(WidgetTester tester, String text) async {
    final target = inSettings(find.text(text));
    await tester.scrollUntilVisible(
      target,
      200,
      scrollable: inSettings(find.byType(Scrollable)).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> seed(
    String name, {
    required String fileId,
    DocumentFileKind kind = DocumentFileKind.pdf,
    bool withFile = true,
    List<int> bytes = const [1, 2, 3],
  }) async {
    final file = (fileId: fileId, kind: kind, byteSize: bytes.length);
    if (withFile) documents.addFile(file.fileName, bytes);
    await DocumentRepository(db).create(
      orgId: testOrganization.id,
      type: DocumentType.healthReport,
      name: name,
      expiresOn: DateTime(2027, 5),
      file: file,
    );
  }

  testWidgets('bu telefondaki belge dosyaları adlarıyla tek ZIP olur; '
      'listede hangi dosyanın hangi belge olduğu yazar, başka telefondaki '
      'dosya girmez', (tester) async {
    await seed('Sağlık raporu', fileId: 'a', bytes: [7, 7]);
    await seed('sağlık raporu', fileId: 'b');
    await seed('Sağlık raporu', fileId: 'e', kind: DocumentFileKind.photo);
    await seed('Nakil: Ula/Köyceğiz', fileId: 'c');
    await seed('Başka telefonda', fileId: 'd', withFile: false);
    await open(tester);

    expect(inSettings(find.text('ZIP')), findsOneWidget);
    await tapInSettings(tester, 'Export document files');

    final shared = share.files.single;
    expect(shared.mimeType, zipMimeType);
    expect(
      shared.filename,
      matches(RegExp(r'^Mobil Arıcı documents \d{4}-\d{2}-\d{2}\.zip$')),
    );
    final zip = ZipDecoder().decodeBytes(shared.bytes);
    expect(
      [for (final f in zip.files) f.name]..sort(),
      [
        'Document list.csv',
        'Nakil- Ula-Köyceğiz.pdf',
        'Sağlık raporu.jpg',
        'Sağlık raporu.pdf',
        'sağlık raporu (2).pdf',
      ]..sort(),
    );
    expect(zip.findFile('Sağlık raporu.pdf')!.content, [7, 7]);
    final list = utf8.decode(
      zip.findFile('Document list.csv')!.content.sublist(3),
    );
    expect(list, startsWith('File,Name,Type,Valid until,Description\r\n'));
    expect(
      list,
      contains('sağlık raporu (2).pdf,sağlık raporu,Health report,2027-05-01,'),
    );
    expect(list, isNot(contains('Başka telefonda')));
  });

  testWidgets('bu telefonda dosya yoksa söyler, bir şey paylaşmaz', (
    tester,
  ) async {
    await seed('Başka telefonda', fileId: 'd', withFile: false);
    await open(tester);

    await tapInSettings(tester, 'Export document files');

    expect(share.files, isEmpty);
    expect(find.text('There are no document files on this phone.'), findsOne);
  });

  testWidgets('Türkçe metinler', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('tr')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await seed('Sağlık raporu', fileId: 'a');
    await open(tester);

    expect(inSettings(find.text('Belge dosyalarını dışa aktar')), findsOne);
    await tapInSettings(tester, 'Belge dosyalarını dışa aktar');

    final shared = share.files.single;
    expect(shared.filename, startsWith('Mobil Arıcı belgeler '));
    final zip = ZipDecoder().decodeBytes(shared.bytes);
    final list = utf8.decode(zip.findFile('Belge listesi.csv')!.content);
    // Türkçede ondalık ayracı virgül: Excel noktalı virgül bekler.
    expect(list, contains('Dosya;Ad;Tür;Geçerlilik;Açıklama'));
  });
}
