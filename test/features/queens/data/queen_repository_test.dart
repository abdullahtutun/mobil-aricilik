import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart' show SqliteException;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/queens/data/queen_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late QueenRepository repository;
  late HiveRepository hives;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = QueenRepository(db, clock: clock.call);
    hives = HiveRepository(db, clock: clock.call);
  });

  Future<Hive> createHive({String? queenId}) => hives.create(
    orgId: 'org-1',
    number: '101',
    type: HiveType.langstroth,
    apiaryId: 'apiary-1',
    queenId: queenId,
  );

  test('varsayılanlar: kanadı kesik değil, diğer alanlar boş', () async {
    final queen = await repository.create(orgId: 'org-1');

    expect(queen.wingClipped, isFalse);
    expect(queen.year, isNull);
    expect(queen.markColor, isNull);
    expect(queen.matingStatus, isNull);
    expect(await repository.findById(queen.id), queen);
  });

  test('enumlar sunucu değeriyle saklanır ve gönderilir', () async {
    final mother = await repository.create(orgId: 'org-1');
    final queen = await repository.create(
      orgId: 'org-1',
      year: 2026,
      markColor: QueenMarkColor.blue,
      breed: 'Kafkas',
      breedLine: 'Artvin',
      source: QueenSource.ownRearing,
      matingStatus: QueenMatingStatus.mated,
      wingClipped: true,
      motherQueenId: mother.id,
    );

    expect(await repository.findById(queen.id), queen);
    final raw = await db
        .customSelect(
          'SELECT mark_color, source, mating_status, wing_clipped '
          'FROM queens WHERE id = ?',
          variables: [Variable(queen.id)],
        )
        .getSingle();
    expect(raw.data, {
      'mark_color': 'blue',
      'source': 'own_rearing',
      'mating_status': 'mated',
      'wing_clipped': 1,
    });

    final payload = (await readOutbox(db)).last.payload;
    expect(payload, containsPair('mark_color', 'blue'));
    expect(payload, containsPair('source', 'own_rearing'));
    expect(payload, containsPair('mother_queen_id', mother.id));
    expect(payload, containsPair('wing_clipped', true));
  });

  test('watchAll işletmeye göre süzer, kayıt sırasıyla', () async {
    final first = await repository.create(orgId: 'org-1', year: 2025);
    clock.advance(const Duration(seconds: 1));
    final second = await repository.create(orgId: 'org-1', year: 2024);
    await repository.create(orgId: 'org-2');

    expect(await repository.watchAll('org-1').first, [first, second]);
  });

  test('güncelleme: işaret rengi temizlenebilir', () async {
    final queen = await repository.create(
      orgId: 'org-1',
      markColor: QueenMarkColor.white,
    );

    final updated = await repository.update(queen.copyWith(markColor: null));

    expect(updated.markColor, isNull);
    expect((await readOutbox(db)).last.payload['mark_color'], isNull);
  });

  group('giveToHive', () {
    test("anayı oluşturur ve kovana verir; ikisi outbox'a", () async {
      final hive = await createHive();
      final before = (await readOutbox(db)).length;
      clock.advance(const Duration(minutes: 1));

      final given = await repository.giveToHive(
        hive.id,
        year: 2026,
        markColor: QueenMarkColor.white,
        breed: 'Kafkas',
        source: QueenSource.ownRearing,
      );

      expect(given.previousQueenId, isNull);
      expect(given.queen.orgId, 'org-1');
      expect(given.queen.breed, 'Kafkas');
      expect((await hives.findById(hive.id))!.queenId, given.queen.id);
      final added = (await readOutbox(db)).skip(before).toList();
      expect(
        [for (final entry in added) entry.recordTable],
        ['queens', 'hives'],
      );
      expect(added.last.payload, containsPair('queen_id', given.queen.id));
    });

    test('eski ana kovandan çıkar, kaydı kalır', () async {
      final old = await repository.create(orgId: 'org-1', year: 2023);
      final hive = await createHive(queenId: old.id);

      final given = await repository.giveToHive(hive.id, year: 2026);

      expect(given.previousQueenId, old.id);
      expect((await hives.findById(hive.id))!.queenId, given.queen.id);
      expect(await repository.findById(old.id), old);
    });

    test('kovan yoksa StateError, ana yazılmaz', () async {
      await expectLater(
        repository.giveToHive('yok', year: 2026),
        throwsStateError,
      );
      expect(await db.select(db.queens).get(), isEmpty);
      expect(await readOutbox(db), isEmpty);
    });

    test('kovan yazılamazsa ana da yazılmaz', () async {
      final hive = await createHive();
      final before = (await readOutbox(db)).length;
      await db.customStatement(
        'CREATE TRIGGER hives_fails BEFORE UPDATE ON hives '
        "BEGIN SELECT RAISE(ABORT, 'hives kapalı'); END",
      );

      await expectLater(
        repository.giveToHive(hive.id, year: 2026),
        throwsA(isA<SqliteException>()),
      );
      expect(await db.select(db.queens).get(), isEmpty);
      expect(await readOutbox(db), hasLength(before));
    });
  });

  group('undoGive', () {
    test('kovan eski anasına döner, yeni ana yumuşak silinir', () async {
      final old = await repository.create(orgId: 'org-1', year: 2023);
      final hive = await createHive(queenId: old.id);
      final given = await repository.giveToHive(hive.id, year: 2026);

      expect(await repository.undoGive(given), isTrue);

      expect((await hives.findById(hive.id))!.queenId, old.id);
      expect(await repository.findById(given.queen.id), isNull);
      expect((await readOutbox(db)).last.operation, OutboxOperation.delete);
    });

    test('kovanın anası bu arada değiştiyse bir şey yazmaz', () async {
      final hive = await createHive();
      final first = await repository.giveToHive(hive.id, year: 2025);
      final second = await repository.giveToHive(hive.id, year: 2026);
      final before = (await readOutbox(db)).length;

      expect(await repository.undoGive(first), isFalse);

      expect((await hives.findById(hive.id))!.queenId, second.queen.id);
      expect(await repository.findById(first.queen.id), isNotNull);
      expect(await readOutbox(db), hasLength(before));
    });
  });
}
