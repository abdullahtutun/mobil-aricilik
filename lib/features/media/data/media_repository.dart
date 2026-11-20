import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';

/// Foto ve sesli notlar; olay kaydı: yalnız eklenir, yanlış kayıt silinir.
///
/// Kayıt senkronlanır, dosyası yalnız çekildiği telefonda kalır
/// (2026-11-20): sunucuya yüklenmez, başka telefona inmez. Bu telefonda
/// çekilen medyanın dosya adı kaydıyla aynı transaction'da `media_uploads`'a
/// yazılır; tablo artık yalnız bu eşlemeyi tutar, yükleyen yok. Dosyalara
/// dokunmaz: dosya adları `MediaFileStore`'daki adlardır.
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

  /// Bu telefonda çekilen [capture]'ı kovanın (ve verilirse muayenenin ya
  /// da ilaç uygulamasının) medyası olarak yazar ve dosya adını
  /// `media_uploads`'a ekler; ikisi tek transaction'da.
  Future<MediaItem> add({
    required String orgId,
    required String hiveId,
    required MediaCapture capture,
    String? inspectionId,
    String? treatmentId,
  }) => db.transaction(() async {
    final at = now();
    final id = generateId();
    final media = await insertRecord(
      MediaItem(
        id: id,
        orgId: orgId,
        hiveId: hiveId,
        inspectionId: inspectionId,
        treatmentId: treatmentId,
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

  /// Medyayı ve dosya adı eşlemesini siler; ikisi tek transaction'da.
  Future<void> remove(String id) => db.transaction(() async {
    await delete(id);
    await _dropFileName((t) => t.mediaId.equals(id));
  });

  /// Muayenenin medyasını siler (muayene geri alınınca); [remove] gibi.
  Future<void> removeByInspection(String inspectionId) =>
      _removeWhere((t) => t.inspectionId.equals(inspectionId));

  /// İlaç uygulamalarının reçete fotoğraflarını siler (uygulama geri
  /// alınınca); [remove] gibi.
  Future<void> removeByTreatments(Iterable<String> treatmentIds) =>
      _removeWhere((t) => t.treatmentId.isIn(treatmentIds));

  Future<void> _removeWhere(Expression<bool> Function($MediaTable t) filter) =>
      db.transaction(() async {
        final ids = [
          for (final media in await selectWhere(filter).get()) media.id,
        ];
        for (final id in ids) {
          await delete(id);
        }
        await _dropFileName((t) => t.mediaId.isIn(ids));
      });

  Future<void> _dropFileName(
    Expression<bool> Function($MediaUploadsTable t) filter,
  ) => (db.delete(db.mediaUploads)..where(filter)).go();

  /// Medyanın bu telefondaki dosya adı: burada çekildiyse çekilirkenki ad,
  /// değilse yol adı ([downloadFileName]; eski sürümde başka telefondan
  /// inmiş dosya bu addadır).
  Future<String> localFileName(MediaItem media) async {
    final upload = await (db.select(
      db.mediaUploads,
    )..where((t) => t.mediaId.equals(media.id))).getSingleOrNull();
    return upload?.fileName ?? downloadFileName(media);
  }
}
