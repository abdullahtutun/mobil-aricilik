import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

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
      r'alter table public\.(\w+)\s+drop column (\w+)',
    ).allMatches(sql)) {
      tables[match[1]]!.remove(match[2]);
    }
    for (final match in RegExp(
      r'create type public\.(\w+) as enum \(([^)]*)\)',
    ).allMatches(sql)) {
      enums[match[1]!] = [
        for (final value in RegExp(r"'(\w+)'").allMatches(match[2]!)) value[1]!,
      ];
    }
    // Sonradan eklenen enum değeri sona eklenir.
    for (final match in RegExp(
      r"alter type public\.(\w+) add value '(\w+)'",
    ).allMatches(sql)) {
      enums[match[1]]!.add(match[2]!);
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

/// PocketBase şema dökümü (`server/schema/collections.json`, P2.8):
/// `server_seq` alanı olan, yani senkronlanan koleksiyonların alan adları ve
/// select alanlarının değerleri (`koleksiyon.alan` anahtarıyla).
({Map<String, Set<String>> collections, Map<String, List<String>> selects})
_pocketBaseSchema() {
  final dump = jsonDecode(
    File('server/schema/collections.json').readAsStringSync(),
  ) as List<dynamic>;
  final collections = <String, Set<String>>{};
  final selects = <String, List<String>>{};
  for (final collection in dump.cast<Map<String, dynamic>>()) {
    final name = collection['name'] as String;
    final fields = (collection['fields'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    if (!fields.any((field) => field['name'] == 'server_seq')) continue;
    collections[name] = {for (final field in fields) field['name'] as String};
    for (final field in fields.where((field) => field['type'] == 'select')) {
      selects['$name.${field['name']}'] = (field['values'] as List<dynamic>)
          .cast<String>();
    }
  }
  return (collections: collections, selects: selects);
}

void main() {
  final server = _serverSchema();
  final pocketBase = _pocketBaseSchema();

  /// Bu telefondaki senkron tabloları ve kolonları. Yalnız bu telefondaki
  /// tablolar (outbox, taslaklar) `server_seq` taşımaz.
  Map<String, Set<String>> localSyncedTables() {
    final db = openTestDatabase();
    return {
      for (final table in db.allTables)
        if (table.$columns.any((column) => column.name == 'server_seq'))
          table.actualTableName: {
            for (final column in table.$columns) column.name,
          },
    };
  }

  test('migration ayrıştırması tabloları ve enumları buluyor', () {
    expect(server.tables['hives'], containsAll(['id', 'org_id', 'number']));
    expect(server.enums['queen_source'], [
      'own_rearing',
      'purchased',
      'certified_breeder',
    ]);
  });

  test('senkronlanan tablolar sunucudaki kolonların aynası', () {
    final local = localSyncedTables();

    // PostGIS noktası yerelde iki kolon. Yalnız sunucudaki tablolar
    // (`weather_cache`) da `server_seq` taşımaz ve aynalanmaz.
    final expected = {
      for (final MapEntry(key: table, value: columns) in server.tables.entries)
        if (columns.contains('server_seq'))
          table: {
            for (final column in columns)
              if (column == 'location') ...[
                'latitude',
                'longitude',
              ] else
                column,
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
      'feeding_kind': values(FeedingKind.values),
      'task_source': values(TaskSource.values),
      'honey_kind': values(HoneyKind.values),
      'harvest_unit': values(HarvestUnit.values),
      'withdrawal_override_reason': values(WithdrawalOverrideReason.values),
      'feedback_kind': values(FeedbackKind.values),
      'document_type': values(DocumentType.values),
      'document_file_kind': values(DocumentFileKind.values),
      'migration_stop_status': values(MigrationStopStatus.values),
      'transport_status': values(TransportStatus.values),
      'inventory_category': values(InventoryCategory.values),
      'inventory_unit': values(InventoryUnit.values),
      'inventory_move_kind': values(InventoryMoveKind.values),
      'mating_nuc_status': values(MatingNucStatus.values),
      'lot_status': values(LotStatus.values),
      'residue_result': values(ResidueResult.values),
      'transaction_kind': values(TransactionKind.values),
      'transaction_category': values(TransactionCategory.values),
      'hive_loss_reason': values(HiveLossReason.values),
      'operation_type': values(OperationType.values),
      'org_avatar_color': values(OrgAvatarColor.values),
    };

    expect(local, server.enums);
  });

  group('PocketBase dökümü', () {
    test('döküm ayrıştırması koleksiyonları ve select alanlarını buluyor', () {
      expect(
        pocketBase.collections['hives'],
        containsAll(['id', 'org_id', 'number', 'server_seq']),
      );
      expect(pocketBase.selects['queens.source'], [
        'own_rearing',
        'purchased',
        'certified_breeder',
      ]);
      // Senkronlanmayan koleksiyonlar (`server_seq`'siz) aynalanmaz.
      expect(pocketBase.collections, isNot(contains('weather_cache')));
    });

    test('senkron koleksiyonlarının alanları Drift tablolarında', () {
      // Konum PocketBase'de de enlem + boylam; dönüşüm yok.
      expect(localSyncedTables(), pocketBase.collections);
    });

    test('select değerleri Dart enumlarıyla aynı, aynı sırada', () {
      List<String> values(List<ServerEnum> values) => [
        for (final e in values) e.value,
      ];
      final hiveStatus = values(HiveStatus.values);
      final activeIngredient = values(DrugActiveIngredient.values);
      final doseUnit = values(DrugDoseUnit.values);
      final honeyKind = values(HoneyKind.values);
      final local = {
        'apiaries.land_tenure': values(LandTenure.values),
        'documents.type': values(DocumentType.values),
        'documents.file_kind': values(DocumentFileKind.values),
        'drugs.active_ingredient': activeIngredient,
        'drugs.dose_unit': doseUnit,
        'feedings.kind': values(FeedingKind.values),
        'harvest_hives.withdrawal_override_reason': values(
          WithdrawalOverrideReason.values,
        ),
        'harvests.honey_kind': honeyKind,
        'harvests.unit': values(HarvestUnit.values),
        'hive_status_events.from_status': hiveStatus,
        'hive_status_events.to_status': hiveStatus,
        'hive_status_events.loss_reason': values(HiveLossReason.values),
        'hives.type': values(HiveType.values),
        'hives.status': hiveStatus,
        'hives.source': values(HiveSource.values),
        'inspections.queen_state': values(QueenState.values),
        'inspections.temperament': values(Temperament.values),
        'inspections.queen_cells': values(QueenCells.values),
        'inventory_items.category': values(InventoryCategory.values),
        'inventory_items.unit': values(InventoryUnit.values),
        'inventory_moves.kind': values(InventoryMoveKind.values),
        'lab_results.residue': values(ResidueResult.values),
        'lots.honey_kind': honeyKind,
        'lots.status': values(LotStatus.values),
        'mating_nucs.status': values(MatingNucStatus.values),
        'media.kind': values(MediaKind.values),
        'memberships.role': values(MembershipRole.values),
        'migration_stops.status': values(MigrationStopStatus.values),
        'mite_counts.method': values(MiteCountMethod.values),
        'organizations.hive_count_range': values(HiveCountRange.values),
        'organizations.operation_type': values(OperationType.values),
        'organizations.avatar_color': values(OrgAvatarColor.values),
        // Dart adları sunucu değerleriyle aynı.
        'queens.mark_color': [for (final e in QueenMarkColor.values) e.name],
        'queens.source': values(QueenSource.values),
        'queens.mating_status': values(QueenMatingStatus.values),
        'ref_drugs.active_ingredient': activeIngredient,
        'ref_drugs.dose_unit': doseUnit,
        'tasks.source': values(TaskSource.values),
        'transactions.kind': values(TransactionKind.values),
        'transactions.category': values(TransactionCategory.values),
        'transports.status': values(TransportStatus.values),
        'treatments.active_ingredient': activeIngredient,
        'treatments.dose_unit': doseUnit,
      };

      expect(local, pocketBase.selects);
    });
  });

  test('Supabase sync_push dondu: hiçbir sürüm kabul edilmez', () {
    // P10.1 (K-11): yazmalar PocketBase'e gider; Supabase'in sync_push'u
    // her sürüme PT426 döner. Drift sürümünün PocketBase listesinde olduğunu
    // server/internal/sync/versions_test.go denetler.
    expect(server.supportedVersions, isEmpty);
  });
}
