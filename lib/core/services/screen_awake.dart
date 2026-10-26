import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'screen_awake.g.dart';

/// Ekranın kendiliğinden kararmasını engeller (arılık turu boyunca).
abstract interface class ScreenAwake {
  Future<void> keepOn({required bool enabled});
}

class WakelockScreenAwake implements ScreenAwake {
  const new();

  @override
  Future<void> keepOn({required bool enabled}) =>
      WakelockPlus.toggle(enable: enabled);
}

/// Testler sahte servisle override eder.
@Riverpod(keepAlive: true)
ScreenAwake screenAwake(Ref ref) => const WakelockScreenAwake();
