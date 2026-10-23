// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_scanner_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Okut ekranının kamerası. Testler kamerasız, kodu elle veren bir
/// görünümle override eder.

@ProviderFor(codeScanner)
final codeScannerProvider = CodeScannerProvider._();

/// Okut ekranının kamerası. Testler kamerasız, kodu elle veren bir
/// görünümle override eder.

final class CodeScannerProvider
    extends
        $FunctionalProvider<
          CodeScannerBuilder,
          CodeScannerBuilder,
          CodeScannerBuilder
        >
    with $Provider<CodeScannerBuilder> {
  /// Okut ekranının kamerası. Testler kamerasız, kodu elle veren bir
  /// görünümle override eder.
  CodeScannerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeScannerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeScannerHash();

  @$internal
  @override
  $ProviderElement<CodeScannerBuilder> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CodeScannerBuilder create(Ref ref) {
    return codeScanner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CodeScannerBuilder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CodeScannerBuilder>(value),
    );
  }
}

String _$codeScannerHash() => r'72aa9382bfda9a23ef0126598d8390deedcf2fe5';
