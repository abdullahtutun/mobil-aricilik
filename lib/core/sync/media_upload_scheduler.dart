import 'package:flutter/services.dart' show appFlavor;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workmanager/workmanager.dart';

part 'media_upload_scheduler.g.dart';

/// Medya yükleme görevinin kimliği. iOS'ta `AppDelegate` ve `Info.plist`'teki
/// (`BGTaskSchedulerPermittedIdentifiers`) kimlikle aynı olmalı.
const backgroundMediaUploadTask = 'com.tutunsoft.mobilarici.media';

/// Arka plan görevlerinin `inputData`'sında çalışan flavor'ın adı.
const backgroundFlavorKey = 'flavor';

/// Bekleyen medyanın uygulama kapansa da yüklenmesi.
abstract interface class MediaUploadScheduler {
  /// Arka plan yüklemesini planlar: ağ gelince (ya da [wifiOnly] ise
  /// Wi‑Fi gelince) çalışır, geçici hatada üstel bekleyerek yeniden
  /// denenir. Plan zaten varsa [replace] false iken dokunulmaz; ağ şartı
  /// değişince [replace] ile yenilenir.
  Future<void> schedule({required bool wifiOnly, bool replace = false});
}

/// workmanager'ın tek seferlik görevi. Android'de WorkManager ağ şartını
/// bekler ve başarısız görevi kendisi yeniden dener. iOS'ta görev hemen,
/// kısa bir arka plan süresiyle çalışır; kalanlar periyodik senkron
/// görevinde yüklenir.
class WorkmanagerMediaUploadScheduler implements MediaUploadScheduler {
  const new();

  @override
  Future<void> schedule({required bool wifiOnly, bool replace = false}) =>
      Workmanager().registerOneOffTask(
        backgroundMediaUploadTask,
        backgroundMediaUploadTask,
        constraints: Constraints(
          networkType: wifiOnly ? NetworkType.unmetered : NetworkType.connected,
        ),
        existingWorkPolicy: replace
            ? ExistingWorkPolicy.replace
            : ExistingWorkPolicy.keep,
        backoffPolicy: BackoffPolicy.exponential,
        backoffPolicyDelay: const Duration(minutes: 1),
        inputData: {backgroundFlavorKey: appFlavor},
      );
}

/// Testler planları kaydeden sahteyle override eder.
@Riverpod(keepAlive: true)
MediaUploadScheduler mediaUploadScheduler(Ref ref) =>
    const WorkmanagerMediaUploadScheduler();
