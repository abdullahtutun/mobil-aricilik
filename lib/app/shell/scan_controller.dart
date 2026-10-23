import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_label_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_controller.g.dart';

/// Okut ekranının durumu.
sealed class ScanState {
  const new();
}

/// Kamera açık, kod bekleniyor.
final class ScanWaiting extends ScanState {
  const new();
}

/// Kod bir kovanı açtı; ekran kartına geçer. Sonra gelen kodlar yok sayılır.
final class ScanFound extends ScanState {
  const new(this.hive);

  final Hive hive;
}

/// Kod hiçbir kovanı açmadı; kamera kapanır, ekran nedenini söyler.
final class ScanUnknown extends ScanState {
  const new(this.code);

  final String code;
}

/// Kameradan gelen kodları kovana çevirir. Kamera aynı kodu saniyede
/// birkaç kez verir; bir kod çözülürken ya da sonuç ekrandayken gelenler
/// yok sayılır. Ekran açık kaldığı sürece yaşar.
@riverpod
class ScanController extends _$ScanController {
  var _resolving = false;

  @override
  ScanState build() => const ScanWaiting();

  Future<void> handle(String code) async {
    if (_resolving || state is! ScanWaiting) return;
    _resolving = true;
    try {
      final hive = await ref.read(hiveLabelActionsProvider.notifier).find(code);
      if (!ref.mounted) return;
      state = hive == null ? ScanUnknown(code) : ScanFound(hive);
    } finally {
      _resolving = false;
    }
  }

  /// Tanınmayan koddan sonra kamerayı yeniden açar.
  void scanAgain() => state = const ScanWaiting();
}
