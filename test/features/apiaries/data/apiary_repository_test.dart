import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ApiaryRepository repository;

  setUp(() {
    db = openTestDatabase();
    repository = ApiaryRepository(db, clock: TestClock().call);
  });

  test('watchAll yalnız işletmenin silinmemiş arılıkları, ada göre', () async {
    final yayla = await repository.create(orgId: 'org-1', name: 'Yayla');
    final cam = await repository.create(orgId: 'org-1', name: 'Çamlık');
    final ova = await repository.create(orgId: 'org-1', name: 'Ova');
    await repository.create(orgId: 'org-2', name: 'Başkası');
    await repository.delete(ova.id);

    // Ada göre SQLite sırası; Türkçe sıralama ekranda yapılacak.
    expect(await repository.watchAll('org-1').first, [yayla, cam]);
  });

  test('tüm alanlar yazılıp aynen okunur', () async {
    final created = await repository.create(
      orgId: 'org-1',
      name: 'Yayla',
      latitude: 40.123456,
      longitude: 29.654321,
      altitudeM: 1250,
      landownerName: 'Ahmet',
      landownerPhone: '+905551112233',
      landTenure: LandTenure.permitted,
      waterSource: 'Çeşme',
      vehicleDistanceM: 300,
      roadNotes: 'Son 2 km toprak',
      notes: 'Rüzgârlı',
    );

    expect(await repository.findById(created.id), created);
    final raw = await db
        .customSelect('SELECT land_tenure FROM apiaries')
        .getSingle();
    expect(raw.read<String>('land_tenure'), 'permitted');
  });

  test('konumun yalnız bir yarısı yazılamaz', () async {
    await expectLater(
      repository.create(orgId: 'org-1', name: 'Yayla', latitude: 40),
      throwsA(isA<SqliteException>()),
    );
    expect(await readOutbox(db), isEmpty);
  });
}
