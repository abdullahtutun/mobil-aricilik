import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';
import 'package:mobil_arici/features/reports/domain/season_rules.dart';
import 'package:mobil_arici/features/reports/presentation/widgets/season_labels.dart';

final _at = DateTime(2024);

Hive _hive(String id, String number) => Hive(
  id: id,
  orgId: 'org',
  number: number,
  type: HiveType.langstroth,
  apiaryId: 'a1',
  createdAt: _at,
  updatedAt: _at,
);

void main() {
  final tr = lookupAppLocalizations(const Locale('tr'));

  setUpAll(initializeDateFormatting);

  SeasonReport report() => seasonReport(
    (
      hives: [_hive('h1', '101'), _hive('h2', '102')],
      events: [
        HiveStatusEvent(
          id: 'e1',
          orgId: 'org',
          hiveId: 'h2',
          apiaryId: 'a1',
          fromStatus: HiveStatus.active,
          toStatus: HiveStatus.dead,
          changedAt: DateTime(2026, 2, 10, 9),
          lossReason: HiveLossReason.wintering,
          createdAt: _at,
          updatedAt: _at,
        ),
      ],
      locations: const [],
      queens: const [],
      harvests: const [],
      treatments: const [],
    ),
    year: 2026,
    hemisphere: Hemisphere.northern,
    now: DateTime(2026, 11, 2),
  );

  test('mücadele yöntemi etken maddelerle; boşsa İlaçlanmadı', () {
    expect(treatmentMethodLabel(tr, const {}), 'İlaçlanmadı');
    expect(
      treatmentMethodLabel(tr, const {
        DrugActiveIngredient.oxalicAcid,
        DrugActiveIngredient.amitraz,
      }),
      startsWith('Amitraz + '),
    );
  });

  test('CSV: başlık, kovan başına satır ve altta özet', () {
    final rows = seasonCsvRows(
      report(),
      l10n: tr,
      apiaryNames: const {'a1': 'Çamlık'},
    );

    expect(rows.first.first, 'Kovan');
    expect(rows[1], [
      '101',
      'Çamlık',
      'Aktif',
      'Aktif',
      '',
      '',
      'Evet',
      'Hayır',
      'Çamlık',
      'İlaçlanmadı',
      '',
    ]);
    expect(rows[2].sublist(0, 6), [
      '102',
      'Çamlık',
      'Aktif',
      'Söndü',
      '2026-02-10',
      'Kışlama',
    ]);
    expect(rows[3], isEmpty);
    expect(rows.last, ['Kış kaybı', '%50']);
  });

  test('az kovanlı grubun alt yazısında az veri', () {
    expect(winterGroupHives(tr, (hives: 4, lost: 1)), '4 kovan · az veri');
    expect(winterGroupHives(tr, (hives: 12, lost: 1)), '12 kovan');
  });
}
