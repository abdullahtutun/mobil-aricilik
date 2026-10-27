import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late DocumentRepository repository;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = DocumentRepository(db, clock: clock.call);
  });

  const pdf = (fileId: 'file-1', kind: DocumentFileKind.pdf, byteSize: 2048);
  const photo = (
    fileId: 'file-2',
    kind: DocumentFileKind.photo,
    byteSize: 1024,
  );

  Future<VaultDocument> create({
    String orgId = 'org-1',
    DocumentType type = DocumentType.healthReport,
    String? customTypeName,
    String name = 'Sağlık raporu',
    String? description,
    DateTime? expiresOn,
    DocumentFileCapture file = pdf,
  }) => repository.create(
    orgId: orgId,
    type: type,
    customTypeName: customTypeName,
    name: name,
    description: description,
    expiresOn: expiresOn,
    file: file,
  );

  Future<List<DocumentUpload>> uploads() => db.select(db.documentUploads).get();

  Future<void> breakOutbox() => db.customStatement(
    'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
    "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
  );

  test('belgeyi ve yükleme kuyruğunu yazar; outbox payload’u sunucunun '
      'kolonlarıyla, alanlar kırpılır, gün saatsiz', () async {
    final document = await create(
      name: '  Sağlık raporu 2026 ',
      description: ' Ula İlçe Tarım · 152 kovan ',
      expiresOn: DateTime(2026, 11, 1, 15, 30),
    );

    expect(await repository.findById(document.id), document);
    final entry = (await readOutbox(db)).single;
    expect(entry.operation, OutboxOperation.upsert);
    expect(entry.payload, {
      'id': document.id,
      'org_id': 'org-1',
      'type': 'health_report',
      'custom_type_name': null,
      'name': 'Sağlık raporu 2026',
      'description': 'Ula İlçe Tarım · 152 kovan',
      'expires_on': '2026-11-01',
      'file_kind': 'pdf',
      'storage_path': 'org-1/${document.id}/file-1.pdf',
      'byte_size': 2048,
      'created_at': '2026-10-22T09:00:00.000Z',
      'updated_at': '2026-10-22T09:00:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
    final upload = (await uploads()).single;
    expect(upload.storagePath, document.storagePath);
    expect(upload.documentId, document.id);
    expect(upload.uploadStatus, MediaUploadStatus.pending);
    expect(await repository.pendingUploadCount(), 1);
  });

  test('kullanıcı tanımlı tür adıyla yazılır; boş açıklama null', () async {
    final document = await create(
      type: DocumentType.custom,
      customTypeName: ' Insurance ',
      name: 'Hive insurance',
      description: '   ',
    );
    expect(document.customTypeName, 'Insurance');
    expect(document.description, isNull);
  });

  test('geçersiz alanlarda hiçbir şey yazmaz', () async {
    await expectLater(create(name: '  '), throwsArgumentError);
    await expectLater(
      create(type: DocumentType.custom, customTypeName: ' '),
      throwsArgumentError,
    );
    await expectLater(create(customTypeName: 'Fazla'), throwsArgumentError);
    await expectLater(
      create(
        file: (
          fileId: 'big',
          kind: DocumentFileKind.pdf,
          byteSize: maxDocumentFileBytes + 1,
        ),
      ),
      throwsArgumentError,
    );
    expect(await db.select(db.documents).get(), isEmpty);
    expect(await uploads(), isEmpty);
    expect(await readOutbox(db), isEmpty);
  });

  test('outbox yazılamazsa belge de kuyruk da yazılmaz', () async {
    await breakOutbox();
    await expectLater(create(), throwsA(anything));
    expect(await db.select(db.documents).get(), isEmpty);
    expect(await uploads(), isEmpty);
  });

  group('güncelleme', () {
    test(
      'alanları yazar, dosya aynı kalır; kuyruğa yeni satır girmez',
      () async {
        final document = await create();
        clock.advance(const Duration(hours: 1));

        final updated = await repository.update(
          document.copyWith(
            name: 'Sağlık raporu (yeni)',
            expiresOn: DateTime(2027, 5),
            // Formdan gelmeyen dosya alanları yok sayılır.
            storagePath: 'başka/yol.pdf',
          ),
        );

        expect(updated.name, 'Sağlık raporu (yeni)');
        expect(updated.expiresOn, DateTime(2027, 5));
        expect(updated.storagePath, document.storagePath);
        expect(updated.updatedAt, DateTime.utc(2026, 10, 22, 10));
        expect(await uploads(), hasLength(1));
        expect((await readOutbox(db)).last.payload['expires_on'], '2027-05-01');
      },
    );

    test('yeni dosya yeni yola gider; yüklenmemiş eski dosya kuyruktan '
        'çıkar', () async {
      final document = await create();

      final updated = await repository.update(document, file: photo);

      expect(updated.fileKind, DocumentFileKind.photo);
      expect(updated.storagePath, 'org-1/${document.id}/file-2.jpg');
      expect(updated.byteSize, 1024);
      expect(
        [for (final u in await uploads()) u.storagePath],
        [updated.storagePath],
      );
    });

    test('yüklenmiş eski dosya kuyrukta kalır', () async {
      final document = await create();
      await db
          .update(db.documentUploads)
          .write(
            const DocumentUploadsCompanion(
              uploadStatus: Value(MediaUploadStatus.uploaded),
            ),
          );

      await repository.update(document, file: photo);

      expect(await uploads(), hasLength(2));
      expect(await repository.pendingUploadCount(), 1);
    });

    test('silinmiş belge güncellenmez', () async {
      final document = await create();
      await repository.remove(document.id);
      await expectLater(repository.update(document), throwsStateError);
    });
  });

  test('yumuşak siler ve yüklenmemiş dosyayı kuyruktan çıkarır', () async {
    final document = await create();

    await repository.remove(document.id);

    expect(await repository.findById(document.id), isNull);
    final row = await (db.select(
      db.documents,
    )..where((t) => t.id.equals(document.id))).getSingle();
    expect(row.deletedAt, isNotNull);
    expect((await readOutbox(db)).last.operation, OutboxOperation.delete);
    expect(await uploads(), isEmpty);
  });

  test('işletmenin belgeleri kasa sırasıyla akar; silinen ve başka '
      'işletmeninki yok', () async {
    final stream = repository.watchByOrg('org-1');
    final later = await create(name: 'Nakil', expiresOn: DateTime(2027, 5));
    final sooner = await create(expiresOn: DateTime(2026, 11));
    final open = await create(name: 'Tescil');
    await create(orgId: 'org-2');
    final removed = await create(name: 'Eski');
    await repository.remove(removed.id);

    expect(await stream.first, [sooner, later, open]);
    expect(
      {for (final d in await repository.listByOrg('org-1')) d.id},
      {sooner.id, later.id, open.id},
    );
  });
}
