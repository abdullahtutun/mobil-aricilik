import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

import '../../helpers/test_database.dart';

/// `supabase/migrations` içindeki tablo kolonları, enum değerleri ve
/// `sync_push`'un kabul ettiği şema sürümleri.
({
  Map<String, Set<String>> tables,
  Map<String, List<String>> enums,
  List<int> supportedVersions,
})
_serverSchema() {
  final files =
      Directory('supabase/migrations')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.sql'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final tables = <String, Set<String>>{};
  final enums = <String, List<String>>{};
  var supportedVersions = <int>[];
  const notColumns = {'unique', 'foreign', 'check', 'constraint', 'primary'};

  for (final file in files) {
    final sql = file.readAsStringSync();
    for (final match in RegExp(
      r'create table public\.(\w+) \((.*?)\n\);',
      dotAll: true,
    ).allMatches(sql)) {
      tables[match[1]!] = {
        for (final line in match[2]!.split('\n'))
          if (RegExp(r'^\s+([a-z_]+)\s').firstMatch(line) case final column?
              when !notColumns.contains(column[1]))
            column[1]!,
      };
    }
    for (final match in RegExp(
      r'alter table public\.(\w+)\s+add column (\w+)',
    ).allMatches(sql)) {
      tables[match[1]]!.add(match[2]!);
    }
    for (final match in RegExp(
      r'create type public\.(\w+) as enum \(([^)]*)\)',
    ).allMatches(sql)) {
      enums[match[1]!] = [
        for (final value in RegExp(r"'(\w+)'").allMatches(match[2]!)) value[1]!,
      ];
    }
    // Fonksiyon `create or replace` ile yenilenir; son migration geçerli.
    for (final match in RegExp(
      r'supported_versions constant integer\[\] := array\[([^\]]*)\]',
    ).allMatches(sql)) {
      supportedVersions = [
        for (final value in RegExp(r'\d+').allMatches(match[1]!))
          int.parse(value[0]!),
      ];
    }
  }
  return (tables: tables, enums: enums, supportedVersions: supportedVersions);
}

void main() {
  final server = _serverSchema();

  test('migration ayrıştırması tabloları ve enumları buluyor', () {
    expect(server.tables['hives'], containsAll(['id', 'org_id', 'number']));
    expect(server.enums['queen_source'], [
      'own_rearing',
      'purchased',
      'certified_breeder',
    ]);
  });

  test('senkronlanan tablolar sunucudaki kolonların aynası', () {
    final db = openTestDatabase();
    // Yalnız bu telefondaki tablolar (outbox, taslaklar) `server_seq`
    // taşımaz.
    final local = {
      for (final table in db.allTables)
        if (table.$columns.any((column) => column.name == 'server_seq'))
          table.actualTableName: {
            for (final column in table.$columns) column.name,
          },
    };

    // PostGIS noktası yerelde iki kolon.
    final expected = {
      for (final MapEntry(key: table, value: columns) in server.tables.entries)
        table: {
          for (final column in columns)
            if (column == 'location') ...['latitude', 'longitude'] else column,
        },
    };

    expect(local, expected);
  });

  test('Dart enumları sunucu enumlarıyla aynı değerleri aynı sırada taşır', () {
    List<String> values(List<ServerEnum> values) => [
      for (final e in values) e.value,
    ];
    final local = {
      'membership_role': values(MembershipRole.values),
      'apiary_land_tenure': values(LandTenure.values),
      'hive_type': values(HiveType.values),
      'hive_status': values(HiveStatus.values),
      'hive_source': values(HiveSource.values),
      // Dart adları sunucu değerleriyle aynı.
      'queen_mark_color': [for (final e in QueenMarkColor.values) e.name],
      'queen_source': values(QueenSource.values),
      'queen_mating_status': values(QueenMatingStatus.values),
      'hive_count_range': values(HiveCountRange.values),
      'inspection_queen_state': values(QueenState.values),
      'inspection_temperament': values(Temperament.values),
      'inspection_queen_cells': values(QueenCells.values),
      'media_kind': values(MediaKind.values),
      'mite_count_method': values(MiteCountMethod.values),
      'drug_active_ingredient': values(DrugActiveIngredient.values),
      'drug_dose_unit': values(DrugDoseUnit.values),
    };

    expect(local, server.enums);
  });

  test('sync_push Drift şema sürümünü kabul eder', () {
    // Sürüm sunucunun listesinde yoksa her gönderim PT426 alır ve güncel
    // uygulama güncelleme ister.
    final db = openTestDatabase();

    expect(server.supportedVersions, contains(db.schemaVersion));
  });
}
