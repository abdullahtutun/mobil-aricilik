import 'package:mobil_arici/core/services/share_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_service_provider.g.dart';

/// Testler sahte paylaşma servisiyle override eder.
@Riverpod(keepAlive: true)
ShareService shareService(Ref ref) => const SharePlusShareService();
