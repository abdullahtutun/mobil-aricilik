import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

import '../../helpers/test_database.dart';

/// `supabase/migrations` içindeki tablo kolonları ve enum değerleri.
({Map<String, Set<String>> tables, Map<String, List<String>> enums})
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
  }
  return (tables: tables, enums: enums);
}

void main() {
  final server = _serverSchema();

  test('migration ayrıştırması tabloları ve enumları buluyor', () {
    expect(server.tables, hasLength(6));
    expect(server.tables['hives'], containsAll(['id', 'org_id', 'number']));
    expect(server.enums['queen_source'], [
      'own_rearing',
      'purchased',
      'certified_breeder',
    ]);
  });

  test('senkronlanan tablolar sunucudaki kolonların aynası', () {
    final db = openTestDatabase();
    final local = {
      for (final table in db.allTables)
        if (table.actualTableName != 'outbox' &&
            table.actualTableName != 'sync_state')
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
    };

    expect(local, server.enums);
  });
}
