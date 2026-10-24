import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/media_sync_service_provider.dart';
import 'package:mobil_arici/core/sync/media_upload_scheduler.dart';
import 'package:mobil_arici/core/sync/media_upload_triggers.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/media/data/media_repository.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_connectivity_service.dart';
import '../../helpers/fake_media.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/test_database.dart';

/// Planları kaydeder: (sadece Wi‑Fi, yenile).
class _FakeScheduler implements MediaUploadScheduler {
  final plans = <({bool wifiOnly, bool replace})>[];

  @override
  Future<void> schedule({required bool wifiOnly, bool replace = false}) async =>
      plans.add((wifiOnly: wifiOnly, replace: replace));
}

const _settle = Duration(milliseconds: 100);

void main() {
  late AppDatabase db;
  late FakeMedia media;
  late FakeConnectivityService connectivity;
  late _FakeScheduler scheduler;

  setUp(() {
    db = openTestDatabase();
    media = FakeMedia();
    connectivity = FakeConnectivityService();
    scheduler = _FakeScheduler();
  });

  Future<ProviderContainer> start(WidgetTester tester) async {
    final container = ProviderContainer.test(
      overrides: [
        authServiceProvider.overrideWithValue(FakeAuthService(user: testUser)),
        ...organizationOverrides(),
        appDatabaseProvider.overrideWithValue(db),
        mediaSyncServiceProvider.overrideWithValue(media.sync),
        mediaUploadSchedulerProvider.overrideWithValue(scheduler),
        connectivityServiceProvider.overrideWithValue(connectivity),
      ],
    )..listen(mediaUploadTriggersProvider, (_, _) {});
    await container.read(currentOrganizationProvider.future);
    await tester.pump(_settle);
    return container;
  }

  Future<void> capture() => MediaRepository(db).add(
    orgId: 'org-1',
    hiveId: 'hive-1',
    capture: MediaCapture(
      fileName: 'p.jpg',
      kind: MediaKind.photo,
      capturedAt: DateTime.utc(2026, 10, 24),
      byteSize: 1,
    ),
  );

  testWidgets('açılışta yükler; bekleyen yoksa arka plan planlanmaz', (
    tester,
  ) async {
    await start(tester);

    expect(media.sync.uploadCount, 1);
    expect(scheduler.plans, isEmpty);
  });

  testWidgets('yeni çekimden 2 sn sonra yükler; kalan varsa arka plan '
      'görevi planlanır', (tester) async {
    await start(tester);

    await tester.runAsync(capture);
    await tester.pump(const Duration(seconds: 1));
    expect(media.sync.uploadCount, 1);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump(_settle);
    expect(media.sync.uploadCount, 2);
    // Sahte yükleyici dosyayı bekleyen bırakır.
    expect(scheduler.plans, [(wifiOnly: false, replace: false)]);
  });

  testWidgets('ağ gelince ve Wi‑Fi’a geçince yükler', (tester) async {
    await start(tester);

    connectivity.reconnect();
    await tester.pump(_settle);
    connectivity.connectUnmetered();
    await tester.pump(_settle);

    expect(media.sync.uploadCount, 3);
  });

  testWidgets('"sadece Wi‑Fi" değişince plan yeni ağ şartıyla yenilenir', (
    tester,
  ) async {
    await tester.runAsync(capture);
    await start(tester);
    scheduler.plans.clear();

    await tester.runAsync(
      () => LocalSettingsRepository(db).setMediaWifiOnly(enabled: true),
    );
    await tester.pump(_settle);

    expect(scheduler.plans, contains((wifiOnly: true, replace: true)));
    // Açılıştaki çekimin yükleme sayacı.
    await tester.pump(mediaUploadDebounce);
  });
}
