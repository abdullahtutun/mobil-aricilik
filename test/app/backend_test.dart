import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/backend_setup.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/services/pocketbase_client_provider.dart';
import 'package:mobil_arici/core/sync/backend_providers.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';
import 'package:mobil_arici/core/sync/pocketbase_sync_transport.dart';
import 'package:mobil_arici/core/sync/pocketbase_telemetry_api.dart';
import 'package:mobil_arici/features/account_deletion/data/pocketbase_account_deletion_service.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_providers.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_auth_service.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/data/pocketbase_organization_service.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/data/pocketbase_device_token_service.dart';
import 'package:mobil_arici/features/tasks/presentation/task_push.dart';
import 'package:mobil_arici/features/team/data/pocketbase_team_service.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/weather/data/pocketbase_weather_service.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('flavor varsayılanları', () {
    test('PocketBase adresleri ayrı alt alan adlarında (K-8)', () {
      expect(Flavor.dev.pocketbaseUrl, 'https://arici-api-dev.tutunsoft.com');
      expect(Flavor.prod.pocketbaseUrl, 'https://arici-api.tutunsoft.com');
    });
  });

  group('resolvePocketbaseUrl', () {
    test('PB_URL verilmezse flavor adresi', () {
      expect(
        resolvePocketbaseUrl(Flavor.dev),
        'https://arici-api-dev.tutunsoft.com',
      );
      expect(
        resolvePocketbaseUrl(Flavor.prod),
        'https://arici-api.tutunsoft.com',
      );
    });

    test('PB_URL adresi ezer, sondaki / atılır', () {
      expect(
        resolvePocketbaseUrl(Flavor.prod, define: 'http://127.0.0.1:8090'),
        'http://127.0.0.1:8090',
      );
      expect(
        resolvePocketbaseUrl(Flavor.dev, define: ' http://10.0.2.2:8090/ '),
        'http://10.0.2.2:8090',
      );
    });

    test('testler dart-define vermeden çalışır', () {
      expect(pocketbaseUrlDefine, isEmpty);
    });
  });

  group('syncBackendIdentity', () {
    test('senkronun gittiği adres; ön ek geçişte yazılanla aynı', () {
      expect(
        syncBackendIdentity(Flavor.dev),
        'pocketbase|https://arici-api-dev.tutunsoft.com',
      );
      expect(
        syncBackendIdentity(Flavor.prod),
        'pocketbase|https://arici-api.tutunsoft.com',
      );
    });
  });

  group('provider seçimi', () {
    test("pocketbaseUrlProvider flavor'dan çözülür", () {
      final container = ProviderContainer(
        overrides: [flavorProvider.overrideWithValue(Flavor.dev)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(pocketbaseUrlProvider),
        'https://arici-api-dev.tutunsoft.com',
      );
    });

    test('her servis PocketBase uygulamasıdır ve kayıtlı oturum yalnız aynı '
        'adresten yüklenir', () {
      // AsyncAuthStore yüklediği oturumu depoya yeniden yazar.
      FlutterSecureStorage.setMockInitialValues({});
      final c = ProviderContainer(
        overrides: [
          flavorProvider.overrideWithValue(Flavor.dev),
          storedPocketBaseSessionProvider.overrideWithValue((
            serverUrl: 'https://arici-api-dev.tutunsoft.com',
            data: _session,
          )),
        ],
      );
      addTearDown(c.dispose);

      expect(c.read(authServiceProvider), isA<PocketBaseAuthService>());
      expect(c.read(syncTransportProvider), isA<PocketBaseSyncTransport>());
      expect(c.read(fileStoreProvider), isA<PocketBaseFileStore>());
      expect(c.read(telemetryApiProvider), isA<PocketBaseTelemetryApi>());
      expect(
        c.read(organizationServiceProvider),
        isA<PocketBaseOrganizationService>(),
      );
      expect(c.read(teamServiceProvider), isA<PocketBaseTeamService>());
      expect(c.read(weatherServiceProvider), isA<PocketBaseWeatherService>());
      expect(
        c.read(deviceTokenServiceProvider),
        isA<PocketBaseDeviceTokenService>(),
      );
      expect(
        c.read(accountDeletionServiceProvider),
        isA<PocketBaseAccountDeletionService>(),
      );
      expect(
        c.read(pocketbaseClientProvider).baseURL,
        'https://arici-api-dev.tutunsoft.com',
      );
      expect(c.read(authServiceProvider).currentUser?.id, 'user-1');

      final other = ProviderContainer(
        overrides: [
          flavorProvider.overrideWithValue(Flavor.prod),
          storedPocketBaseSessionProvider.overrideWithValue((
            serverUrl: 'https://arici-api-dev.tutunsoft.com',
            data: _session,
          )),
        ],
      );
      addTearDown(other.dispose);

      expect(other.read(pocketbaseClientProvider).authStore.token, isEmpty);
      expect(other.read(authServiceProvider).currentUser, isNull);
    });
  });
}

const _session =
    '{"token":"a.b.c","model":{"id":"user-1","email":"ari@example.com"}}';
