import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/bulk_hive_form_controller.dart';
import 'package:mobil_arici/features/hives/presentation/hive_form_controller.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late HiveRepository hives;
  late String apiaryId;
  late ProviderContainer container;

  setUp(() async {
    db = openTestDatabase();
    hives = HiveRepository(db);
    apiaryId = (await ApiaryRepository(
      db,
    ).create(orgId: testOrganization.id, name: 'Yayla')).id;
    container = ProviderContainer.test(overrides: signedIn(db: db));
    await container.read(currentOrganizationProvider.future);
  });

  Future<Hive> createHive({HiveStatus status = HiveStatus.active}) =>
      hives.create(
        orgId: testOrganization.id,
        number: '101',
        type: HiveType.langstroth,
        apiaryId: apiaryId,
        status: status,
        source: HiveSource.split,
      );

  group('kovan formu', () {
    /// Formu açar ve ekran açıkmış gibi canlı tutar.
    Future<HiveFormController> open({String? hiveId, String? apiary}) async {
      final provider = hiveFormControllerProvider(
        apiaryId: apiary ?? apiaryId,
        hiveId: hiveId,
      );
      container.listen(provider, (_, _) {});
      final controller = container.read(provider.notifier);
      await container.read(provider.future);
      return controller;
    }

    HiveFormState? form({String? hiveId}) => container
        .read(hiveFormControllerProvider(apiaryId: apiaryId, hiveId: hiveId))
        .value;

    test('numara yazılmadan kaydedilmez', () async {
      final controller = await open();
      expect(form()!.canSave, isFalse);

      controller.updateNumber('   ');

      expect(form()!.canSave, isFalse);
      expect(await controller.save(), isNull);
      expect(await db.select(db.hives).get(), isEmpty);
    });

    test('yeni kovan arılığa yazılır; numara kırpılır', () async {
      final controller = await open()
        ..updateNumber(' A-12 ')
        ..selectType(HiveType.dadant)
        ..selectSource(HiveSource.swarm);

      final id = await controller.save();

      final saved = (await hives.findById(id!))!;
      expect(saved.orgId, testOrganization.id);
      expect(saved.apiaryId, apiaryId);
      expect(saved.number, 'A-12');
      expect(saved.type, HiveType.dadant);
      expect(saved.status, HiveStatus.active);
      expect(saved.source, HiveSource.swarm);
      expect(form()!.saving, isFalse);
    });

    test('yeni kovanda varsayılanlar Langstroth ve aktif; onay yok', () async {
      final controller = await open();
      expect(form()!.type, HiveType.langstroth);
      expect(form()!.status, HiveStatus.active);
      expect(form()!.source, isNull);

      controller.selectStatus(HiveStatus.dead);

      // Yeni kovan henüz sayılmıyor.
      expect(form()!.needsConfirmation, isFalse);
    });

    test('olmayan arılığa kovan eklenmez', () async {
      await open(apiary: 'yok');

      expect(
        container.read(hiveFormControllerProvider(apiaryId: 'yok')).value,
        isNull,
      );
    });

    test('düzenleme kayıtlı değerle açılır, formdaki alanları yazar', () async {
      final hive = await createHive();
      await hives.update(hive.copyWith(marking: 'Mavi kapak', boxCount: 2));
      final controller = await open(hiveId: hive.id);
      expect(form(hiveId: hive.id)!.number, '101');
      expect(form(hiveId: hive.id)!.source, HiveSource.split);

      controller
        ..updateNumber('102')
        ..selectSource(null);
      await controller.save();

      final saved = (await hives.findById(hive.id))!;
      expect(saved.number, '102');
      expect(saved.source, isNull);
      expect(saved.marking, 'Mavi kapak');
      expect(saved.boxCount, 2);
      expect(saved.apiaryId, apiaryId);
    });

    test('aktif kovanı aktif dışına almak onay ister', () async {
      final hive = await createHive();
      final controller = await open(hiveId: hive.id);

      for (final status in [
        HiveStatus.dead,
        HiveStatus.merged,
        HiveStatus.sold,
        HiveStatus.lost,
      ]) {
        controller.selectStatus(status);
        expect(form(hiveId: hive.id)!.needsConfirmation, isTrue);
      }
      controller.selectStatus(HiveStatus.active);
      expect(form(hiveId: hive.id)!.needsConfirmation, isFalse);
    });

    test('aktif olmayan kovanı yeniden aktif yapmak onay istemez', () async {
      final hive = await createHive(status: HiveStatus.dead);
      final controller = await open(hiveId: hive.id)
        ..selectStatus(HiveStatus.active);

      expect(form(hiveId: hive.id)!.needsConfirmation, isFalse);
      await controller.save();
      expect((await hives.findById(hive.id))!.status, HiveStatus.active);
    });

    test('düzenlenen kovan arada silinirse durum boşalır', () async {
      final hive = await createHive();
      final controller = await open(hiveId: hive.id);
      await hives.delete(hive.id);

      expect(await controller.save(), isNull);
      expect(form(hiveId: hive.id), isNull);
    });
  });

  group('toplu oluşturma formu', () {
    Future<BulkHiveFormController> open([String? apiary]) async {
      final provider = bulkHiveFormControllerProvider(apiary ?? apiaryId);
      container.listen(provider, (_, _) {});
      final controller = container.read(provider.notifier);
      await container.read(provider.future);
      return controller;
    }

    BulkHiveFormState? form() =>
        container.read(bulkHiveFormControllerProvider(apiaryId)).value;

    test("20 kovan, 101'den: numaralar ve tek transaction", () async {
      final controller = await open()
        ..updateCount('20')
        ..updateStartNumber('101')
        ..selectType(HiveType.local)
        ..selectSource(HiveSource.package);
      expect(form()!.numbers, hasLength(20));
      expect(form()!.canSave, isTrue);

      expect(await controller.save(), 20);

      final saved = await hives.watchByApiary(apiaryId).first;
      expect(saved.map((h) => h.number), [
        for (var n = 101; n <= 120; n++) '$n',
      ]);
      expect(saved.every((h) => h.type == HiveType.local), isTrue);
      expect(saved.every((h) => h.source == HiveSource.package), isTrue);
      expect(saved.every((h) => h.orgId == testOrganization.id), isTrue);
      expect(await db.select(db.hiveLocationHistory).get(), hasLength(20));
    });

    test('eksik ya da geçersiz alanla kaydedilmez', () async {
      final controller = await open();
      Future<void> expectBlocked() async {
        expect(form()!.numbers, isNull);
        expect(form()!.canSave, isFalse);
        expect(await controller.save(), isNull);
      }

      await expectBlocked();
      controller.updateCount('20');
      await expectBlocked();
      controller
        ..updateCount('0')
        ..updateStartNumber('101');
      await expectBlocked();
      controller.updateCount('501');
      expect(form()!.countTooLarge, isTrue);
      await expectBlocked();
      controller.updateCount('500');
      expect(form()!.countTooLarge, isFalse);
      expect(form()!.canSave, isTrue);

      expect(await db.select(db.hives).get(), isEmpty);
    });

    test('olmayan arılık için form açılmaz', () async {
      await open('yok');

      expect(
        container.read(bulkHiveFormControllerProvider('yok')).value,
        isNull,
      );
    });
  });
}
