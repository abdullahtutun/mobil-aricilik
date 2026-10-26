import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/data/tour_repository.dart';
import 'package:mobil_arici/features/inspections/domain/apiary_tour.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TourRepository repository;

  final tour = ApiaryTour(
    orgId: 'org-1',
    apiaryId: 'apiary-1',
    startedAt: DateTime.utc(2026, 10, 26, 9),
    hiveIds: const ['h1', 'h2', 'h3'],
    inspections: const {'h1': 'i1'},
    skipped: const ['h2'],
  );

  setUp(() {
    db = openTestDatabase();
    repository = TourRepository(db);
  });

  test('tur yazılır, okunur ve silinir; outbox’a gitmez', () async {
    expect(await repository.readTour(), isNull);

    await repository.saveTour(tour);
    expect(await repository.readTour(), tour);

    final finished = tour.copyWith(finishedAt: DateTime.utc(2026, 10, 26, 10));
    await repository.saveTour(finished);
    expect(await repository.readTour(), finished);
    expect(await readOutbox(db), isEmpty);

    await repository.clearTour();
    expect(await repository.readTour(), isNull);
  });

  test('akış turun değişikliklerini yayar', () async {
    final seen = <ApiaryTour?>[];
    final subscription = repository.watchTour().listen(seen.add);
    await pumpEventQueue();

    await repository.saveTour(tour);
    await pumpEventQueue();
    await repository.clearTour();
    await pumpEventQueue();
    await subscription.cancel();

    expect(seen, [null, tour, null]);
  });

  test('okunamayan tur yok sayılır', () async {
    await db
        .into(db.localSettings)
        .insert(
          LocalSettingsCompanion.insert(
            key: TourRepository.tourKey,
            value: '{"apiaryId": 1}',
          ),
        );

    expect(await repository.readTour(), isNull);
  });

  test('turun muayeneleri kimlikle izlenir; silinen düşer', () async {
    final inspections = InspectionRepository(db);
    Future<Inspection> inspect(String hiveId) => inspections.add(
      orgId: 'org-1',
      hiveId: hiveId,
      apiaryId: 'apiary-1',
      values: const InspectionValues(beeFrames: 5),
    );
    final a = await inspect('h1');
    final b = await inspect('h2');
    await inspect('h3');
    await inspections.delete(b.id);

    final watched = await inspections.watchByIds([a.id, b.id]).first;

    expect([for (final i in watched) i.id], [a.id]);
  });
}
