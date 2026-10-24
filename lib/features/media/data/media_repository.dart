import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';

/// Foto ve sesli notlar; olay kaydı: yalnız eklenir, yanlış kayıt silinir.
///
/// Bu telefonda çekilen medya, kaydıyla aynı transaction'da yükleme
/// kuyruğuna (`media_uploads`, `pending`) yazılır; dosyayı arka planda
/// `MediaSyncService` yükler. Dosyalara dokunmaz: dosya adları
/// `MediaFileStore`'daki adlardır.
class MediaRepository extends BaseRepository<$MediaTable, MediaItem> {
  new(super.db, {super.clock});

  @override
  $MediaTable get table => db.media;

  @override
  Insertable<MediaItem> toInsertable(MediaItem record) => record.toInsertable();

  /// Kovanın medyası, çekilme sırasıyla (eskisi önce).
  Stream<List<MediaItem>> watchByHive(String hiveId) => watchWhere(
    (t) => t.hiveId.equals(hiveId),
    orderBy: [
      (t) => OrderingTerm.asc(t.capturedAt),
      (t) => OrderingTerm.asc(t.id),
    ],
  );

  /// Bu telefonda çekilen [capture]'ı kovanın (ve verilirse muayenenin)
  /// medyası olarak yazar ve yükleme kuyruğuna ekler; ikisi tek
  /// transaction'da.
  Future<MediaItem> add({
    required String orgId,
    required String hiveId,
    required MediaCapture capture,
    String? inspectionId,
  }) => db.transaction(() async {
    final at = now();
    final id = generateId();
    final media = await insertRecord(
      MediaItem(
        id: id,
        orgId: orgId,
        hiveId: hiveId,
        inspectionId: inspectionId,
        kind: capture.kind,
        storagePath: mediaStoragePath(
          orgId: orgId,
          hiveId: hiveId,
          id: id,
          kind: capture.kind,
        ),
        capturedAt: capture.capturedAt.toUtc(),
        byteSize: capture.byteSize,
        durationMs: capture.durationMs,
        createdAt: at,
        updatedAt: at,
      ),
    );
    await db
        .into(db.mediaUploads)
        .insert(
          MediaUploadsCompanion.insert(
            mediaId: id,
            orgId: orgId,
            fileName: capture.fileName,
            uploadStatus: MediaUploadStatus.pending,
            createdAt: at,
          ),
        );
    return media;
  });

  /// Medyayı siler ve henüz yüklenmediyse kuyruktan çıkarır; ikisi tek
  /// transaction'da. Yüklenmiş dosya Storage'da kalır.
  Future<void> remove(String id) => db.transaction(() async {
    await delete(id);
    await _dropPendingUpload((t) => t.mediaId.equals(id));
  });

  /// Muayenenin medyasını siler (muayene geri alınınca); [remove] gibi.
  Future<void> removeByInspection(String inspectionId) =>
      db.transaction(() async {
        final ids = [
          for (final media in await selectWhere(
            (t) => t.inspectionId.equals(inspectionId),
          ).get())
            media.id,
        ];
        for (final id in ids) {
          await delete(id);
        }
        await _dropPendingUpload((t) => t.mediaId.isIn(ids));
      });

  Future<void> _dropPendingUpload(
    Expression<bool> Function($MediaUploadsTable t) filter,
  ) =>
      (db.delete(db.mediaUploads)..where(
            (t) =>
                filter(t) &
                t.uploadStatus.equalsValue(MediaUploadStatus.uploaded).not(),
          ))
          .go();

  /// Medyanın bu telefondaki dosya adı: burada çekildiyse çekilirkenki ad,
  /// değilse indirilince alacağı ad ([downloadFileName]).
  Future<String> localFileName(MediaItem media) async {
    final upload = await (db.select(
      db.mediaUploads,
    )..where((t) => t.mediaId.equals(media.id))).getSingleOrNull();
    return upload?.fileName ?? downloadFileName(media);
  }

  /// Yüklenmeyi bekleyen dosya sayısı (kalıcı hata alanlar dahil değil).
  Stream<int> watchPendingUploadCount() => _pendingCount().watchSingle();

  Future<int> pendingUploadCount() => _pendingCount().getSingle();

  Selectable<int> _pendingCount() {
    final count = db.mediaUploads.mediaId.count();
    return (db.selectOnly(db.mediaUploads)
          ..addColumns([count])
          ..where(
            db.mediaUploads.uploadStatus.equalsValue(MediaUploadStatus.pending),
          ))
        .map((row) => row.read(count)!);
  }
}
