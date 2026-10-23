import 'package:mobil_arici/core/services/print_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_service_provider.g.dart';

/// Testler sahte yazdırma servisiyle override eder.
@Riverpod(keepAlive: true)
PrintService printService(Ref ref) => const PrintingPrintService();
