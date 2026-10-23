import 'package:mobil_arici/core/services/connectivity_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service_provider.g.dart';

/// Testler sahte bağlantıyla override eder.
@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) => PlusConnectivityService();
