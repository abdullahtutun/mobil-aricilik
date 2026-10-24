import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/media/data/media_repository.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';

import '../../../helpers/test_database.dart';

MediaCapture _capture(String fileName, {MediaKind kind = MediaKind.photo}) =>
    MediaCapture(
      fileName: fileName,
      kind: kind,
      capturedAt: DateTime.utc(2026, 10, 22, 8, 59),
      byteSize: 1234,
      durationMs: kind == MediaKind.audio ? 7000 : null,
    );

void main() {
  late AppDatabase db;
  late TestClock clock;
  late MediaRepository repository;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = MediaRepository(db, clock: clock.call);
  });

  Future<MediaItem> add(
    String fileName, {
    MediaKind kind = MediaKind.photo,
    String? inspectionId,
  }) => repository.add(
    orgId: 'org-1',
    hiveId: 'hive-1',
    inspectionId: inspectionId,
    capture: _capture(fileName, kind: kind),
  );

  Future<List<MediaUpload>> uploads() => db.select(db.mediaUploads).get();

  test('medyayı, outbox kaydını ve bekleyen yüklemeyi birlikte yazar; '
      'payload sunucunun kolonlarıyla', () async {
    final media = await add('a.m4a', kind: MediaKind.audio);

    expect(media.storagePath, 'org-1/hive-1/${media.id}.m4a');
    final entry = (await readOutbox(db)).single;
    expect(entry.recordTable, 'media');
    expect(entry.operation, OutboxOperation.upsert);
    expect(entry.payload, {
      'id': media.id,
      'org_id': 'org-1',
      'hive_id': 'hive-1',
      'inspection_id': null,
      'kind': 'audio',
      'storage_path': 'org-1/hive-1/${media.id}.m4a',
      'captured_at': '2026-10-22T08:59:00.000Z',
      'byte_size': 1234,
      'duration_ms': 7000,
      'created_at': '2026-10-22T09:00:00.000Z',
      'updated_at': '2026-10-22T09:00:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
    final upload = (await uploads()).single;
    expect(upload.mediaId, media.id);
    expect(upload.fileName, 'a.m4a');
    expect(upload.uploadStatus, MediaUploadStatus.pending);
    expect(await repository.localFileName(media), 'a.m4a');
  });

  test('outbox yazılamazsa medya da yükleme de yazılmaz', () async {
    await db.customStatement(
      'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
      "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
    );

    await expectLater(add('a.jpg'), throwsA(isA<Exception>()));
    expect(await db.select(db.media).get(), isEmpty);
    expect(await uploads(), isEmpty);
  });

  test('kovanın medyası çekilme sırasıyla akar; silinen düşer', () async {
    final first = await add('1.jpg');
    final second = await add('2.jpg');
    final stream = repository.watchByHive('hive-1');
    expect((await stream.first).map((m) => m.id), [first.id, second.id]);

    await repository.remove(first.id);
    expect((await stream.first).map((m) => m.id), [second.id]);
    expect((await readOutbox(db)).last.operation, OutboxOperation.delete);
  });

  test('silme bekleyen yüklemeyi kaldırır, yüklenmişi bırakır', () async {
    final pending = await add('1.jpg');
    final uploaded = await add('2.jpg');
    await (db.update(
      db.mediaUploads,
    )..where((t) => t.mediaId.equals(uploaded.id))).write(
      const MediaUploadsCompanion(
        uploadStatus: Value(MediaUploadStatus.uploaded),
      ),
    );
    expect(await repository.watchPendingUploadCount().first, 1);

    await repository.remove(pending.id);
    await repository.remove(uploaded.id);

    expect((await uploads()).map((u) => u.mediaId), [uploaded.id]);
    expect(await repository.watchPendingUploadCount().first, 0);
  });

  test('muayenenin medyası birlikte silinir; diğerleri kalır', () async {
    final inInspection = await add('1.jpg', inspectionId: 'inspection-1');
    final other = await add('2.jpg');

    await repository.removeByInspection('inspection-1');

    expect(await repository.findById(inInspection.id), isNull);
    expect(await repository.findById(other.id), isNotNull);
    expect((await uploads()).map((u) => u.mediaId), [other.id]);
  });

  test('başka telefonda çekilen medyanın dosya adı kimlikten', () async {
    final media = MediaItem(
      id: 'remote-1',
      orgId: 'org-1',
      hiveId: 'hive-1',
      kind: MediaKind.photo,
      storagePath: 'org-1/hive-1/remote-1.jpg',
      capturedAt: clock.current,
      byteSize: 1,
      createdAt: clock.current,
      updatedAt: clock.current,
    );
    expect(await repository.localFileName(media), 'remote-1.jpg');
    expect(downloadFileName(media), 'remote-1.jpg');
  });
}
