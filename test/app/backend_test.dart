import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/core/sync/backend_providers.dart';
import 'package:mobil_arici/core/sync/supabase_file_store.dart';
import 'package:mobil_arici/core/sync/supabase_sync_transport.dart';
import 'package:mobil_arici/core/sync/supabase_telemetry_api.dart';
import 'package:mobil_arici/features/account_deletion/data/supabase_account_deletion_service.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_providers.dart';
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

    test('PocketBase dalları henüz yazılmadı ve Supabase istemcisine '
        'dokunmaz', () {
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
        syncTransportProvider,
        fileStoreProvider,
        telemetryApiProvider,
        authServiceProvider,
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
  });
}
