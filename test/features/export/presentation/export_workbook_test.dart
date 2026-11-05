import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/xlsx.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/export/domain/export_data.dart';
import 'package:mobil_arici/features/export/presentation/export_workbook.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

void main() {
  final tr = lookupAppLocalizations(const Locale('tr'));
  final en = lookupAppLocalizations(const Locale('en'));
  final at = DateTime.utc(2026, 11, 5, 9);

  Apiary apiary(String id, String name) =>
      Apiary(id: id, orgId: 'o', name: name, createdAt: at, updatedAt: at);

  Hive hive(
    String id,
    String number,
    String apiaryId, {
    HiveStatus status = HiveStatus.active,
    String? queenId,
  }) => Hive(
    id: id,
    orgId: 'o',
    number: number,
    type: HiveType.langstroth,
    apiaryId: apiaryId,
    status: status,
    queenId: queenId,
    createdAt: at,
    updatedAt: at,
  );

  final data = ExportData(
    apiaries: [apiary('a2', 'Yayla'), apiary('a1', 'Ova')],
    hives: [
      hive('h10', '10', 'a1'),
      hive('h2', '2', 'a1', queenId: 'q1'),
      hive('h3', '3', 'a2', status: HiveStatus.dead),
    ],
    queens: [
      Queen(
        id: 'q1',
        orgId: 'o',
        year: 2025,
        markColor: QueenMarkColor.green,
        wingClipped: true,
        createdAt: at,
        updatedAt: at,
      ),
    ],
    inspections: [
      for (final (id, day) in [('i1', 1), ('i2', 4)])
        Inspection(
          id: id,
          orgId: 'o',
          hiveId: 'h2',
          apiaryId: 'a1',
          inspectedAt: DateTime.utc(2026, 11, day, 9),
          swarmSigns: false,
          diseaseSuspected: true,
          data: {
            'actions': [
              InspectionAction.values.first.value,
              InspectionAction.values.last.value,
            ],
          },
          createdAt: at,
          updatedAt: at,
        ),
    ],
    feedings: [
      Feeding(
        id: 'f1',
        orgId: 'o',
        hiveId: 'h2',
        apiaryId: 'a1',
        feedingGroupId: 'g',
        fedAt: at,
        kind: FeedingKind.syrup1to1,
        amount: 2.5,
        createdAt: at,
        updatedAt: at,
      ),
    ],
    treatments: const [],
    miteCounts: const [],
    harvests: const [],
    harvestHiveCounts: const {},
    tasks: [
      Task(
        id: 't1',
        orgId: 'o',
        title: 'Kek al',
        dueAt: at,
        createdAt: at,
        updatedAt: at,
      ),
      Task(
        id: 't2',
        orgId: 'o',
        source: TaskSource.inspection,
        hiveId: 'h2',
        apiaryId: 'a1',
        dueAt: at.subtract(const Duration(days: 1)),
        createdAt: at,
        updatedAt: at,
      ),
    ],
    inventory: const [],
    transactions: [
      FinanceTransaction(
        id: 'x1',
        orgId: 'o',
        kind: TransactionKind.income,
        category: TransactionCategory.values.first,
        amount: 1500,
        currency: 'TRY',
        occurredOn: DateTime.utc(2026, 11, 4),
        createdAt: at,
        updatedAt: at,
      ),
    ],
  );

  XlsxSheet sheet(List<XlsxSheet> sheets, String name) =>
      sheets.singleWhere((sheet) => sheet.name == name);

  test('sayfalar arayüz dilinde; finans yetkisi yoksa gelir/gider yok', () {
    expect(exportSheets(data, tr).map((s) => s.name), [
      'Arılıklar',
      'Kovanlar',
      'Ana arılar',
      'Muayeneler',
      'Beslemeler',
      'İlaçlamalar',
      'Varroa ölçümleri',
      'Hasatlar',
      'Görevler',
      'Stok',
      'Gelir ve gider',
    ]);
    expect(
      exportSheets(data.copyWith(transactions: null), en).map((s) => s.name),
      isNot(contains('Income and expenses')),
    );
  });

  test('arılıklar ada göre, aktif kovan sayısıyla', () {
    final rows = sheet(exportSheets(data, tr), 'Arılıklar').rows;
    expect(rows.first.take(2), ['Ad', 'Aktif kovan']);
    expect([for (final row in rows.skip(1)) row.take(2).toList()], [
      ['Ova', 2],
      ['Yayla', 0],
    ]);
  });

  test('kovanlar arılık ve doğal numara sırasıyla; kimlik yerine ad, '
      'durum ve ana çevrilmiş', () {
    final rows = sheet(exportSheets(data, tr), 'Kovanlar').rows.skip(1);
    expect([for (final row in rows) row.take(2).toList()], [
      ['Ova', 2],
      ['Ova', 10],
      ['Yayla', 3],
    ]);
    final first = rows.first;
    expect(first[3], 'Aktif');
    expect(first[10], '2025 · Yeşil');
    expect(rows.last[3], 'Söndü');
  });

  test('ana arı bulunduğu kovanla; evet/hayır çevrilir', () {
    final row = sheet(exportSheets(data, tr), 'Ana arılar').rows[1];
    expect(row.take(4), ['Ova', 2, 2025, 'Yeşil']);
    expect(row[7], 'Evet');
  });

  test('muayeneler yeniden eskiye; yapılanlar virgülle', () {
    final rows = sheet(exportSheets(data, tr), 'Muayeneler').rows.skip(1);
    expect(rows.map((row) => row.first), [
      DateTime.utc(2026, 11, 4, 9),
      DateTime.utc(2026, 11, 1, 9),
    ]);
    expect(rows.first[8], 'Hayır');
    expect(rows.first[10], 'Evet');
    expect(rows.first[11], contains(', '));
  });

  test('şurup litre', () {
    final row = sheet(exportSheets(data, en), 'Feedings').rows[1];
    expect(row.sublist(4), [2.5, 'L']);
  });

  test('görev başlığı: elle açılanda yazılan, otomatikte üretilen', () {
    final rows = sheet(exportSheets(data, tr), 'Görevler').rows.skip(1);
    expect(rows.map((row) => row[1]), [
      'Kek al',
      tr.taskInspectionTitle('2'),
    ]);
  });

  test('gelir/gider yalnız gün, türü çevrilmiş', () {
    final row = sheet(exportSheets(data, tr), 'Gelir ve gider').rows[1];
    expect(row.first, isA<XlsxDate>());
    expect(row.sublist(1, 2), ['Gelir']);
    expect(row.sublist(3, 5), [1500, 'TRY']);
  });

  test('çalışma kitabı dosyaya yazılabilir', () {
    expect(encodeXlsx(exportSheets(data, tr)), isNotEmpty);
  });
}
