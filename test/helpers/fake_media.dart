import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/services/voice_player.dart';
import 'package:mobil_arici/core/services/voice_recorder.dart';
import 'package:mobil_arici/core/sync/media_sync_service.dart';
import 'package:mobil_arici/core/sync/media_sync_service_provider.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';

/// 1x1 PNG; Flutter'ın çözücüsü uzantıya bakmaz.
const tinyImage = [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, //
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, //
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

/// Cihazsız medya: geçici klasörde dosya deposu, sahte kamera, kayıtçı,
/// çalar ve Storage. Dosyalar eşzamanlı yazılır; widget testlerinin sahte
/// zamanında asenkron dosya işlemi bitmez.
class FakeMedia {
  new() : directory = Directory.systemTemp.createTempSync('fake_media') {
    addTearDown(() => directory.deleteSync(recursive: true));
  }

  final Directory directory;
  late final store = MediaFileStore(Future.value(directory));
  final camera = FakeCameraService();
  final recorder = FakeVoiceRecorder();
  final player = FakeVoicePlayer();
  late final sync = FakeMediaSyncService(directory);

  /// Medya klasöründeki dosya adları.
  List<String> get fileNames =>
      [for (final entity in directory.listSync()) entity.uri.pathSegments.last]
        ..sort();

  List<Override> get overrides => [
    mediaFileStoreProvider.overrideWithValue(store),
    cameraServiceProvider.overrideWithValue(camera),
    voiceRecorderProvider.overrideWithValue(recorder),
    voicePlayerProvider.overrideWithValue(player),
    mediaSyncServiceProvider.overrideWithValue(sync),
  ];
}

class FakeCameraService implements CameraService {
  /// Sonraki çekimin hatası.
  MediaCaptureFailure? failure;

  /// Kullanıcı kamerayı kapatır.
  bool cancel = false;

  int photoCount = 0;

  @override
  Future<int?> takePhoto(String targetPath) async {
    if (failure case final failure?) throw MediaCaptureException(failure);
    if (cancel) return null;
    photoCount++;
    File(targetPath).writeAsBytesSync(tinyImage);
    return tinyImage.length;
  }

  int pickCount = 0;

  /// Galeriden seçim; [failure] ve [cancel] çekimdeki gibi.
  @override
  Future<int?> pickImage(String targetPath) async {
    if (failure case final failure?) throw MediaCaptureException(failure);
    if (cancel) return null;
    pickCount++;
    File(targetPath).writeAsBytesSync(tinyImage);
    return tinyImage.length;
  }
}

class FakeVoiceRecorder implements VoiceRecorder {
  MediaCaptureFailure? failure;
  String? recordingPath;
  int cancelCount = 0;

  @override
  Future<void> start(String targetPath) async {
    if (failure case final failure?) throw MediaCaptureException(failure);
    recordingPath = targetPath;
  }

  @override
  Future<void> stop() async {
    File(recordingPath!).writeAsBytesSync(List.filled(4800, 1));
    recordingPath = null;
  }

  @override
  Future<void> cancel() async {
    cancelCount++;
    recordingPath = null;
  }
}

class FakeVoicePlayer implements VoicePlayer {
  final played = <String>[];
  Completer<void>? _playing;

  @override
  Future<void> play(String path) {
    played.add(path);
    _playing?.complete();
    return (_playing = Completer<void>()).future;
  }

  @override
  Future<void> stop() async {
    _playing?.complete();
    _playing = null;
  }
}

/// Storage: [remote]'taki yollar indirilebilir; yükleme sayılır.
class FakeMediaSyncService implements MediaSyncService {
  new(this._directory);

  final Directory _directory;

  /// `storage_path` → dosya.
  final remote = <String, List<int>>{};

  /// Doluysa indirme bu nedenle başarısız olur.
  MediaDownloadFailure? downloadFailure;

  int uploadCount = 0;

  @override
  DateTime Function() get clock => DateTime.now;

  @override
  Future<MediaUploadResult> uploadPending() async {
    uploadCount++;
    return const MediaUploadResult(MediaUploadOutcome.done);
  }

  @override
  Future<File> download(MediaItem media) async {
    if (downloadFailure case final failure?) {
      throw MediaDownloadException(failure);
    }
    final bytes = remote[media.storagePath];
    if (bytes == null) {
      throw const MediaDownloadException(MediaDownloadFailure.notUploaded);
    }
    return File('${_directory.path}/${downloadFileName(media)}')
      ..writeAsBytesSync(bytes);
  }
}
