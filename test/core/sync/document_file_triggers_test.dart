import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/document_file_triggers.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_service_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_connectivity_service.dart';
import '../../helpers/fake_documents.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/fake_sync_service.dart';
import '../../helpers/test_database.dart';

const _settle = Duration(milliseconds: 100);

void main() {
  late AppDatabase db;
  late FakeDocuments documents;
  late FakeConnectivityService connectivity;
  late FakeAuthService auth;

  setUp(() {
    db = openTestDatabase();
    documents = FakeDocuments();
    connectivity = FakeConnectivityService();
    auth = FakeAuthService(user: testUser);
  });

  Future<ProviderContainer> start(WidgetTester tester) async {
    final container = ProviderContainer.test(
      overrides: [
        authServiceProvider.overrideWithValue(auth),
        ...organizationOverrides(),
        appDatabaseProvider.overrideWithValue(db),
        ...documents.overrides,
        connectivityServiceProvider.overrideWithValue(connectivity),
        syncServiceProvider.overrideWithValue(FakeSyncService()),
      ],
    )..listen(documentFileTriggersProvider, (_, _) {});
    await container.read(currentOrganizationProvider.future);
    await tester.pump(_settle);
    return container;
  }

  testWidgets('açılışta yükler ve işletmenin eksik dosyalarını indirir', (
    tester,
  ) async {
    await start(tester);

    expect(documents.sync.uploadCount, 1);
    expect(documents.sync.downloads, [testOrganization.id]);
  });

  testWidgets('oturum yokken bir şey yapmaz', (tester) async {
    auth = FakeAuthService();
    await start(tester);
    connectivity.reconnect();
    await tester.pump(_settle);

    expect(documents.sync.uploadCount, 0);
    expect(documents.sync.downloads, isEmpty);
  });

  testWidgets('yeni belge dosyasından 2 sn sonra yükler', (tester) async {
    await start(tester);

    await tester.runAsync(
      () => DocumentRepository(db).create(
        orgId: testOrganization.id,
        type: DocumentType.healthReport,
        name: 'Sağlık raporu',
        file: (fileId: 'f1', kind: DocumentFileKind.pdf, byteSize: 10),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(documents.sync.uploadCount, 1);

    await tester.pump(documentUploadDebounce);
    expect(documents.sync.uploadCount, 2);
    // Yeni dosya yalnız yükleme başlatır.
    expect(documents.sync.downloads, hasLength(1));
  });

  testWidgets('ağ gelince ve her senkron turu bitince yükler ve indirir', (
    tester,
  ) async {
    final container = await start(tester);

    connectivity.reconnect();
    await tester.pump(_settle);
    expect(documents.sync.uploadCount, 2);
    expect(documents.sync.downloads, hasLength(2));

    await tester.runAsync(
      () => container.read(syncControllerProvider.notifier).sync(),
    );
    await tester.pump(_settle);
    expect(documents.sync.uploadCount, 3);
    expect(documents.sync.downloads, hasLength(3));
  });
}
