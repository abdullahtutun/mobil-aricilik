import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/hives/data/hive_location_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late HiveRepository repository;
  late HiveLocationRepository locations;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = HiveRepository(db, clock: clock.call);
    locations = HiveLocationRepository(db, clock: clock.call);
  });

  Future<Hive> createHive(
    String number, {
    String apiaryId = 'apiary-1',
    String orgId = 'org-1',
  }) => repository.create(
    orgId: orgId,
    number: number,
    type: HiveType.langstroth,
    apiaryId: apiaryId,
  );

  /// Silinmişler dahil tüm geçmiş kayıtları.
  Future<List<HiveLocationEntry>> allHistory() =>
      db.select(db.hiveLocationHistory).get();

  /// [table] tablosuna eklemeyi SQL düzeyinde engeller; [when] verilirse
  /// yalnız o koşulda.
  Future<void> breakInsert(String table, {String when = '1'}) =>
      db.customStatement(
        'CREATE TRIGGER ${table}_fails BEFORE INSERT ON $table '
        "WHEN $when BEGIN SELECT RAISE(ABORT, '$table kapalı'); END",
      );

  test('varsayılanlar sunucuyla aynı: etkin, tek kat', () async {
    final hive = await createHive('101');

    expect(hive.status, HiveStatus.active);
    expect(hive.boxCount, 1);
    final payload = (await readOutbox(db))
        .firstWhere((entry) => entry.recordTable == 'hives')
        .payload;
    expect(payload, containsPair('status', 'active'));
    expect(payload, containsPair('box_count', 1));
    expect(payload, containsPair('type', 'langstroth'));
  });

  test('tüm alanlar yazılıp aynen okunur', () async {
    final hive = await repository.create(
      orgId: 'org-1',
      number: 'A-12',
      type: HiveType.dadant,
      apiaryId: 'apiary-1',
      status: HiveStatus.dead,
      tagCode: 'NFC-0042',
      queenId: 'queen-1',
      boxCount: 2,
      frameCount: 18,
      source: HiveSource.package,
      marking: 'Mavi kapak',
    );

    expect(await repository.findById(hive.id), hive);
    final raw = await db
        .customSelect('SELECT type, status, source FROM hives')
        .getSingle();
    expect(raw.data, {'type': 'dadant', 'status': 'dead', 'source': 'package'});
  });

  group('oluşturma ve arılık geçmişi', () {
    test('ilk arılık aynı anda geçmişe yazılır', () async {
      final hive = await createHive('101');

      final entry = (await allHistory()).single;
      expect(entry.orgId, 'org-1');
      expect(entry.hiveId, hive.id);
      expect(entry.apiaryId, 'apiary-1');
      expect(entry.movedAt, hive.createdAt);
      expect(
        [for (final e in await readOutbox(db)) (e.recordTable, e.recordId)],
        [('hives', hive.id), ('hive_location_history', entry.id)],
      );
    });

    test('geçmiş yazılamazsa kovan da yazılmaz', () async {
      await breakInsert('hive_location_history');

      await expectLater(createHive('101'), throwsA(isA<SqliteException>()));

      expect(await db.select(db.hives).get(), isEmpty);
      expect(await readOutbox(db), isEmpty);
    });
  });

  group('toplu oluşturma', () {
    test('numara sırasıyla, aynı tip ve kaynakta aktif kovanlar', () async {
      final created = await repository.createMany(
        orgId: 'org-1',
        apiaryId: 'apiary-1',
        numbers: ['101', '102', '103'],
        type: HiveType.local,
        source: HiveSource.swarm,
      );

      expect(created.map((h) => h.number), ['101', '102', '103']);
      for (final hive in created) {
        expect(hive.type, HiveType.local);
        expect(hive.source, HiveSource.swarm);
        expect(hive.status, HiveStatus.active);
        expect(hive.apiaryId, 'apiary-1');
      }
      expect(await repository.watchByApiary('apiary-1').first, created);
      final history = await allHistory();
      expect(history.map((e) => e.hiveId), created.map((h) => h.id));
      expect(history.map((e) => e.apiaryId).toSet(), {'apiary-1'});
      expect(await readOutbox(db), hasLength(6));
    });

    test('biri yazılamazsa hiçbiri yazılmaz', () async {
      await breakInsert('hives', when: "NEW.number = '103'");

      await expectLater(
        repository.createMany(
          orgId: 'org-1',
          apiaryId: 'apiary-1',
          numbers: ['101', '102', '103', '104'],
          type: HiveType.langstroth,
        ),
        throwsA(isA<SqliteException>()),
      );

      expect(await db.select(db.hives).get(), isEmpty);
      expect(await allHistory(), isEmpty);
      expect(await readOutbox(db), isEmpty);
    });
  });

  group('taşıma', () {
    test('arılık değişir, geçmişe aynı anda yazılır', () async {
      final hive = await createHive('101');
      clock.advance(const Duration(days: 3));
      final outboxBefore = (await readOutbox(db)).length;

      final move = (await repository.move(hive.id, apiaryId: 'apiary-2'))!;

      expect(move.fromApiaryId, 'apiary-1');
      expect(move.hive.apiaryId, 'apiary-2');
      expect(move.hive.updatedAt, clock.current);
      expect(await repository.findById(hive.id), move.hive);
      expect(move.entry.apiaryId, 'apiary-2');
      expect(move.entry.movedAt, clock.current);
      final history = await locations.watchByHive(hive.id).first;
      expect(history.map((e) => e.apiaryId), ['apiary-2', 'apiary-1']);
      final added = (await readOutbox(db)).skip(outboxBefore);
      expect(
        [for (final e in added) (e.recordTable, e.operation)],
        [
          ('hives', OutboxOperation.upsert),
          ('hive_location_history', OutboxOperation.upsert),
        ],
      );
    });

    test('kovan zaten oradaysa bir şey yazılmaz', () async {
      final hive = await createHive('101');
      final outboxBefore = (await readOutbox(db)).length;

      expect(await repository.move(hive.id, apiaryId: 'apiary-1'), isNull);

      expect(await readOutbox(db), hasLength(outboxBefore));
      expect(await allHistory(), hasLength(1));
    });

    test('olmayan ya da silinmiş kovan taşınamaz', () async {
      final hive = await createHive('101');
      await repository.delete(hive.id);

      await expectLater(
        repository.move(hive.id, apiaryId: 'apiary-2'),
        throwsStateError,
      );
      await expectLater(
        repository.move('yok', apiaryId: 'apiary-2'),
        throwsStateError,
      );
    });

    test('geçmiş yazılamazsa kovan yerinde kalır', () async {
      final hive = await createHive('101');
      await breakInsert('hive_location_history');

      await expectLater(
        repository.move(hive.id, apiaryId: 'apiary-2'),
        throwsA(isA<SqliteException>()),
      );

      expect((await repository.findById(hive.id))!.apiaryId, 'apiary-1');
      expect(await readOutbox(db), hasLength(2));
    });

    test('geri al: kovan döner, taşıma kaydı silinir', () async {
      final hive = await createHive('101');
      final move = (await repository.move(hive.id, apiaryId: 'apiary-2'))!;
      clock.advance(const Duration(seconds: 4));

      expect(await repository.undoMove(move), isTrue);

      expect((await repository.findById(hive.id))!.apiaryId, 'apiary-1');
      final history = await locations.watchByHive(hive.id).first;
      expect(history.map((e) => e.apiaryId), ['apiary-1']);
      final removed = (await allHistory()).firstWhere(
        (e) => e.id == move.entry.id,
      );
      expect(removed.deletedAt, clock.current);
      final outbox = await readOutbox(db);
      expect(
        [for (final e in outbox.skip(4)) (e.recordTable, e.operation)],
        [
          ('hives', OutboxOperation.upsert),
          ('hive_location_history', OutboxOperation.delete),
        ],
      );
    });

    test('bu arada yeniden taşındıysa geri alma bir şey yazmaz', () async {
      final hive = await createHive('101');
      final first = (await repository.move(hive.id, apiaryId: 'apiary-2'))!;
      await repository.move(hive.id, apiaryId: 'apiary-3');
      final outboxBefore = (await readOutbox(db)).length;

      expect(await repository.undoMove(first), isFalse);

      expect((await repository.findById(hive.id))!.apiaryId, 'apiary-3');
      expect(await readOutbox(db), hasLength(outboxBefore));
    });
  });

  group('durum', () {
    test('en son hâlin üzerine yazılır', () async {
      final hive = await createHive('101');
      // Kart açıldıktan sonra başka yerden değişen alan korunmalı.
      await repository.update(hive.copyWith(marking: 'Mavi kapak'));
      clock.advance(const Duration(minutes: 1));

      final updated = await repository.setStatus(hive.id, HiveStatus.sold);

      expect(updated.status, HiveStatus.sold);
      expect(updated.marking, 'Mavi kapak');
      expect(updated.updatedAt, clock.current);
      expect(
        (await readOutbox(db)).last.payload,
        containsPair('status', 'sold'),
      );
    });

    test('olmayan kovanın durumu yazılamaz', () async {
      await expectLater(
        repository.setStatus('yok', HiveStatus.dead),
        throwsStateError,
      );
    });
  });

  group('etiket', () {
    test('etiket koduyla işletmenin silinmemiş kovanı bulunur', () async {
      final hive = await createHive('101');
      await repository.assignTag(hive.id, 'TAG-1');
      final other = await createHive('7', orgId: 'org-2');
      await repository.assignTag(other.id, 'TAG-2');
      final removed = await createHive('9');
      await repository.assignTag(removed.id, 'TAG-3');
      await repository.delete(removed.id);

      expect(
        await repository.findByTagCode(orgId: 'org-1', tagCode: 'TAG-1'),
        isA<Hive>().having((h) => h.id, 'id', hive.id),
      );
      expect(
        await repository.findByTagCode(orgId: 'org-1', tagCode: 'TAG-2'),
        isNull,
      );
      expect(
        await repository.findByTagCode(orgId: 'org-1', tagCode: 'TAG-3'),
        isNull,
      );
      expect(
        await repository.findByTagCode(orgId: 'org-1', tagCode: 'tag-1'),
        isNull,
      );
    });

    test("atama en son hâlin üzerine yazılır ve outbox'a gider", () async {
      final hive = await createHive('101');
      await repository.update(hive.copyWith(marking: 'Mavi kapak'));
      clock.advance(const Duration(minutes: 1));

      final assigned = await repository.assignTag(hive.id, 'TAG-1');

      expect(assigned.tagCode, 'TAG-1');
      expect(assigned.marking, 'Mavi kapak');
      expect(assigned.updatedAt, clock.current);
      expect(
        (await readOutbox(db)).last.payload,
        containsPair('tag_code', 'TAG-1'),
      );
    });

    test(
      'başka kovandaki etiket ondan alınır; öbür işletmeye dokunulmaz',
      () async {
        final first = await createHive('101');
        final second = await createHive('102');
        final foreign = await createHive('101', orgId: 'org-2');
        await repository.assignTag(first.id, 'TAG-1');
        await repository.assignTag(foreign.id, 'TAG-1');

        await repository.assignTag(second.id, 'TAG-1');

        expect((await repository.findById(first.id))!.tagCode, isNull);
        expect((await repository.findById(second.id))!.tagCode, 'TAG-1');
        expect((await repository.findById(foreign.id))!.tagCode, 'TAG-1');
        final outbox = await readOutbox(db);
        expect(
          [for (final e in outbox.skip(outbox.length - 2)) e.recordId],
          [first.id, second.id],
        );
      },
    );

    test('kovan zaten bu etiketteyse bir şey yazılmaz', () async {
      final hive = await createHive('101');
      await repository.assignTag(hive.id, 'TAG-1');
      final outboxBefore = (await readOutbox(db)).length;

      await repository.assignTag(hive.id, 'TAG-1');

      expect(await readOutbox(db), hasLength(outboxBefore));
    });

    test('kovanın kaydı yazılamazsa öbür kovan etiketini korur', () async {
      final first = await createHive('101');
      final second = await createHive('102');
      await repository.assignTag(first.id, 'TAG-1');
      await breakInsert('outbox', when: "NEW.record_id = '${second.id}'");

      await expectLater(
        repository.assignTag(second.id, 'TAG-1'),
        throwsA(isA<SqliteException>()),
      );

      expect((await repository.findById(first.id))!.tagCode, 'TAG-1');
      expect((await repository.findById(second.id))!.tagCode, isNull);
    });

    test('olmayan ya da silinmiş kovana etiket atanamaz', () async {
      final removed = await createHive('101');
      await repository.delete(removed.id);

      for (final id in ['yok', removed.id]) {
        await expectLater(repository.assignTag(id, 'TAG-1'), throwsStateError);
      }
    });
  });

  test('watchByApiary yalnız o arılığın silinmemiş kovanları', () async {
    final a = await createHive('102');
    final b = await createHive('101');
    final removed = await createHive('103');
    await createHive('201', apiaryId: 'apiary-2');
    await repository.delete(removed.id);

    expect(await repository.watchByApiary('apiary-1').first, [b, a]);
  });

  test('kovan başka arılığa geçince iki liste de güncellenir', () async {
    final hive = await createHive('101');
    final first = <List<Hive>>[];
    final second = <List<Hive>>[];
    final subscriptions = [
      repository.watchByApiary('apiary-1').listen(first.add),
      repository.watchByApiary('apiary-2').listen(second.add),
    ];
    addTearDown(() => Future.wait(subscriptions.map((s) => s.cancel())));
    await pumpEventQueue();

    final moved = (await repository.move(hive.id, apiaryId: 'apiary-2'))!;
    await pumpEventQueue();

    expect(first.last, isEmpty);
    expect(second.last, [moved.hive]);
  });

  test('watchAll işletmeye göre süzer', () async {
    final hive = await createHive('101');
    await createHive('101', orgId: 'org-2');

    expect(await repository.watchAll('org-1').first, [hive]);
  });
}
