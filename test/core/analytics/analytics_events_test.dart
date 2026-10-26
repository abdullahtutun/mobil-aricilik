import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/shell/scan_controller.dart';
import 'package:mobil_arici/core/analytics/analytics_providers.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_form_controller.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/fake_sync_service.dart';
import '../../helpers/test_database.dart';

/// Kuyruktaki olaylar: (ad, değerler), yazılma sırasıyla. Olaylar
/// beklenmeden yazılır; önce bekleyen işler biter.
Future<List<(String, Map<String, dynamic>)>> _events(AppDatabase db) async {
  await pumpEventQueue(times: 100);
  final rows = await (db.select(
    db.analyticsQueue,
  )..orderBy([(t) => OrderingTerm.asc(t.occurredAt)])).get();
  return [
    for (final row in rows)
      (row.name, jsonDecode(row.props) as Map<String, dynamic>),
  ];
}

void main() {
  late AppDatabase db;
  late FakeSyncService sync;
  late DateTime now;

  setUp(() {
    db = openTestDatabase();
    sync = FakeSyncService();
    now = DateTime.utc(2026, 10, 27, 9);
  });

  Future<ProviderContainer> open() async {
    final container = ProviderContainer.test(
      overrides: signedIn(db: db, sync: sync),
    );
    await container.read(currentOrganizationProvider.future);
    return container;
  }

  Future<Hive> hive({String? tagCode}) async {
    final apiary = await ApiaryRepository(db)
        .create(orgId: testOrganization.id, name: 'Yayla');
    return await HiveRepository(db).create(
      orgId: testOrganization.id,
      number: '12',
      type: HiveType.langstroth,
      apiaryId: apiary.id,
      tagCode: tagCode,
    );
  }

  group('okutma', () {
    test('kod okutulmadan kapanırsa cancelled', () async {
      final container = await open();
      await withClock(Clock.fixed(now), () async {
        container.listen(scanControllerProvider, (_, _) {}).close();
        await container.pump();
      });

      final [(name, props)] = await _events(db);
      expect(name, 'scan_finished');
      expect(props, {
        'result': 'cancelled',
        'unknown_codes': 0,
        'duration_s': 0,
      });
    });

    test('tanınmayan koddan sonra bulunursa found; kod yazılmaz', () async {
      await hive(tagCode: 'MA-0042');
      final container = await open();
      var clockNow = now;
      await withClock(Clock(() => clockNow), () async {
        final subscription = container.listen(
          scanControllerProvider,
          (_, _) {},
        );
        final controller = container.read(scanControllerProvider.notifier);
        await controller.handle('BILINMEYEN-KOD');
        controller.scanAgain();
        clockNow = clockNow.add(const Duration(seconds: 7));
        await controller.handle('MA-0042');
        expect(container.read(scanControllerProvider), isA<ScanFound>());
        subscription.close();
        await container.pump();
      });

      final [(name, props)] = await _events(db);
      expect(name, 'scan_finished');
      expect(props, {'result': 'found', 'unknown_codes': 1, 'duration_s': 7});
      expect(jsonEncode(props), isNot(contains('MA-0042')));
    });
  });

  test('muayene kaydedilince formun açık kaldığı süre yazılır', () async {
    final saved = await hive();
    final container = await open();
    var clockNow = now;
    await withClock(Clock(() => clockNow), () async {
      final provider = inspectionFormControllerProvider(saved.id);
      final subscription = container.listen(provider, (_, _) {});
      await container.read(provider.future);
      clockNow = clockNow.add(const Duration(minutes: 1, seconds: 35));
      final controller = container.read(provider.notifier)..setBeeFrames(8);
      await controller.save();
      await container.pump();
      subscription.close();
    });

    final [(name, props)] = await _events(db);
    expect(name, 'inspection_saved');
    expect(props['duration_s'], 95);
    expect(props['media'], 0);
  });

  test(
    'senkron gönderimi kayıt sayısı ve en uzun gecikmeyle yazılır',
    () async {
      sync
        ..result = const SyncResult(status: SyncStatus.done, pushed: 3)
        ..lastPushDelay = const Duration(minutes: 2, seconds: 30);
      final container = await open();

      await withClock(
        Clock.fixed(now),
        () => container.read(syncControllerProvider.notifier).sync(),
      );
      await container.pump();

      final [(name, props)] = await _events(db);
      expect(name, 'sync_pushed');
      expect(props, {
        'records': 3,
        'rejected': 0,
        'max_delay_s': 150,
        'turn_s': 0,
      });
    },
  );

  test('gönderilecek kayıt yoksa senkron olayı yazılmaz', () async {
    final container = await open();

    await container.read(syncControllerProvider.notifier).sync();
    await container.pump();

    expect(await _events(db), isEmpty);
  });

  test('analitik kapalıyken hiçbir olay yazılmaz', () async {
    final container = await open();
    await container
        .read(analyticsRepositoryProvider)
        .setEnabled(enabled: false);
    sync
      ..result = const SyncResult(status: SyncStatus.done, pushed: 1)
      ..lastPushDelay = Duration.zero;

    await container.read(syncControllerProvider.notifier).sync();
    container.listen(scanControllerProvider, (_, _) {}).close();
    await container.pump();

    expect(await _events(db), isEmpty);
  });
}
