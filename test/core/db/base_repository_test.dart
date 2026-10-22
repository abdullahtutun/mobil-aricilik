import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';

import '../../helpers/test_database.dart';

// Ortak davranış ApiaryRepository üzerinden sınanır.
void main() {
  const orgId = 'org-1';
  late AppDatabase db;
  late TestClock clock;
  late ApiaryRepository repository;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = ApiaryRepository(db, clock: clock.call);
  });

  Future<List<Apiary>> allRows() => db.select(db.apiaries).get();

  /// Outbox'a yazmayı SQL düzeyinde engeller.
  Future<void> breakOutbox() => db.customStatement(
    'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
    "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
  );

  group('ekleme', () {
    test('satırı ve outbox kaydını birlikte yazar', () async {
      final apiary = await repository.create(
        orgId: orgId,
        name: 'Yayla',
        latitude: 40.1,
        longitude: 29.5,
        landTenure: LandTenure.rented,
      );

      expect(await allRows(), [apiary]);
      expect(apiary.createdAt, clock.current);
      expect(apiary.updatedAt, clock.current);
      expect(apiary.id, matches(RegExp('^[0-9a-f-]{14}7')));

      final outbox = await readOutbox(db);
      expect(outbox, hasLength(1));
      expect(outbox.single.recordTable, 'apiaries');
      expect(outbox.single.recordId, apiary.id);
      expect(outbox.single.operation, OutboxOperation.upsert);
      expect(outbox.single.createdAt, clock.current);
      expect(outbox.single.attempts, 0);
    });

    test('payload sunucu kolon adlarıyla tam satır; server_seq yok', () async {
      final apiary = await repository.create(
        orgId: orgId,
        name: 'Yayla',
        vehicleDistanceM: 300,
        landTenure: LandTenure.rented,
      );

      final payload = (await readOutbox(db)).single.payload;
      expect(payload, apiary.toJson());
      expect(payload, containsPair('org_id', orgId));
      expect(payload, containsPair('vehicle_distance_m', 300));
      expect(payload, containsPair('land_tenure', 'rented'));
      expect(payload, containsPair('created_at', '2026-10-22T09:00:00.000Z'));
      expect(payload, containsPair('deleted_at', null));
      expect(payload.keys, isNot(contains('server_seq')));
    });

    test('outbox yazılamazsa satır da yazılmaz', () async {
      await breakOutbox();

      await expectLater(
        repository.create(orgId: orgId, name: 'Yayla'),
        throwsA(isA<SqliteException>()),
      );
      expect(await allRows(), isEmpty);
    });

    test('yerel saat UTC olarak, ISO-8601 metin halinde saklanır', () async {
      clock.current = DateTime(2026, 10, 22, 12, 30, 0, 5, 7);
      final apiary = await repository.create(orgId: orgId, name: 'Yayla');

      expect(apiary.createdAt.isUtc, isTrue);
      expect(apiary.createdAt, clock.current.toUtc());
      final raw = await db
          .customSelect('SELECT created_at FROM apiaries')
          .getSingle();
      expect(raw.read<String>('created_at'), endsWith('.005007Z'));
    });
  });

  group('güncelleme', () {
    test('updated_at ilerler, created_at kalır; ikinci upsert', () async {
      final created = await repository.create(orgId: orgId, name: 'Yayla');
      clock.advance(const Duration(minutes: 5));

      final updated = await repository.update(
        created.copyWith(name: 'Yayla üstü', notes: 'Yol çamur'),
      );

      expect(updated.name, 'Yayla üstü');
      expect(updated.notes, 'Yol çamur');
      expect(updated.createdAt, created.createdAt);
      expect(updated.updatedAt, clock.current);
      expect(await allRows(), [updated]);

      final outbox = await readOutbox(db);
      expect(outbox.map((e) => e.operation), [
        OutboxOperation.upsert,
        OutboxOperation.upsert,
      ]);
      expect(outbox.last.payload, updated.toJson());
    });

    test('kimlik, işletme ve sunucu alanları değişmez', () async {
      final created = await repository.create(orgId: orgId, name: 'Yayla');

      final updated = await repository.update(
        created.copyWith(
          orgId: 'org-2',
          createdAt: DateTime.utc(2020),
          createdBy: 'birisi',
          deletedAt: DateTime.utc(2026),
          serverSeq: 99,
        ),
      );

      expect(updated.orgId, orgId);
      expect(updated.createdAt, created.createdAt);
      expect(updated.createdBy, isNull);
      expect(updated.deletedAt, isNull);
      expect(updated.serverSeq, isNull);
    });

    test('olmayan ya da silinmiş kayıtta StateError, yazma yok', () async {
      final created = await repository.create(orgId: orgId, name: 'Yayla');
      await repository.delete(created.id);
      final deleted = (await allRows()).single;

      await expectLater(
        repository.update(created.copyWith(name: 'Yeni')),
        throwsStateError,
      );
      await expectLater(
        repository.update(created.copyWith(id: 'yok')),
        throwsStateError,
      );
      expect(await allRows(), [deleted]);
      expect((await readOutbox(db)).map((e) => e.operation), [
        OutboxOperation.upsert,
        OutboxOperation.delete,
      ]);
    });

    test('outbox yazılamazsa satır eski hâlinde kalır', () async {
      final created = await repository.create(orgId: orgId, name: 'Yayla');
      await breakOutbox();

      await expectLater(
        repository.update(created.copyWith(name: 'Yeni')),
        throwsA(isA<SqliteException>()),
      );
      expect(await allRows(), [created]);
    });
  });

  group('silme', () {
    test('yumuşak: satır kalır, deleted_at dolar, okumalardan düşer', () async {
      final created = await repository.create(orgId: orgId, name: 'Yayla');
      clock.advance(const Duration(hours: 1));

      await repository.delete(created.id);

      final row = (await allRows()).single;
      expect(row.deletedAt, clock.current);
      expect(row.updatedAt, clock.current);
      expect(await repository.findById(created.id), isNull);
      expect(await repository.watchById(created.id).first, isNull);
      expect(await repository.watchAll(orgId).first, isEmpty);

      final outbox = await readOutbox(db);
      expect(outbox.last.operation, OutboxOperation.delete);
      expect(outbox.last.recordId, created.id);
      expect(
        outbox.last.payload,
        containsPair('deleted_at', '2026-10-22T10:00:00.000Z'),
      );
      expect(outbox.last.payload, containsPair('name', 'Yayla'));
    });

    test('zaten silinmiş ya da olmayan kayıtta bir şey yazmaz', () async {
      final created = await repository.create(orgId: orgId, name: 'Yayla');
      await repository.delete(created.id);
      final deletedAt = (await allRows()).single.deletedAt;
      clock.advance(const Duration(hours: 1));

      await repository.delete(created.id);
      await repository.delete('yok');

      expect((await allRows()).single.deletedAt, deletedAt);
      expect(await readOutbox(db), hasLength(2));
    });

    test('outbox yazılamazsa kayıt silinmez', () async {
      final created = await repository.create(orgId: orgId, name: 'Yayla');
      await breakOutbox();

      await expectLater(
        repository.delete(created.id),
        throwsA(isA<SqliteException>()),
      );
      expect(await repository.findById(created.id), created);
    });
  });

  group('okuma', () {
    test('liste Stream: ekleme, güncelleme ve silmede yeniden yayar', () async {
      final emitted = <List<Apiary>>[];
      final subscription = repository.watchAll(orgId).listen(emitted.add);
      addTearDown(subscription.cancel);

      await pumpEventQueue();
      expect(emitted.last, isEmpty);

      final a = await repository.create(orgId: orgId, name: 'A');
      await pumpEventQueue();
      expect(emitted.last, [a]);

      final b = await repository.update(a.copyWith(name: 'B'));
      await pumpEventQueue();
      expect(emitted.last, [b]);

      await repository.delete(a.id);
      await pumpEventQueue();
      expect(emitted.last, isEmpty);
    });

    test('tek kayıt Stream değişikliği izler', () async {
      final created = await repository.create(orgId: orgId, name: 'Yayla');
      final emitted = <Apiary?>[];
      final subscription = repository.watchById(created.id).listen(emitted.add);
      addTearDown(subscription.cancel);

      await pumpEventQueue();
      final updated = await repository.update(created.copyWith(name: 'Ova'));
      await pumpEventQueue();
      await repository.delete(created.id);
      await pumpEventQueue();

      expect(emitted, [created, updated, null]);
    });
  });
}
