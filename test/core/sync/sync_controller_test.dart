import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/fake_sync_service.dart';
import '../../helpers/test_database.dart';

/// Senkron fırlatırsa: denetleyici turu yine bitirmeli.
class _ThrowingSyncService extends FakeSyncService {
  @override
  Future<SyncResult> sync({void Function(SyncProgress progress)? onProgress}) =>
      Future.error(StateError('DB kapalı'));
}

void main() {
  late FakeAuthService auth;
  late FakeOrganizationService organizations;
  late FakeSyncService service;

  setUp(() {
    auth = FakeAuthService(user: testUser);
    organizations = FakeOrganizationService(
      serverOrganization: testOrganization,
    );
    service = FakeSyncService();
  });

  /// Oturum ve işletme yüklenmiş container.
  Future<ProviderContainer> open() async {
    final container = ProviderContainer.test(
      overrides: [
        authServiceProvider.overrideWithValue(auth),
        ...organizationOverrides(service: organizations),
        appDatabaseProvider.overrideWithValue(openTestDatabase()),
        syncServiceProvider.overrideWithValue(service),
      ],
    );
    await container.read(currentOrganizationProvider.future);
    return container;
  }

  test('oturum yokken tur başlatmaz', () async {
    auth = FakeAuthService();
    final container = await open();

    expect(await container.read(syncControllerProvider.notifier).sync(), null);
    expect(service.syncCount, 0);
    expect(container.read(syncControllerProvider), const SyncActivity());
  });

  test('işletme yokken tur başlatmaz', () async {
    organizations.serverOrganization = null;
    final container = await open();

    expect(await container.read(syncControllerProvider.notifier).sync(), null);
    expect(service.syncCount, 0);
  });

  test('tur sürerken ilerlemeyi, bitince sonucu ve zamanı verir', () async {
    final container = await open();
    const progress = SyncProgress(tablesDone: 2, tableCount: 6, rowsPulled: 40);
    service
      ..progress = const [progress]
      ..gate = Completer<void>()
      ..result = const SyncResult(status: SyncStatus.done, pulled: 40);

    final running = container.read(syncControllerProvider.notifier).sync();
    await pumpEventQueue();
    expect(
      container.read(syncControllerProvider),
      const SyncActivity(running: true, progress: progress),
    );

    service.gate!.complete();
    expect(await running, service.result);
    final activity = container.read(syncControllerProvider);
    expect(activity.running, isFalse);
    expect(activity.progress, isNull);
    expect(activity.lastResult, service.result);
    expect(activity.lastSyncedAt, isNotNull);
  });

  test('tur sürerken gelen çağrı yeni tur başlatmaz', () async {
    final container = await open();
    service.gate = Completer<void>();
    final controller = container.read(syncControllerProvider.notifier);

    final first = controller.sync();
    await pumpEventQueue();
    final second = controller.sync();
    service.gate!.complete();

    expect(await first, service.result);
    expect(await second, service.result);
    expect(service.syncCount, 1);
  });

  test('başarısız tur son eşitleme zamanını değiştirmez', () async {
    final container = await open();
    final controller = container.read(syncControllerProvider.notifier);
    await controller.sync();
    final syncedAt = container.read(syncControllerProvider).lastSyncedAt;

    service.result = const SyncResult(status: SyncStatus.retryLater);
    await controller.sync();

    final activity = container.read(syncControllerProvider);
    expect(activity.lastResult, service.result);
    expect(activity.lastSyncedAt, syncedAt);
  });

  test('beklenmeyen hata turu başarısız bitirir, hatayı iletir', () async {
    service = _ThrowingSyncService();
    final container = await open();

    await expectLater(
      container.read(syncControllerProvider.notifier).sync(),
      throwsStateError,
    );
    expect(
      container.read(syncControllerProvider),
      const SyncActivity(lastResult: SyncResult(status: SyncStatus.failed)),
    );
  });

  test('kullanıcı değişince durum sıfırlanır', () async {
    final container = await open();
    await container.read(syncControllerProvider.notifier).sync();
    expect(container.read(syncControllerProvider).lastResult, isNotNull);

    auth.emit(null);
    await pumpEventQueue();

    expect(container.read(syncControllerProvider), const SyncActivity());
  });
}
