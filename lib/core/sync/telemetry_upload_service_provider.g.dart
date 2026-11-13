// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_upload_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulamadaki tek görüş ve kullanım olayı göndericisi; kilit bu örneğe
/// bağlı olduğu için canlı tutulur.

@ProviderFor(telemetryUploadService)
final telemetryUploadServiceProvider = TelemetryUploadServiceProvider._();

/// Uygulamadaki tek görüş ve kullanım olayı göndericisi; kilit bu örneğe
/// bağlı olduğu için canlı tutulur.

final class TelemetryUploadServiceProvider
    extends
        $FunctionalProvider<
          TelemetryUploadService,
          TelemetryUploadService,
          TelemetryUploadService
        >
    with $Provider<TelemetryUploadService> {
  /// Uygulamadaki tek görüş ve kullanım olayı göndericisi; kilit bu örneğe
  /// bağlı olduğu için canlı tutulur.
  TelemetryUploadServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telemetryUploadServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telemetryUploadServiceHash();

  @$internal
  @override
  $ProviderElement<TelemetryUploadService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TelemetryUploadService create(Ref ref) {
    return telemetryUploadService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TelemetryUploadService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TelemetryUploadService>(value),
    );
  }
}

String _$telemetryUploadServiceHash() =>
    r'f83f6b18d6f0fb81dfddf7fc34c205cb6bdb1b07';
