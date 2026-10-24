import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/sync/media_sync_service.dart';
import 'package:mobil_arici/core/sync/media_sync_service_provider.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/presentation/media_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_controllers.freezed.dart';
part 'media_controllers.g.dart';

/// Foto çekme ve kovan kartından eklenen medya. Geri al bildirimi ekran
/// kapandıktan sonra da çalışsın diye sürekli yaşar. Kayıtlar yerel DB'ye,
/// dosyalar uygulamanın medya klasörüne yazılır.
@Riverpod(keepAlive: true)
class MediaActions extends _$MediaActions {
  @override
  void build() {}

  /// Kamerayı açar; çekilen ve sıkıştırılan fotoğrafı medya klasörüne
  /// yazar. Vazgeçilirse null. Hata `MediaCaptureException`.
  Future<MediaCapture?> takePhoto() async {
    final files = ref.read(mediaFileStoreProvider);
    final fileName = '${generateId()}.${MediaKind.photo.extension}';
    final path = await files.pathOf(fileName);
    final byteSize = await ref.read(cameraServiceProvider).takePhoto(path);
    if (byteSize == null) return null;
    return MediaCapture(
      fileName: fileName,
      kind: MediaKind.photo,
      capturedAt: clock.now().toUtc(),
      byteSize: byteSize,
    );
  }

  /// [capture]'ı kovanın medyası olarak yazar ve yükleme kuyruğuna ekler.
  Future<MediaItem> addToHive(Hive hive, MediaCapture capture) => ref
      .read(mediaRepositoryProvider)
      .add(orgId: hive.orgId, hiveId: hive.id, capture: capture);

  /// Kovan kartından eklenen medyayı geri alır: kayıt silinir, dosya da.
  Future<void> undoAdd(MediaItem media, MediaCapture capture) async {
    await ref.read(mediaRepositoryProvider).remove(media.id);
    await ref.read(mediaFileStoreProvider).delete(capture.fileName);
  }
}

/// Süren sesli not kaydı.
@freezed
abstract class VoiceRecording with _$VoiceRecording {
  const factory({required String fileName, required DateTime startedAt}) =
      _VoiceRecording;
}

/// Bir ekrandaki ([target]: kovan kartı ya da muayene) sesli not kaydı.
/// Kayıt yokken durum null. Ekran kapanınca (provider bırakılınca) süren
/// kayıt atılır.
@riverpod
class VoiceRecordingController extends _$VoiceRecordingController {
  @override
  VoiceRecording? build(String target) {
    // Bırakılırken ref kullanılamaz; servisler şimdiden alınır.
    final recorder = ref.read(voiceRecorderProvider);
    final files = ref.read(mediaFileStoreProvider);
    ref.onDispose(() {
      if (_recording case final recording?) {
        unawaited(
          recorder.cancel().then((_) => files.delete(recording.fileName)),
        );
      }
    });
    return null;
  }

  /// Bırakılırken okunur; `state` o anda okunamaz.
  VoiceRecording? _recording;

  /// Kaydı başlatır. Hata `MediaCaptureException`.
  Future<void> start() async {
    if (state != null) return;
    final fileName = '${generateId()}.${MediaKind.audio.extension}';
    final path = await ref.read(mediaFileStoreProvider).pathOf(fileName);
    await ref.read(voiceRecorderProvider).start(path);
    final recording = VoiceRecording(
      fileName: fileName,
      startedAt: clock.now(),
    );
    _recording = recording;
    if (ref.mounted) state = recording;
  }

  /// Kaydı bitirir ve çekimi döner; kayıt yoksa null.
  Future<MediaCapture?> stop() async {
    final recording = state;
    if (recording == null) return null;
    state = _recording = null;
    await ref.read(voiceRecorderProvider).stop();
    final file = await ref
        .read(mediaFileStoreProvider)
        .find(recording.fileName);
    if (file == null) return null;
    return MediaCapture(
      fileName: recording.fileName,
      kind: MediaKind.audio,
      capturedAt: recording.startedAt.toUtc(),
      byteSize: file.lengthSync(),
      durationMs: clock.now().difference(recording.startedAt).inMilliseconds,
    );
  }
}

/// Medyanın bu telefondaki dosyası; başka telefonda çekildiyse ve henüz
/// indirilmediyse null. [download] istenince indirir.
@riverpod
class MediaFileController extends _$MediaFileController {
  @override
  Future<File?> build(MediaItem media) async {
    final fileName = await ref
        .read(mediaRepositoryProvider)
        .localFileName(media);
    return await ref.read(mediaFileStoreProvider).find(fileName);
  }

  /// Dosyayı indirir; başarılıysa null, değilse nedeni. İndirme sürerken
  /// durum yükleniyor.
  Future<MediaDownloadFailure?> download() async {
    if (state.isLoading) return null;
    final previous = state.value;
    state = const AsyncLoading();
    try {
      final file = await ref.read(mediaSyncServiceProvider).download(media);
      if (ref.mounted) state = AsyncData(file);
      return null;
    } on MediaDownloadException catch (error) {
      if (ref.mounted) state = AsyncData(previous);
      return error.failure;
    }
  }
}

/// Çalan sesli notun kimliği; çalan yoksa null. Aynı anda tek not çalar.
@Riverpod(keepAlive: true)
class VoicePlayback extends _$VoicePlayback {
  @override
  String? build() => null;

  /// [media]'yı [file]'dan çalar; not bitince durum null olur.
  Future<void> play(MediaItem media, File file) async {
    state = media.id;
    try {
      await ref.read(voicePlayerProvider).play(file.path);
    } finally {
      if (state == media.id) state = null;
    }
  }

  Future<void> stop() async {
    state = null;
    await ref.read(voicePlayerProvider).stop();
  }
}
