import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/services/voice_player.dart';
import 'package:mobil_arici/core/services/voice_recorder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_services_provider.g.dart';

/// Testler geçici klasörle override eder.
@Riverpod(keepAlive: true)
MediaFileStore mediaFileStore(Ref ref) => MediaFileStore.app();

/// Testler sahte kamerayla override eder.
@Riverpod(keepAlive: true)
CameraService cameraService(Ref ref) => DeviceCameraService();

/// Testler sahte kayıtçıyla override eder.
@Riverpod(keepAlive: true)
VoiceRecorder voiceRecorder(Ref ref) => DeviceVoiceRecorder();

/// Testler sahte çalarla override eder.
@Riverpod(keepAlive: true)
VoicePlayer voicePlayer(Ref ref) => DeviceVoicePlayer();
