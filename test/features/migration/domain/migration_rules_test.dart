import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/migration_rules.dart';

final _at = DateTime.utc(2026, 10, 28);

MigrationStop _stop(
  String id, {
  int position = 1,
  MigrationStopStatus status = MigrationStopStatus.planned,
  DateTime? start,
}) => MigrationStop(
  id: id,
  orgId: 'org-1',
  migrationId: 'migration-1',
  position: position,
  name: id,
  plannedStartOn: start ?? DateTime(2026, 3),
  plannedEndOn: DateTime(2026, 12),
  status: status,
  createdAt: _at,
  updatedAt: _at,
);

VaultDocument _document(String id, DocumentType type, DateTime? expiresOn) =>
    VaultDocument(
      id: id,
      orgId: 'org-1',
      type: type,
      name: id,
      fileKind: DocumentFileKind.photo,
      storagePath: 'org-1/$id/file.jpg',
      byteSize: 1,
      expiresOn: expiresOn,
      createdAt: _at,
      updatedAt: _at,
    );

void main() {
  group('sortStops', () {
    test('sıra, aynı sırada başlangıç, sonra kimlik', () {
      final stops = sortStops([
        _stop('c', position: 2),
        _stop('b', start: DateTime(2026, 5)),
        _stop('a', start: DateTime(2026, 5)),
        _stop('d', start: DateTime(2026, 4)),
      ]);
      expect(stops.map((s) => s.id), ['d', 'a', 'b', 'c']);
    });
  });

  group('nextMove', () {
    const past = MigrationStopStatus.past;
    const current = MigrationStopStatus.current;

    test('şu anki duraktan sonraki ilk planlı durağa', () {
      final stops = [
        _stop('narenciye', status: past),
        _stop('yayla', position: 2),
        _stop('cam', position: 3, status: current),
        _stop('kislak', position: 4),
        _stop('sonra', position: 5),
      ];
      final move = nextMove(stops)!;
      expect(move.from?.id, 'cam');
      expect(move.to.id, 'kislak');
    });

    test('şu an durak yoksa son geçmiş duraktan ilk planlıya', () {
      final stops = [
        _stop('narenciye', status: past),
        _stop('yayla', position: 2, status: past),
        _stop('kestane', position: 3),
      ];
      final move = nextMove(stops)!;
      expect(move.from?.id, 'yayla');
      expect(move.to.id, 'kestane');
    });

    test('ilk taşımanın çıkış durağı yok', () {
      final move = nextMove([_stop('narenciye'), _stop('yayla', position: 2)]);
      expect(move?.from, isNull);
      expect(move?.to.id, 'narenciye');
    });

    test('şu anki duraktan sonra planlı durak yoksa taşıma yok', () {
      expect(nextMove([]), isNull);
      expect(
        nextMove([_stop('yayla'), _stop('cam', position: 2, status: current)]),
        isNull,
      );
    });
  });

  group('migrationDocumentStatuses', () {
    final now = DateTime(2026, 10, 28, 15);
    final moveOn = DateTime(2026, 11, 9);

    List<MigrationDocumentStatus> statuses(List<VaultDocument> documents) =>
        migrationDocumentStatuses(documents, moveOn: moveOn, now: now);

    test('üç tür sırayla; kasada yoksa eksik', () {
      expect(statuses([]), [
        (
          type: DocumentType.transportPermit,
          level: MigrationDocumentLevel.missing,
          daysLeft: null,
        ),
        (
          type: DocumentType.healthReport,
          level: MigrationDocumentLevel.missing,
          daysLeft: null,
        ),
        (
          type: DocumentType.migratoryCertificate,
          level: MigrationDocumentLevel.missing,
          daysLeft: null,
        ),
      ]);
    });

    test('taşıma günü geçerli ya da süresiz hazır; 7 günden azsa kalan gün; '
        'taşımadan önce bitiyor; süresi doldu', () {
      final result = statuses([
        _document('nakil', DocumentType.transportPermit, DateTime(2027, 5)),
        _document('saglik', DocumentType.healthReport, DateTime(2026, 11, 2)),
        _document('gezginci', DocumentType.migratoryCertificate, null),
      ]);
      expect(result.map((s) => (s.level, s.daysLeft)), [
        (MigrationDocumentLevel.ready, 185),
        (MigrationDocumentLevel.expiringSoon, 5),
        (MigrationDocumentLevel.ready, null),
      ]);

      expect(
        statuses([
          _document('saglik', DocumentType.healthReport, DateTime(2026, 11, 8)),
        ])[1].level,
        MigrationDocumentLevel.expiresBeforeMove,
      );
      expect(
        statuses([
          _document('saglik', DocumentType.healthReport, DateTime(2026, 11, 9)),
        ])[1].level,
        MigrationDocumentLevel.ready,
      );
      expect(
        statuses([
          _document(
            'saglik',
            DocumentType.healthReport,
            DateTime(2026, 10, 27),
          ),
        ])[1].level,
        MigrationDocumentLevel.expired,
      );
    });

    test('aynı türde en uzun geçerli belge, süresiz en iyisi; diğer türler '
        'sayılmaz', () {
      final result = statuses([
        _document('eski', DocumentType.healthReport, DateTime(2026, 10)),
        _document('yeni', DocumentType.healthReport, DateTime(2027)),
        _document('tescil', DocumentType.businessRegistration, null),
        _document('kısa', DocumentType.transportPermit, DateTime(2026, 10, 30)),
        _document('süresiz', DocumentType.transportPermit, null),
      ]);
      expect(result[0].level, MigrationDocumentLevel.ready);
      expect(result[0].daysLeft, isNull);
      expect(result[1].level, MigrationDocumentLevel.ready);
      expect(result[2].level, MigrationDocumentLevel.missing);
    });
  });

  group('yieldsByApiary', () {
    ApiaryHarvestEntry entry(
      String apiaryId,
      int year,
      double netKg,
      int hiveCount,
    ) => (
      apiaryId: apiaryId,
      harvestedAt: DateTime(year, 7, 15),
      netKg: netKg,
      hiveCount: hiveCount,
    );

    test('yıl içindeki bal, hasada alınan kovanların toplamına bölünür; '
        'plan yılı ve sonrası sayılmaz; yeni yıl önce, en çok 3 yıl', () {
      final yields = yieldsByApiary([
        entry('cam', 2025, 2000, 100),
        entry('cam', 2025, 600, 0),
        entry('cam', 2025, 1900, 50),
        entry('cam', 2024, 2200, 100),
        entry('cam', 2023, 1500, 100),
        entry('cam', 2022, 1000, 100),
        entry('cam', 2026, 3000, 100),
        entry('yayla', 2024, 450, 30),
      ], beforeYear: 2026);

      expect(yields['cam'], [
        (year: 2025, kgPerHive: 26.0),
        (year: 2024, kgPerHive: 22.0),
        (year: 2023, kgPerHive: 15.0),
      ]);
      expect(yields['yayla'], [(year: 2024, kgPerHive: 15.0)]);
      expect(yields['kestane'], isNull);
    });
  });

  test('shortPlace yerin ilk parçasını verir', () {
    expect(shortPlace('Ula, Muğla'), 'Ula');
    expect(shortPlace(' Köyceğiz '), 'Köyceğiz');
  });
}
