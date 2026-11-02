// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_launcher_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler sahte açıcıyla override eder.

@ProviderFor(urlLauncherService)
final urlLauncherServiceProvider = UrlLauncherServiceProvider._();

/// Testler sahte açıcıyla override eder.

final class UrlLauncherServiceProvider
    extends
        $FunctionalProvider<
          UrlLauncherService,
          UrlLauncherService,
          UrlLauncherService
        >
    with $Provider<UrlLauncherService> {
  /// Testler sahte açıcıyla override eder.
  UrlLauncherServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'urlLauncherServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$urlLauncherServiceHash();

  @$internal
  @override
  $ProviderElement<UrlLauncherService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UrlLauncherService create(Ref ref) {
    return urlLauncherService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UrlLauncherService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UrlLauncherService>(value),
    );
  }
}

String _$urlLauncherServiceHash() =>
    r'4d3fa57c444fcde2dfa1c34fd52a17d94e56d203';
