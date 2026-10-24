import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/media/data/media_repository.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_providers.g.dart';

@Riverpod(keepAlive: true)
MediaRepository mediaRepository(Ref ref) =>
    MediaRepository(ref.watch(appDatabaseProvider));

/// Kovanın foto ve sesli notları, çekilme sırasıyla.
@riverpod
Stream<List<MediaItem>> hiveMedia(Ref ref, String hiveId) =>
    ref.watch(mediaRepositoryProvider).watchByHive(hiveId);

/// Yüklenmeyi bekleyen dosya sayısı (Ayarlar).
@riverpod
Stream<int> pendingMediaUploads(Ref ref) =>
    ref.watch(mediaRepositoryProvider).watchPendingUploadCount();

/// Medya kaydı; yoksa ya da silindiyse null.
@riverpod
Stream<MediaItem?> mediaItem(Ref ref, String mediaId) =>
    ref.watch(mediaRepositoryProvider).watchById(mediaId);
