// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arayüz dilini oturumdaki kullanıcının hesabına yazar; görev bildirimi
/// ve hesap e-postaları gibi sunucunun gönderdikleri bu dilde gider. Giriş
/// yapılınca ve dil değişince çalışır; çevrimdışıysa sessizce vazgeçer,
/// sonraki açılışta yeniden dener.

@ProviderFor(localeSync)
final localeSyncProvider = LocaleSyncProvider._();

/// Arayüz dilini oturumdaki kullanıcının hesabına yazar; görev bildirimi
/// ve hesap e-postaları gibi sunucunun gönderdikleri bu dilde gider. Giriş
/// yapılınca ve dil değişince çalışır; çevrimdışıysa sessizce vazgeçer,
/// sonraki açılışta yeniden dener.

final class LocaleSyncProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Arayüz dilini oturumdaki kullanıcının hesabına yazar; görev bildirimi
  /// ve hesap e-postaları gibi sunucunun gönderdikleri bu dilde gider. Giriş
  /// yapılınca ve dil değişince çalışır; çevrimdışıysa sessizce vazgeçer,
  /// sonraki açılışta yeniden dener.
  LocaleSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeSyncHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return localeSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$localeSyncHash() => r'fd25827c07f2e37ddc2b2cbe371873dac5d21841';
