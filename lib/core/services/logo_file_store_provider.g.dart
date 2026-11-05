// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logo_file_store_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// İşletme logoları (uygulama klasöründe `logos/`). Testler geçici
/// klasörle override eder.

@ProviderFor(logoFileStore)
final logoFileStoreProvider = LogoFileStoreProvider._();

/// İşletme logoları (uygulama klasöründe `logos/`). Testler geçici
/// klasörle override eder.

final class LogoFileStoreProvider
    extends $FunctionalProvider<MediaFileStore, MediaFileStore, MediaFileStore>
    with $Provider<MediaFileStore> {
  /// İşletme logoları (uygulama klasöründe `logos/`). Testler geçici
  /// klasörle override eder.
  LogoFileStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoFileStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoFileStoreHash();

  @$internal
  @override
  $ProviderElement<MediaFileStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaFileStore create(Ref ref) {
    return logoFileStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaFileStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaFileStore>(value),
    );
  }
}

String _$logoFileStoreHash() => r'63ddb136c5f9b73e8769010a00f1a4e847c82631';
