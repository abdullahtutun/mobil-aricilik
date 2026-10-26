import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/analytics/analytics_repository.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_service_provider.dart';
import 'package:mobil_arici/core/sync/telemetry_upload_service.dart';
import 'package:mobil_arici/core/sync/telemetry_upload_service_provider.dart';
import 'package:mobil_arici/core/sync/telemetry_upload_triggers.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/feedback/data/feedback_repository.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_connectivity_service.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/fake_sync_service.dart';
import '../../helpers/test_database.dart';

/// Gönderim turlarını sayar.
class _FakeUploader implements TelemetryUploadService {
  int uploadCount = 0;

  @override
  DateTime Function() get clock => DateTime.now;

  @override
  Future<TelemetryUploadResult> uploadPending() async {
    uploadCount++;
    return const TelemetryUploadResult(complete: true);
  }
}

const _settle = Duration(milliseconds: 100);

void main() {
  late AppDatabase db;
  late _FakeUploader uploader;
  late FakeConnectivityService connectivity;
  late FakeAuthService auth;

  setUp(() {
    db = openTestDatabase();
    uploader = _FakeUploader();
    connectivity = FakeConnectivityService();
    auth = FakeAuthService(user: testUser);
  });

  Future<ProviderContainer> start(WidgetTester tester) async {
    final container = ProviderContainer.test(
      overrides: [
        authServiceProvider.overrideWithValue(auth),
        ...organizationOverrides(),
        appDatabaseProvider.overrideWithValue(db),
        telemetryUploadServiceProvider.overrideWithValue(uploader),
        connectivityServiceProvider.overrideWithValue(connectivity),
        syncServiceProvider.overrideWithValue(FakeSyncService()),
      ],
    )..listen(telemetryUploadTriggersProvider, (_, _) {});
    await container.read(currentOrganizationProvider.future);
    await tester.pump(_settle);
    return container;
  }

  testWidgets('açılışta gönderir', (tester) async {
    await start(tester);

    expect(uploader.uploadCount, 1);
  });

  testWidgets('oturum yokken göndermez', (tester) async {
    auth = FakeAuthService();
    await start(tester);
    connectivity.reconnect();
    await tester.pump(_settle);

    expect(uploader.uploadCount, 0);
  });

  testWidgets('yeni görüşten 2 sn sonra gönderir', (tester) async {
    await start(tester);

    await tester.runAsync(
      () =>
          FeedbackRepository(db)
              .queue(orgId: 'org-1', kind: FeedbackKind.bug, message: 'Hata'),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(uploader.uploadCount, 1);

    await tester.pump(feedbackUploadDebounce);
    expect(uploader.uploadCount, 2);
  });

  testWidgets('ağ gelince ve her senkron turu bitince gönderir', (
    tester,
  ) async {
    final container = await start(tester);

    connectivity.reconnect();
    await tester.pump(_settle);
    expect(uploader.uploadCount, 2);

    await tester.runAsync(
      () => container.read(syncControllerProvider.notifier).sync(),
    );
    await tester.pump(_settle);
    expect(uploader.uploadCount, 3);
  });

  testWidgets('analitik yeniden açılınca gönderir', (tester) async {
    final analytics = AnalyticsRepository(db);
    await tester.runAsync(() => analytics.setEnabled(enabled: false));
    await start(tester);
    expect(uploader.uploadCount, 1);

    await tester.runAsync(() => analytics.setEnabled(enabled: true));
    await tester.pump(_settle);

    expect(uploader.uploadCount, 2);
  });
}
