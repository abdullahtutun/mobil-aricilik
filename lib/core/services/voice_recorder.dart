import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:record/record.dart';

/// Mikrofonla sesli not. Kayıt her zaman cihazda, internet gerekmez.
abstract interface class VoiceRecorder {
  /// [targetPath]'e AAC kaydı başlatır. İzin henüz sorulmadıysa sorar. Hata
  /// [MediaCaptureException] olarak gelir.
  Future<void> start(String targetPath);

  /// Kaydı bitirir; dosya [start]'taki yolda.
  Future<void> stop();

  /// Kaydı bırakır ve dosyayı siler.
  Future<void> cancel();
}

/// record ile AAC-LC, tek kanal, düşük bit hızı (teknik.md §6): dakikası
/// ~240 KB.
class DeviceVoiceRecorder implements VoiceRecorder {
  new([AudioRecorder? recorder]) : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;

  static const config = RecordConfig(
    bitRate: 32000,
    sampleRate: 22050,
    numChannels: 1,
  );

  @override
  Future<void> start(String targetPath) async {
    if (!await _recorder.hasPermission()) {
      throw const MediaCaptureException(MediaCaptureFailure.permissionDenied);
    }
    try {
      await _recorder.start(config, path: targetPath);
    } on Exception {
      throw const MediaCaptureException(MediaCaptureFailure.failed);
    }
  }

  @override
  Future<void> stop() async {
    await _recorder.stop();
  }

  @override
  Future<void> cancel() => _recorder.cancel();
}
