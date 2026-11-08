import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/location_service.dart';
import 'package:mobil_arici/core/services/location_service_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_form_controller.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_location_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ApiaryRepository repository;
  late FakeLocationService location;
  late ProviderContainer container;

  setUp(() async {
    db = openTestDatabase();
    repository = ApiaryRepository(db);
    location = FakeLocationService();
    container = ProviderContainer.test(
      overrides: [
        ...signedIn(db: db),
        locationServiceProvider.overrideWithValue(location),
      ],
    );
    await container.read(currentOrganizationProvider.future);
  });

  /// Formu açar ve ekran açıkmış gibi canlı tutar.
  Future<ApiaryFormController> open([String? apiaryId]) async {
    final provider = apiaryFormControllerProvider(apiaryId);
    container.listen(provider, (_, _) {});
    final controller = container.read(provider.notifier);
    await container.read(provider.future);
    return controller;
  }

  ApiaryFormState? form([String? apiaryId]) =>
      container.read(apiaryFormControllerProvider(apiaryId)).value;

  group('yeni arılık', () {
    test('ad yazılmadan kaydedilmez', () async {
      final controller = await open();
      expect(form()!.canSave, isFalse);

      controller.updateName('   ');

      expect(form()!.canSave, isFalse);
      expect(await controller.save(), isNull);
      expect(await readOutbox(db), isEmpty);
    });

    test('işletmeye yazılır; metinler kırpılır, boşlar boş kalır', () async {
      final controller = await open()
        ..updateName('  Yayla ')
        ..updateNotes('Rüzgârlı\n');

      final id = await controller.save();

      final saved = (await repository.findById(id!))!;
      expect(saved.orgId, testOrganization.id);
      expect(saved.name, 'Yayla');
      expect(saved.notes, 'Rüzgârlı');
      expect(saved.latitude, isNull);
      expect((await readOutbox(db)).single.recordId, id);
    });

    test('GPS konumu ve doğruluğu forma, konum kayda yazılır', () async {
      final controller = await open()
        ..updateName('Yayla');

      await controller.locate();

      expect(form()!.latitude, testFix.latitude);
      expect(form()!.longitude, testFix.longitude);
      expect(form()!.accuracyM, testFix.accuracyM);
      final saved = (await repository.findById((await controller.save())!))!;
      expect(saved.latitude, testFix.latitude);
      expect(saved.longitude, testFix.longitude);
    });

    test(
      'konum alınamazsa neden gösterilir; yeniden deneyince silinir',
      () async {
        final controller = await open();
        location.failure = LocationFailure.permissionDeniedForever;

        await controller.locate();
        expect(
          form()!.locationFailure,
          LocationFailure.permissionDeniedForever,
        );
        expect(form()!.hasLocation, isFalse);

        await controller.openLocationSettings();
        expect(location.openedSettings, [
          LocationFailure.permissionDeniedForever,
        ]);

        location.failure = null;
        await controller.locate();
        expect(form()!.locationFailure, isNull);
        expect(form()!.hasLocation, isTrue);
      },
    );

    test('konum beklenirken kaydedilmez; vazgeçilen konum yazılmaz', () async {
      final controller = await open()
        ..updateName('Yayla');
      location.gate = Completer();

      final locating = controller.locate();
      expect(form()!.locating, isTrue);
      expect(form()!.canSave, isFalse);
      expect(await controller.save(), isNull);

      // İkinci dokunuş yeni istek açmaz.
      unawaited(controller.locate());
      expect(location.requestCount, 1);

      controller.cancelLocate();
      expect(form()!.locating, isFalse);
      location.gate!.complete();
      await locating;

      expect(form()!.hasLocation, isFalse);
      expect(form()!.canSave, isTrue);
    });

    test('yazma hata atarsa kaydetme biter, yeniden denenebilir', () async {
      final failing = ProviderContainer.test(
        overrides: [
          ...signedIn(db: db),
          locationServiceProvider.overrideWithValue(location),
          apiaryRepositoryProvider.overrideWithValue(_FailingRepository(db)),
        ],
      );
      await failing.read(currentOrganizationProvider.future);
      final provider = apiaryFormControllerProvider(null);
      failing.listen(provider, (_, _) {});
      await failing.read(provider.future);
      final controller = failing.read(provider.notifier)..updateName('Yayla');

      await expectLater(controller.save(), throwsA(isA<StateError>()));

      expect(failing.read(provider).value!.saving, isFalse);
      expect(failing.read(provider).value!.canSave, isTrue);
    });

    test('konum kaldırılabilir', () async {
      final controller = await open()
        ..updateName('Yayla');
      await controller.locate();

      controller.clearLocation();

      expect(form()!.hasLocation, isFalse);
      expect(form()!.accuracyM, isNull);
      final saved = (await repository.findById((await controller.save())!))!;
      expect(saved.latitude, isNull);
      expect(saved.longitude, isNull);
    });
  });

  group('düzenleme', () {
    late Apiary apiary;

    setUp(() async {
      apiary = await repository.create(
        orgId: testOrganization.id,
        name: 'Yayla',
        latitude: 40,
        longitude: 29,
        notes: 'Rüzgârlı',
        waterSource: 'Çeşme',
        landTenure: LandTenure.rented,
      );
    });

    test('kayıtlı alanlarla açılır', () async {
      await open(apiary.id);

      expect(
        form(apiary.id),
        const ApiaryFormState(
          name: 'Yayla',
          latitude: 40,
          longitude: 29,
          notes: 'Rüzgârlı',
        ),
      );
    });

    test('formdaki alanları yazar; diğerleri en son hâlinden kalır', () async {
      final controller = await open(apiary.id);
      // Form açıkken başka cihazdan gelen değişiklik.
      await repository.update(apiary.copyWith(waterSource: 'Dere'));

      controller
        ..updateName('Yayla Üst')
        ..updateNotes('')
        ..clearLocation();
      expect(await controller.save(), apiary.id);

      final saved = (await repository.findById(apiary.id))!;
      expect(saved.name, 'Yayla Üst');
      expect(saved.notes, isNull);
      expect(saved.latitude, isNull);
      expect(saved.waterSource, 'Dere');
      expect(saved.landTenure, LandTenure.rented);
      expect(saved.createdAt, apiary.createdAt);
    });

    test('arılık bu arada silindiyse kaydedilmez, form boşalır', () async {
      final controller = await open(apiary.id);
      await repository.delete(apiary.id);
      final outboxBefore = (await readOutbox(db)).length;

      expect(await controller.save(), isNull);

      expect(form(apiary.id), isNull);
      expect(await readOutbox(db), hasLength(outboxBefore));
    });

    test('olmayan arılık için form boş', () async {
      await open('yok');

      expect(form('yok'), isNull);
    });
  });
}

/// Yeni arılığı yazamayan repository (ör. dolu disk).
class _FailingRepository extends ApiaryRepository {
  new(super.db);

  @override
  Future<Apiary> create({
    required String orgId,
    required String name,
    double? latitude,
    double? longitude,
    int? altitudeM,
    LandTenure? landTenure,
    String? waterSource,
    int? vehicleDistanceM,
    String? roadNotes,
    String? notes,
  }) async => throw StateError('yazılamadı');
}
