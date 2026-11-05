// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logo_file_triggers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulama açıkken işletme logosunu yükler ve eksikse indirir; belge ve
/// fiş dosyalarıyla aynı anlarda ([listenStorageFileSync]). `bootstrap`
/// uygulama boyunca dinler.

@ProviderFor(logoFileTriggers)
final logoFileTriggersProvider = LogoFileTriggersProvider._();

/// Uygulama açıkken işletme logosunu yükler ve eksikse indirir; belge ve
/// fiş dosyalarıyla aynı anlarda ([listenStorageFileSync]). `bootstrap`
/// uygulama boyunca dinler.

final class LogoFileTriggersProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Uygulama açıkken işletme logosunu yükler ve eksikse indirir; belge ve
  /// fiş dosyalarıyla aynı anlarda ([listenStorageFileSync]). `bootstrap`
  /// uygulama boyunca dinler.
  LogoFileTriggersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoFileTriggersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoFileTriggersHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return logoFileTriggers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$logoFileTriggersHash() => r'1ea72d0695d934b8f158beffc67b5f87c28afa56';
