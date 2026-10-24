import 'package:drift/drift.dart' show Variable;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/queens/data/queen_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late QueenRepository repository;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = QueenRepository(db, clock: clock.call);
  });

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
}
