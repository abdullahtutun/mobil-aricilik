// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_triggers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulama açıkken medya yüklemesini başlatır:
///
/// - açılış: oturum ve işletme hazır olunca,
/// - yeni foto ya da sesli nottan [mediaUploadDebounce] sonra,
/// - ağ geri gelince ve Wi‑Fi'a geçince,
/// - "sadece Wi‑Fi" ayarı değişince,
/// - workmanager görevi uygulama açıkken çalışırsa
///   ([foregroundMediaPortName] üzerinden).
///
/// Tur bittiğinde yüklenmeyi bekleyen dosya kalırsa arka plan görevi
/// planlanır; uygulama kapansa da ağ gelince yüklenir. `bootstrap`
/// uygulama boyunca dinler.

@ProviderFor(mediaUploadTriggers)
final mediaUploadTriggersProvider = MediaUploadTriggersProvider._();

/// Uygulama açıkken medya yüklemesini başlatır:
///
/// - açılış: oturum ve işletme hazır olunca,
/// - yeni foto ya da sesli nottan [mediaUploadDebounce] sonra,
/// - ağ geri gelince ve Wi‑Fi'a geçince,
/// - "sadece Wi‑Fi" ayarı değişince,
/// - workmanager görevi uygulama açıkken çalışırsa
///   ([foregroundMediaPortName] üzerinden).
///
/// Tur bittiğinde yüklenmeyi bekleyen dosya kalırsa arka plan görevi
/// planlanır; uygulama kapansa da ağ gelince yüklenir. `bootstrap`
/// uygulama boyunca dinler.

final class MediaUploadTriggersProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Uygulama açıkken medya yüklemesini başlatır:
  ///
  /// - açılış: oturum ve işletme hazır olunca,
  /// - yeni foto ya da sesli nottan [mediaUploadDebounce] sonra,
  /// - ağ geri gelince ve Wi‑Fi'a geçince,
  /// - "sadece Wi‑Fi" ayarı değişince,
  /// - workmanager görevi uygulama açıkken çalışırsa
  ///   ([foregroundMediaPortName] üzerinden).
  ///
  /// Tur bittiğinde yüklenmeyi bekleyen dosya kalırsa arka plan görevi
  /// planlanır; uygulama kapansa da ağ gelince yüklenir. `bootstrap`
  /// uygulama boyunca dinler.
  MediaUploadTriggersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaUploadTriggersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaUploadTriggersHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return mediaUploadTriggers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$mediaUploadTriggersHash() =>
    r'bea0d7415d2586bcd0bdd691c0cb09b103355ec6';
