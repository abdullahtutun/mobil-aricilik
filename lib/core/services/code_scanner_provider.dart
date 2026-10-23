import 'package:mobil_arici/core/services/code_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_scanner_provider.g.dart';

/// Okut ekranının kamerası. Testler kamerasız, kodu elle veren bir
/// görünümle override eder.
@Riverpod(keepAlive: true)
CodeScannerBuilder codeScanner(Ref ref) =>
    (onCode) => CameraCodeScanner(onCode: onCode);
