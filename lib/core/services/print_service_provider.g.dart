// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler sahte yazdırma servisiyle override eder.

@ProviderFor(printService)
final printServiceProvider = PrintServiceProvider._();

/// Testler sahte yazdırma servisiyle override eder.

final class PrintServiceProvider
    extends $FunctionalProvider<PrintService, PrintService, PrintService>
    with $Provider<PrintService> {
  /// Testler sahte yazdırma servisiyle override eder.
  PrintServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'printServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$printServiceHash();

  @$internal
  @override
  $ProviderElement<PrintService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrintService create(Ref ref) {
    return printService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrintService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrintService>(value),
    );
  }
}

String _$printServiceHash() => r'4a483b6ef27a62dcf191accf63add0daf52f29f3';
