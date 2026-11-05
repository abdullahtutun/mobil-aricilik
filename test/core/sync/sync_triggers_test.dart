import 'dart:async';
import 'dart:ui' show IsolateNameServer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/core/sync/sync_repository.dart';
import 'package:mobil_arici/core/sync/sync_service_provider.dart';
import 'package:mobil_arici/core/sync/sync_triggers.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_connectivity_service.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/fake_sync_service.dart';
import '../../helpers/test_database.dart';

/// Provider'ların yeniden hesaplanması için yeterli süre; debounce'tan çok
/// kısa.
const _settle = Duration(milliseconds: 100);

/// Yerel yazma olayları elle verilir; tetikleyiciler başka bir şey okumaz.
class _FakeSyncRepository implements SyncRepository {
  final _writes = StreamController<void>.broadcast();

  void write() => _writes.add(null);

  @override
  Stream<void> watchLocalWrites() => _writes.stream;

  @override
  Stream<int> watchPendingCount() => throw UnimplementedError();

  @override
  Stream<Map<String, int>> watchPendingByTable() => throw UnimplementedError();

  @override
  Stream<DateTime?> watchOldestPendingAt() => throw UnimplementedError();

  @override
  Stream<List<RejectedRecord>> watchRejected() => throw UnimplementedError();

  @override
  Stream<bool> watchFullPullDone() => throw UnimplementedError();
}

void main() {
  late FakeAuthService auth;
  late FakeSyncService service;
  late FakeConnectivityService connectivity;
  late _FakeSyncRepository repository;

  /// Tetikleri `bootstrap` gibi dinler; işletme yüklenip açılış turu
  /// bitene kadar ilerler.
  Future<ProviderContainer> start(WidgetTester tester) async {
    repository = _FakeSyncRepository();
    final container = ProviderContainer.test(
      overrides: [
        authServiceProvider.overrideWithValue(auth),
        ...organizationOverrides(),
        appDatabaseProvider.overrideWithValue(openTestDatabase()),
        syncServiceProvider.overrideWithValue(service),
        syncRepositoryProvider.overrideWithValue(repository),
        connectivityServiceProvider.overrideWithValue(connectivity),
      ],
    )..listen(syncTriggersProvider, (_, _) {});
    await container.read(currentOrganizationProvider.future);
    // Riverpod, işletmeye bağlı `syncReadyProvider`'ı bir zamanlayıcıyla
    // yeniden hesaplar.
    await tester.pump(_settle);
    return container;
  }

  setUp(() {
    auth = FakeAuthService(user: testUser);
    service = FakeSyncService();
    connectivity = FakeConnectivityService();
  });

  testWidgets('oturum ve işletme hazır olunca bir tur başlar', (tester) async {
    await start(tester);

    expect(service.syncCount, 1);
  });

  testWidgets('girişten sonra yeniden tur başlar', (tester) async {
    await start(tester);

    auth.emit(null);
    await tester.pump(_settle);
    auth.emit(testUser);
    await tester.pump(_settle);

    expect(service.syncCount, 2);
  });

  testWidgets('son yerel yazmadan 5 sn sonra tek tur', (tester) async {
    await start(tester);

    repository.write();
    await tester.pump(const Duration(seconds: 4));
    repository.write();
    await tester.pump(const Duration(seconds: 4));
    expect(service.syncCount, 1);

    await tester.pump(const Duration(seconds: 1));
    expect(service.syncCount, 2);
  });

  testWidgets('ağ geri gelince tur başlar', (tester) async {
    await start(tester);

    connectivity.reconnect();
    await tester.pump();

    expect(service.syncCount, 2);
  });

  testWidgets('arka plan görevi uygulama açıkken turu buraya devreder', (
    tester,
  ) async {
    await start(tester);

    IsolateNameServer.lookupPortByName(foregroundSyncPortName)!.send(null);
    // Port mesajı gerçek olay döngüsünden gelir.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();

    expect(service.syncCount, 2);
  });

  testWidgets('oturum yokken tetikler tur başlatmaz', (tester) async {
    auth = FakeAuthService();
    await start(tester);

    repository.write();
    connectivity.reconnect();
    await tester.pump(const Duration(seconds: 5));

    expect(service.syncCount, 0);
  });

  testWidgets('kapanınca port ve bekleyen zamanlayıcı bırakılır', (
    tester,
  ) async {
    final container = await start(tester);
    repository.write();

    container.dispose();
    await tester.pump(const Duration(seconds: 5));

    expect(IsolateNameServer.lookupPortByName(foregroundSyncPortName), isNull);
    expect(service.syncCount, 1);
  });
}
