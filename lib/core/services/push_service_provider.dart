import 'package:mobil_arici/core/services/push_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_service_provider.g.dart';

/// Testler sahtesiyle override eder.
@Riverpod(keepAlive: true)
PushService pushService(Ref ref) => FirebasePushService();
