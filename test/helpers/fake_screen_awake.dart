import 'package:mobil_arici/core/services/screen_awake.dart';

/// Ekransız servis: son istenen durumu tutar.
class FakeScreenAwake implements ScreenAwake {
  bool keptOn = false;

  @override
  Future<void> keepOn({required bool enabled}) async => keptOn = enabled;
}
