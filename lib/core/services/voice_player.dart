import 'package:just_audio/just_audio.dart';

/// Sesli notu çalar; aynı anda tek not.
abstract interface class VoicePlayer {
  /// [path]'teki dosyayı baştan çalar; çalan başka not varsa durur. Not
  /// bitince ya da [stop] ile durunca tamamlanır.
  Future<void> play(String path);

  Future<void> stop();
}

class DeviceVoicePlayer implements VoicePlayer {
  new([AudioPlayer? player]) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  @override
  Future<void> play(String path) async {
    await _player.stop();
    await _player.setFilePath(path);
    // Çalma bitince ya da durdurulunca tamamlanır.
    await _player.play();
    await _player.stop();
  }

  @override
  Future<void> stop() => _player.stop();
}
