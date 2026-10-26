// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_upload_triggers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulama açıkken görüş ve kullanım olayı gönderimini başlatır:
///
/// - açılış: oturum ve işletme hazır olunca,
/// - yeni görüşten [feedbackUploadDebounce] sonra,
/// - ağ geri gelince,
/// - her senkron turu bitince (olaylar senkronla aynı sıklıkta gider),
/// - analitik yeniden açılınca.
///
/// Arka plan görevi yok; uygulama kapalıyken kuyrukta bekler. `bootstrap`
/// uygulama boyunca dinler.

@ProviderFor(telemetryUploadTriggers)
final telemetryUploadTriggersProvider = TelemetryUploadTriggersProvider._();

/// Uygulama açıkken görüş ve kullanım olayı gönderimini başlatır:
///
/// - açılış: oturum ve işletme hazır olunca,
/// - yeni görüşten [feedbackUploadDebounce] sonra,
/// - ağ geri gelince,
/// - her senkron turu bitince (olaylar senkronla aynı sıklıkta gider),
/// - analitik yeniden açılınca.
///
/// Arka plan görevi yok; uygulama kapalıyken kuyrukta bekler. `bootstrap`
/// uygulama boyunca dinler.

final class TelemetryUploadTriggersProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Uygulama açıkken görüş ve kullanım olayı gönderimini başlatır:
  ///
  /// - açılış: oturum ve işletme hazır olunca,
  /// - yeni görüşten [feedbackUploadDebounce] sonra,
  /// - ağ geri gelince,
  /// - her senkron turu bitince (olaylar senkronla aynı sıklıkta gider),
  /// - analitik yeniden açılınca.
  ///
  /// Arka plan görevi yok; uygulama kapalıyken kuyrukta bekler. `bootstrap`
  /// uygulama boyunca dinler.
  TelemetryUploadTriggersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telemetryUploadTriggersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telemetryUploadTriggersHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return telemetryUploadTriggers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$telemetryUploadTriggersHash() =>
    r'd733ad22f6412008e52d8154fa09ee321e606e58';
