import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';

ProviderContainer _container({
  required FakeAuthService auth,
  required FakeOrganizationService service,
  required MemoryOrganizationCache cache,
}) => ProviderContainer.test(
  overrides: [
    authServiceProvider.overrideWithValue(auth),
    ...organizationOverrides(service: service, cache: cache),
  ],
);

void main() {
  group('currentOrganizationProvider', () {
    late FakeAuthService auth;
    late FakeOrganizationService service;
    late MemoryOrganizationCache cache;

    setUp(() {
      auth = FakeAuthService(user: testUser);
      service = FakeOrganizationService(serverOrganization: testOrganization);
      cache = MemoryOrganizationCache();
    });

    ProviderContainer open() =>
        _container(auth: auth, service: service, cache: cache);

    test('giriş yoksa işletme yok, sunucuya gidilmez', () async {
      auth = FakeAuthService();

      expect(await open().read(currentOrganizationProvider.future), isNull);
      expect(service.fetchCount, 0);
    });

    test('ilk girişte işletme sunucudan alınır ve cihaza yazılır', () async {
      expect(
        await open().read(currentOrganizationProvider.future),
        testOrganization,
      );
      expect(cache.entry, (
        userId: testUser.id,
        organization: testOrganization,
      ));
    });

    test('sunucuda işletme yoksa null; cihaza bir şey yazılmaz', () async {
      service.serverOrganization = null;

      expect(await open().read(currentOrganizationProvider.future), isNull);
      expect(cache.entry, isNull);
    });

    test('cihazda kopya yoksa ve ağ yoksa hata verir', () async {
      service.fetchFailure = OrganizationFailure.network;

      await expectLater(
        open().read(currentOrganizationProvider.future),
        throwsA(isA<OrganizationServiceException>()),
      );
    });

    test('cihazdaki kopya ağ beklenmeden kullanılır', () async {
      cache.entry = (userId: testUser.id, organization: testOrganization);
      service
        ..fetchFailure = OrganizationFailure.network
        ..fetchGate = Completer<void>();

      expect(
        await open().read(currentOrganizationProvider.future),
        testOrganization,
      );
    });

    test('sunucudaki güncel hâl sonra kopyanın yerine geçer', () async {
      final renamed = testOrganization.copyWith(
        name: 'Petek Arıcılık Ltd.',
        countryCode: 'DE',
        currency: 'EUR',
      );
      cache.entry = (userId: testUser.id, organization: testOrganization);
      service
        ..serverOrganization = renamed
        ..fetchGate = Completer<void>();
      final container = open();
      final states = <Organization?>[];
      container.listen(
        currentOrganizationProvider,
        (_, next) => states.add(next.value),
        fireImmediately: true,
      );

      expect(
        await container.read(currentOrganizationProvider.future),
        testOrganization,
      );

      service.fetchGate!.complete();
      await container.pump();
      await Future<void>.delayed(Duration.zero);

      expect(container.read(currentOrganizationProvider).value, renamed);
      expect(cache.entry?.organization, renamed);
      expect(states.whereType<Organization>(), [testOrganization, renamed]);
    });

    test('arka planda sunucuya ulaşılamazsa kopya geçerli kalır', () async {
      cache.entry = (userId: testUser.id, organization: testOrganization);
      service.fetchFailure = OrganizationFailure.network;
      final container = open();

      await container.read(currentOrganizationProvider.future);
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(currentOrganizationProvider).value,
        testOrganization,
      );
      expect(service.fetchCount, 1);
    });

    test('başka kullanıcının kopyası kullanılmaz', () async {
      cache.entry = (userId: 'other-user', organization: testOrganization);
      service.serverOrganization = null;

      expect(await open().read(currentOrganizationProvider.future), isNull);
    });

    test('çıkışta kopya silinir ve işletme null olur', () async {
      final container = open();
      await container.read(currentOrganizationProvider.future);
      expect(cache.entry, isNotNull);

      auth.emit(null);
      await Future<void>.delayed(Duration.zero);

      expect(await container.read(currentOrganizationProvider.future), isNull);
      expect(cache.entry, isNull);
    });

    group('create', () {
      setUp(() => service.serverOrganization = null);

      test('işletmeyi kurar; para birimi ülkeden gelir', () async {
        final container = open();
        await container.read(currentOrganizationProvider.future);

        await container
            .read(currentOrganizationProvider.notifier)
            .create(
              id: 'org-1',
              name: 'Duman Arıcılık',
              countryCode: 'DE',
              hiveCountRange: HiveCountRange.upTo10,
            );

        const expected = Organization(
          id: 'org-1',
          name: 'Duman Arıcılık',
          countryCode: 'DE',
          currency: 'EUR',
          hiveCountRange: HiveCountRange.upTo10,
        );
        expect(service.created, [expected]);
        expect(container.read(currentOrganizationProvider).value, expected);
        expect(cache.entry, (userId: testUser.id, organization: expected));
      });

      test('hata atılır, durum değişmez', () async {
        service.createFailure = OrganizationFailure.network;
        final container = open();
        await container.read(currentOrganizationProvider.future);

        await expectLater(
          container
              .read(currentOrganizationProvider.notifier)
              .create(id: 'org-1', name: 'Duman', countryCode: 'TR'),
          throwsA(isA<OrganizationServiceException>()),
        );
        expect(container.read(currentOrganizationProvider).value, isNull);
        expect(cache.entry, isNull);
      });
    });
  });
}
