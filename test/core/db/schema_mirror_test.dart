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

/// Sunucunun şema dökümü (`server/schema/collections.json`, P2.8):
/// `server_seq` alanı olan, yani senkronlanan koleksiyonların alan adları ve
/// select alanlarının değerleri (`koleksiyon.alan` anahtarıyla); yalnız
/// sunucudaki koleksiyonların select alanları ayrıca.
({
  Map<String, Set<String>> collections,
  Map<String, List<String>> selects,
  Map<String, List<String>> unsyncedSelects,
})
_serverSchema() {
  final dump = jsonDecode(
    File('server/schema/collections.json').readAsStringSync(),
  ) as List<dynamic>;
  final collections = <String, Set<String>>{};
  final selects = <String, List<String>>{};
  final unsyncedSelects = <String, List<String>>{};
  for (final collection in dump.cast<Map<String, dynamic>>()) {
    final name = collection['name'] as String;
    final fields = (collection['fields'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final synced = fields.any((field) => field['name'] == 'server_seq');
    if (synced) {
      collections[name] = {for (final field in fields) field['name'] as String};
    }
    for (final field in fields.where((field) => field['type'] == 'select')) {
      (synced ? selects : unsyncedSelects)['$name.${field['name']}'] =
          (field['values'] as List<dynamic>).cast<String>();
    }
  }
  return (
    collections: collections,
    selects: selects,
    unsyncedSelects: unsyncedSelects,
  );
}

void main() {
  final server = _serverSchema();

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

  group('sunucu dökümü', () {
    test('döküm ayrıştırması koleksiyonları ve select alanlarını buluyor', () {
      expect(
        server.collections['hives'],
        containsAll(['id', 'org_id', 'number', 'server_seq']),
      );
      expect(server.selects['queens.source'], [
        'own_rearing',
        'purchased',
        'certified_breeder',
      ]);
      // Senkronlanmayan koleksiyonlar (`server_seq`'siz) aynalanmaz.
      expect(server.collections, isNot(contains('weather_cache')));
    });

    test('senkron koleksiyonlarının alanları Drift tablolarında', () {
      // Konum sunucuda da enlem + boylam; dönüşüm yok.
      expect(localSyncedTables(), server.collections);
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

      expect(local, server.selects);
    });

    test('görüş türü Dart enumuyla aynı (yalnız sunucuda, senkronlanmaz)', () {
      expect(server.unsyncedSelects['feedback.kind'], [
        for (final e in FeedbackKind.values) e.value,
      ]);
    });
  });
}
