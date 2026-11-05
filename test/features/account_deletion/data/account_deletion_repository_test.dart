import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/features/account_deletion/data/account_deletion_repository.dart';
import 'package:mobil_arici/features/account_deletion/data/device_data_wiper.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/offline_maps/data/map_area_store.dart';

import '../../../helpers/business_seed.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_reminder_notifications.dart';
import '../../../helpers/test_database.dart';

const _orgId = '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a';

/// Yayımlanmış bir lot (herkese açık sayfası var) ve yayımlanmamış biri.
Future<void> _seedLots(AppDatabase db) async {
  for (final (id, published) in [('lot-1', 1), ('lot-2', 0)]) {
    await db.customStatement(
      'INSERT INTO lots (id, org_id, year, seq, honey_kind, status, '
      'published, created_at, updated_at) VALUES (?, ?, 2026, 1, '
      "'pine', 'open', ?, '2026-10-01T00:00:00.000Z', "
      "'2026-10-01T00:00:00.000Z')",
      [id, _orgId, published],
    );
  }
}

void main() {
  late AppDatabase db;
  late AccountDeletionRepository repository;

  setUp(() {
    db = openTestDatabase();
    repository = AccountDeletionRepository(
      db,
      clock: () => DateTime.utc(2026, 11, 5, 10),
    );
  });
  tearDown(() => db.close());

  test('silinmemiş kayıtları ve yayımdaki lot sayfalarını sayar', () async {
    expect(_orgId, testOrganization.id);
    await seedCountedRecords(db);
    await _seedLots(db);

    final counts = await repository.watchCounts(_orgId).first;

    expect(counts, (
      // Sönmüş kovan da silinene kadar sayılır (sunucudaki sayımla aynı).
      hives: 4,
      apiaries: 2,
      inspections: 4,
      harvests: 0,
      documents: 0,
      photos: 0,
      publicLotPages: 1,
    ));
  });

  test('sayılar kayıt değişince yeniden gelir', () async {
    final stream = repository.watchCounts(_orgId);
    expect((await stream.first).apiaries, 0);
    await ApiaryRepository(db).create(orgId: _orgId, name: 'Ova');
    expect((await stream.first).apiaries, 1);
  });

  test('tüm kayıtlar tek JSON dosyasında, sunucunun kolon adlarıyla', () async {
    await insertOrganizationRow(db);
    await seedCountedRecords(db);
    await _seedLots(db);
    await db.customStatement(
      'INSERT INTO transactions (id, org_id, kind, category, amount, '
      "currency, occurred_on, created_at, updated_at) VALUES ('t-1', ?, "
      "'income', 'honey_sale', 100, 'TRY', '2026-10-01', "
      "'2026-10-01T00:00:00.000Z', '2026-10-01T00:00:00.000Z')",
      [_orgId],
    );

    final json = jsonDecode(
      utf8.decode(await repository.exportJson(_orgId, includeFinance: true)),
    ) as Map<String, Object?>;
    final tables = json['tables']! as Map<String, Object?>;

    expect(json['format'], 'mobil-arici-export');
    expect(json['exported_at'], '2026-11-05T10:00:00.000Z');
    expect(
      (tables['organizations']! as List).single,
      containsPair('name', 'Yılmaz Arıcılık'),
    );
    final apiaries = (tables['apiaries']! as List).cast<Map<String, Object?>>();
    // Silinmiş arılık dosyaya girmez.
    expect(apiaries.map((a) => a['name']), unorderedEquals(['Ova', 'Yayla']));
    expect(apiaries.first.keys, containsAll(['id', 'org_id', 'created_at']));
    expect(apiaries.first.keys, isNot(contains('server_seq')));
    expect(apiaries.first['created_at'], isA<String>());
    expect(tables['hives']! as List, hasLength(4));
    expect(tables['lots']! as List, hasLength(2));
    expect(tables['transactions']! as List, hasLength(1));
    // Kuyruklar ve başvuru tabloları girmez.
    expect(tables.keys, isNot(contains('outbox')));
    expect(tables.keys, isNot(contains('ref_drugs')));
    expect(tables.keys, isNot(contains('media_uploads')));

    final withoutFinance = jsonDecode(
      utf8.decode(await repository.exportJson(_orgId, includeFinance: false)),
    ) as Map<String, Object?>;
    expect(
      (withoutFinance['tables']! as Map).keys,
      isNot(contains('transactions')),
    );
  });

  group('DeviceDataWiper', () {
    late Directory root;
    late MediaFileStore media;
    late MapAreaStore maps;
    late FakeReminderNotifications reminders;
    late Directory temp;
    var secureCleared = 0;

    setUp(() {
      root = Directory.systemTemp.createTempSync('wiper');
      media = MediaFileStore(Future.value(Directory('${root.path}/media')));
      maps = MapAreaStore(Future.value(Directory('${root.path}/maps')));
      temp = Directory('${root.path}/tmp')..createSync();
      reminders = FakeReminderNotifications();
      secureCleared = 0;
    });
    tearDown(() => root.deleteSync(recursive: true));

    DeviceDataWiper wiper({List<MediaFileStore>? stores}) => DeviceDataWiper(
      db: db,
      fileStores: stores ?? [media],
      mapAreas: maps,
      reminders: reminders,
      clearSecureStorage: () async => secureCleared++,
      temporaryDirectory: () async => temp,
    );

    test('DB, outbox, dosyalar, haritalar ve anahtarlar silinir', () async {
      await insertOrganizationRow(db);
      await seedCountedRecords(db);
      expect(await db.select(db.outbox).get(), isNotEmpty);
      await media.write('foto.jpg', [1, 2, 3]);
      await media.write('ses.m4a', [4]);
      Directory('${root.path}/maps').createSync();
      File('${root.path}/maps/area.mbtiles').writeAsBytesSync([1]);
      File('${temp.path}/export.json').writeAsStringSync('{}');
      reminders.groups['tasks'] = {};

      await wiper().wipe();

      for (final table in db.allTables) {
        expect(
          await db.customSelect('SELECT * FROM ${table.actualTableName}').get(),
          isEmpty,
          reason: table.actualTableName,
        );
      }
      expect(Directory('${root.path}/media').listSync(), isEmpty);
      expect(Directory('${root.path}/maps').listSync(), isEmpty);
      expect(temp.listSync(), isEmpty);
      expect(reminders.groups, isEmpty);
      expect(secureCleared, 1);
    });

    test('bir adım başarısız olsa da diğerleri silinir', () async {
      await seedCountedRecords(db);
      final broken = MediaFileStore(
        Future<Directory>.error(const FileSystemException('kilitli'))..ignore(),
      );

      await expectLater(
        wiper(stores: [broken, media]).wipe(),
        throwsA(isA<FileSystemException>()),
      );
      expect(await db.select(db.apiaries).get(), isEmpty);
      expect(secureCleared, 1);
    });

    test('hiç açılmamış klasörler sorun çıkarmaz', () async {
      await wiper().wipe();
      expect(secureCleared, 1);
    });
  });
}
