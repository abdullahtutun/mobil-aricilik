import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/backend_setup.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/services/pocketbase_client_provider.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/core/sync/backend_providers.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';
import 'package:mobil_arici/core/sync/pocketbase_sync_transport.dart';
import 'package:mobil_arici/core/sync/supabase_file_store.dart';
import 'package:mobil_arici/core/sync/supabase_sync_transport.dart';
import 'package:mobil_arici/core/sync/supabase_telemetry_api.dart';
import 'package:mobil_arici/features/account_deletion/data/supabase_account_deletion_service.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_providers.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_auth_service.dart';
import 'package:mobil_arici/features/auth/data/supabase_auth_service.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/data/supabase_organization_service.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/data/supabase_device_token_service.dart';
import 'package:mobil_arici/features/tasks/presentation/task_push.dart';
import 'package:mobil_arici/features/team/data/supabase_team_service.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/weather/data/supabase_weather_service.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('flavor varsayılanları', () {
    test('iki flavor da şimdilik Supabase kullanır', () {
      expect(Flavor.dev.defaultBackend, Backend.supabase);
      expect(Flavor.prod.defaultBackend, Backend.supabase);
    });

    test('PocketBase adresleri ayrı alt alan adlarında (K-8)', () {
      expect(Flavor.dev.pocketbaseUrl, 'https://arici-api-dev.tutunsoft.com');
      expect(Flavor.prod.pocketbaseUrl, 'https://arici-api.tutunsoft.com');
    });
  });

  group('resolveBackend', () {
    test('BACKEND verilmezse flavor varsayılanı', () {
      for (final flavor in Flavor.values) {
        // Testler dart-define almaz; varsayılan değer boş.
        expect(resolveBackend(flavor), flavor.defaultBackend);
        expect(resolveBackend(flavor, define: '  '), flavor.defaultBackend);
      }
    });

    test('BACKEND varsayılanı ezer', () {
      for (final flavor in Flavor.values) {
        expect(
          resolveBackend(flavor, define: 'pocketbase'),
          Backend.pocketbase,
        );
        expect(resolveBackend(flavor, define: 'supabase'), Backend.supabase);
      }
    });

    test('tanınmayan değer sessizce geçilmez', () {
      expect(
        () => resolveBackend(Flavor.dev, define: 'PocketBase'),
        throwsArgumentError,
      );
      expect(
        () => resolveBackend(Flavor.dev, define: 'firebase'),
        throwsArgumentError,
      );
    });

    test('testler dart-define vermeden çalışır', () {
      expect(backendDefine, isEmpty);
      expect(pocketbaseUrlDefine, isEmpty);
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
  });

  group('syncBackendIdentity', () {
    test('backend adı ve senkronun gittiği adres', () {
      expect(
        syncBackendIdentity(Flavor.dev, Backend.supabase),
        'supabase|${Flavor.dev.supabaseUrl}',
      );
      expect(
        syncBackendIdentity(Flavor.dev, Backend.pocketbase),
        'pocketbase|https://arici-api-dev.tutunsoft.com',
      );
      expect(
        syncBackendIdentity(Flavor.prod, Backend.pocketbase),
        'pocketbase|https://arici-api.tutunsoft.com',
      );
    });
  });

  group('provider seçimi', () {
    ProviderContainer container(Backend backend) {
      final client = SupabaseClient('http://localhost:54321', 'anon-key');
      final container = ProviderContainer(
        overrides: [
          backendProvider.overrideWithValue(backend),
          supabaseClientProvider.overrideWithValue(client),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await client.dispose();
      });
      return container;
    }

    test("backendProvider ve pocketbaseUrlProvider flavor'dan çözülür", () {
      final container = ProviderContainer(
        overrides: [flavorProvider.overrideWithValue(Flavor.dev)],
      );
      addTearDown(container.dispose);

      expect(container.read(backendProvider), Backend.supabase);
      expect(
        container.read(pocketbaseUrlProvider),
        'https://arici-api-dev.tutunsoft.com',
      );
    });

    test('Supabase seçiliyken her servis Supabase uygulamasıdır', () {
      final c = container(Backend.supabase);

      expect(c.read(syncTransportProvider), isA<SupabaseSyncTransport>());
      expect(c.read(fileStoreProvider), isA<SupabaseFileStore>());
      expect(c.read(telemetryApiProvider), isA<SupabaseTelemetryApi>());
      expect(c.read(authServiceProvider), isA<SupabaseAuthService>());
      expect(
        c.read(organizationServiceProvider),
        isA<SupabaseOrganizationService>(),
      );
      expect(c.read(teamServiceProvider), isA<SupabaseTeamService>());
      expect(c.read(weatherServiceProvider), isA<SupabaseWeatherService>());
      expect(
        c.read(deviceTokenServiceProvider),
        isA<SupabaseDeviceTokenService>(),
      );
      expect(
        c.read(accountDeletionServiceProvider),
        isA<SupabaseAccountDeletionService>(),
      );
    });

    test('PocketBase dalları (giriş, senkron ve dosyalardan başka) henüz '
        'yazılmadı '
        've Supabase istemcisine dokunmaz', () {
      final c = ProviderContainer(
        overrides: [
          backendProvider.overrideWithValue(Backend.pocketbase),
          supabaseClientProvider.overrideWith(
            (_) => fail('PocketBase seçiliyken Supabase istemcisi açıldı'),
          ),
        ],
      );
      addTearDown(c.dispose);

      for (final provider in <ProviderListenable<Object>>[
        telemetryApiProvider,
        organizationServiceProvider,
        teamServiceProvider,
        weatherServiceProvider,
        deviceTokenServiceProvider,
        accountDeletionServiceProvider,
      ]) {
        expect(
          () => c.read<Object>(provider),
          throwsA(
            isA<ProviderException>().having(
              (error) => error.exception,
              'exception',
              isA<UnimplementedError>(),
            ),
          ),
          reason: '$provider',
        );
      }
    });

    test('PocketBase seçiliyken giriş, senkron ve dosyalar PocketBase '
        'uygulamasıdır '
        've kayıtlı oturum yalnız aynı adresten yüklenir', () {
      // AsyncAuthStore yüklediği oturumu depoya yeniden yazar.
      FlutterSecureStorage.setMockInitialValues({});
      final c = ProviderContainer(
        overrides: [
          flavorProvider.overrideWithValue(Flavor.dev),
          backendProvider.overrideWithValue(Backend.pocketbase),
          supabaseClientProvider.overrideWith(
            (_) => fail('PocketBase seçiliyken Supabase istemcisi açıldı'),
          ),
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
      expect(
        c.read(pocketbaseClientProvider).baseURL,
        'https://arici-api-dev.tutunsoft.com',
      );
      expect(c.read(authServiceProvider).currentUser?.id, 'user-1');

      final other = ProviderContainer(
        overrides: [
          flavorProvider.overrideWithValue(Flavor.prod),
          backendProvider.overrideWithValue(Backend.pocketbase),
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
