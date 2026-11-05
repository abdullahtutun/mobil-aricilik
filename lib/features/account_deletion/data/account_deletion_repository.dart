import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';

/// Hesap silmenin yerel DB işleri: silinecek kayıtların sayısı ve bütün
/// kayıtların tek dosyada dışa aktarımı. Yalnız okur, outbox'a yazmaz.
class AccountDeletionRepository {
  new(this.db, {this.clock = DateTime.now});

  final AppDatabase db;
  final DateTime Function() clock;

  /// Dışa aktarmaya girmeyen gelir/gider tabloları (owner ve partner
  /// dışında; `canExportFinance`).
  static const financeTables = {
    'transactions',
    'customers',
    'customer_payments',
    'lot_sales',
  };

  /// [orgId]'nin silinmemiş kayıt sayıları; kayıtlar değişince yeniden
  /// yayar. Sunucunun silme yanıtındaki sayılarla aynı ölçüler.
  Stream<DeletionCounts> watchCounts(String orgId) {
    String live(String table, [String extra = '']) =>
        '(SELECT COUNT(*) FROM $table WHERE org_id = ?1 '
        'AND deleted_at IS NULL$extra)';
    return db
        .customSelect(
          'SELECT ${live('hives')} AS hives, '
          '${live('apiaries')} AS apiaries, '
          '${live('inspections')} AS inspections, '
          '${live('harvests')} AS harvests, '
          '${live('documents')} AS documents, '
          "${live('media', " AND kind = 'photo'")} AS photos, "
          '${live('lots', ' AND published = 1')} AS lots',
          variables: [Variable.withString(orgId)],
          readsFrom: {
            db.hives,
            db.apiaries,
            db.inspections,
            db.harvests,
            db.documents,
            db.media,
            db.lots,
          },
        )
        .watchSingle()
        .map(
          (row) => (
            hives: row.read<int>('hives'),
            apiaries: row.read<int>('apiaries'),
            inspections: row.read<int>('inspections'),
            harvests: row.read<int>('harvests'),
            documents: row.read<int>('documents'),
            photos: row.read<int>('photos'),
            publicLotPages: row.read<int>('lots'),
          ),
        );
  }

  /// [orgId]'nin bütün kayıtları tek JSON dosyasında (UTF-8): işletme
  /// satırı ve `org_id`'li her senkronlanan tablonun silinmemiş satırları,
  /// sunucunun kolon adlarıyla. Tarihler ISO 8601. Kuyruklar (outbox,
  /// yüklemeler), taslaklar ve başvuru tabloları girmez; [includeFinance]
  /// yanlışsa gelir/gider de.
  Future<Uint8List> exportJson(String orgId, {required bool includeFinance}) =>
      db.transaction(() async {
        final tables = <String, List<Map<String, Object?>>>{};
        final organizations = db.organizations;
        tables[organizations.actualTableName] = await _rows(
          organizations,
          where: '${organizations.id.name} = ?1',
          orgId: orgId,
        );
        for (final table in db.allTables) {
          final name = table.actualTableName;
          final columns = table.columnsByName;
          if (!columns.containsKey('org_id') ||
              !columns.containsKey('server_seq') ||
              name.startsWith('ref_') ||
              (!includeFinance && financeTables.contains(name))) {
            continue;
          }
          tables[name] = await _rows(
            table,
            where: 'org_id = ?1 AND deleted_at IS NULL',
            orgId: orgId,
          );
        }
        final document = {
          'format': 'mobil-arici-export',
          'version': 1,
          'exported_at': clock().toUtc().toIso8601String(),
          'org_id': orgId,
          'tables': tables,
        };
        return utf8.encode(
          const JsonEncoder.withIndent('  ').convert(document),
        );
      });

  Future<List<Map<String, Object?>>> _rows(
    TableInfo<Table, Object?> table, {
    required String where,
    required String orgId,
  }) async {
    final rows = await db
        .customSelect(
          'SELECT * FROM ${table.actualTableName} WHERE $where',
          variables: [Variable.withString(orgId)],
          readsFrom: {table},
        )
        .get();
    return [
      for (final row in rows)
        {
          for (final column in table.$columns)
            if (column.name != 'server_seq')
              column.name: _json(
                db.typeMapping.read(column.type, row.data[column.name]),
              ),
        },
    ];
  }

  static Object? _json(Object? value) => switch (value) {
    final DateTime date => date.toUtc().toIso8601String(),
    final Uint8List bytes => base64Encode(bytes),
    final BigInt big => big.toString(),
    _ => value,
  };
}
