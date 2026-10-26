import 'dart:async';

import 'package:clock/clock.dart';
import 'package:mobil_arici/core/analytics/analytics_providers.dart';
import 'package:mobil_arici/core/analytics/analytics_rules.dart';
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
///
/// Ekran kapanınca okutma sonucu (analitik) yazılır: kovan bulundu mu,
/// kaç kod tanınmadı, ne kadar sürdü. Kodun kendisi yazılmaz. Tanınmayan
/// koddan sonra vazgeçilirse sonuç `unknown`.
@riverpod
class ScanController extends _$ScanController {
  var _resolving = false;
  var _unknownCount = 0;
  var _found = false;

  @override
  ScanState build() {
    final analytics = ref.read(analyticsRepositoryProvider);
    final openedAt = clock.now();
    ref.onDispose(() {
      unawaited(
        analytics.record(AnalyticsEvent.scanFinished, {
          'result': _found
              ? 'found'
              : _unknownCount > 0
              ? 'unknown'
              : 'cancelled',
          'unknown_codes': _unknownCount,
          'duration_s': durationSeconds(clock.now().difference(openedAt)),
        }),
      );
    });
    return const ScanWaiting();
  }

  Future<void> handle(String code) async {
    if (_resolving || state is! ScanWaiting) return;
    _resolving = true;
    try {
      final hive = await ref.read(hiveLabelActionsProvider.notifier).find(code);
      if (!ref.mounted) return;
      if (hive == null) {
        _unknownCount++;
      } else {
        _found = true;
      }
      state = hive == null ? ScanUnknown(code) : ScanFound(hive);
    } finally {
      _resolving = false;
    }
  }

  /// Tanınmayan koddan sonra kamerayı yeniden açar.
  void scanAgain() => state = const ScanWaiting();
}
