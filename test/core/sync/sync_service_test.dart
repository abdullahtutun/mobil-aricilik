import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/feeding/data/feeding_repository.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/finance/data/customer_repository.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/health/data/drug_repository.dart';
import 'package:mobil_arici/features/health/data/mite_count_repository.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/hives/data/hive_location_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inventory/data/inventory_repository.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/media/data/media_repository.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/data/transport_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/queens/data/queen_rearing_repository.dart';
import 'package:mobil_arici/features/queens/data/queen_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/subsidies/data/support_period_repository.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/test_database.dart';

const _url = 'http://supabase.test';

typedef _Handler = FutureOr<http.Response> Function(http.Request request);

http.Response _json(Object? body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

/// PostgREST'in hata gövdesi; [code] SQLSTATE ya da `PGRST...`.
http.Response _postgrestError(String code, int status) => _json({
  'code': code,
  'message': '$code hatası',
  'details': null,
  'hint': null,
}, status);

/// İstekteki outbox kimlikleri, gönderim sırasıyla.
List<int> _ids(http.Request request) => [
  for (final change
      in (jsonDecode(request.body) as Map<String, dynamic>)['changes']
          as List<dynamic>)
    (change as Map<String, dynamic>)['id'] as int,
];

http.Response _results(List<Map<String, Object?>> results) => _json({
  'results': results,
  'server_time': '2026-10-23T09:00:01Z',
  'warning': null,
});

/// Sahte sync_push: [rejected]'daki kimlikleri o nedenle reddeder, gerisini
/// kabul eder.
http.Response _accept(
  http.Request request, {
  Map<int, String> rejected = const {},
}) => _results([
  for (final id in _ids(request))
    if (rejected[id] case final reason?)
      {
        'id': id,
        'status': 'rejected',
        'reason': reason,
        'message': '$reason mesajı',
      }
    else
      {'id': id, 'status': 'ok', 'applied': true},
]);

List<Duration> _seconds(List<int> values) => [
  for (final value in values) Duration(seconds: value),
];

List<int> _range(int first, int last) => [
  for (var id = first; id <= last; id++) id,
];

typedef _Rows = List<Map<String, Object?>>;

const _org = 'org-1';

/// Sunucu satırlarının ortak alanları, sync_pull'un döndüğü biçimde.
Map<String, Object?> _standard(
  String id,
  int seq, {
  String? deletedAt,
  String updatedAt = '2026-10-23T08:00:00.123456+00:00',
}) => {
  'id': id,
  'created_at': '2026-10-23T07:00:00+00:00',
  'updated_at': updatedAt,
  'created_by': 'user-1',
  'deleted_at': deletedAt,
  'server_seq': seq,
};

Map<String, Object?> _organizationRow(int seq) => {
  ..._standard(_org, seq),
  'name': 'Petek Arıcılık',
  'country_code': 'TR',
  'currency': 'TRY',
  'tr_registration_no': null,
  'tr_aks_no': null,
  'hive_count_range': 'up_to_50',
  'tr_aks_hive_count': 120,
};

Map<String, Object?> _membershipRow(int seq) => {
  ..._standard('membership-1', seq),
  'org_id': _org,
  'user_id': 'user-1',
  'role': 'owner',
};

/// Konum sync_pull'daki gibi latitude + longitude.
Map<String, Object?> _apiaryRow(
  String id,
  int seq, {
  String? name = 'Yayla',
  String? deletedAt,
}) => {
  ..._standard(id, seq, deletedAt: deletedAt),
  'org_id': _org,
  'name': name,
  'latitude': 38.41,
  'longitude': 27.14,
  'altitude_m': 1200,
  'landowner_name': null,
  'landowner_phone': null,
  'land_tenure': 'rented',
  'water_source': null,
  'vehicle_distance_m': null,
  'road_notes': null,
  'notes': null,
};

Map<String, Object?> _queenRow(int seq) => {
  ..._standard('queen-1', seq),
  'org_id': _org,
  'year': 2026,
  'mark_color': 'yellow',
  'breed': 'Kafkas',
  'breed_line': null,
  'source': 'own_rearing',
  'mating_status': 'mated',
  'wing_clipped': true,
  'mother_queen_id': null,
};

Map<String, Object?> _hiveRow(
  String id,
  int seq, {
  String type = 'langstroth',
}) => {
  ..._standard(id, seq),
  'org_id': _org,
  'number': '101',
  'tag_code': null,
  'type': type,
  'status': 'active',
  'apiary_id': 'apiary-1',
  'queen_id': 'queen-1',
  'box_count': 2,
  'frame_count': 10,
  'source': 'swarm',
  'marking': null,
};

Map<String, Object?> _moveRow(int seq) => {
  ..._standard('move-1', seq),
  'org_id': _org,
  'hive_id': 'hive-1',
  'apiary_id': 'apiary-1',
  'moved_at': '2026-10-23T06:30:00+00:00',
};

Map<String, Object?> _statusEventRow(int seq) => {
  ..._standard('status-event-1', seq),
  'org_id': _org,
  'hive_id': 'hive-1',
  'apiary_id': 'apiary-1',
  'from_status': 'active',
  'to_status': 'dead',
  'changed_at': '2027-02-10T09:00:00+00:00',
  'loss_reason': 'wintering',
};

Map<String, Object?> _inspectionRow(int seq) => {
  ..._standard('inspection-1', seq),
  'org_id': _org,
  'hive_id': 'hive-1',
  'apiary_id': 'apiary-1',
  'inspected_at': '2026-10-23T07:15:00+00:00',
  'queen_state': 'eggs',
  'bee_frames': 8,
  'brood_frames': 5,
  'honey_frames': null,
  'temperament': 'nervous',
  'swarm_signs': true,
  'queen_cells': 'swarm',
  'disease_suspected': false,
  // jsonb nesne olarak gelir; bu sürümün tanımadığı anahtar korunur.
  'data': {
    'actions': ['super_added', 'fed', 'new_action'],
    'later_field': 1,
  },
};

Map<String, Object?> _mediaRow(int seq) => {
  ..._standard('media-1', seq),
  'org_id': _org,
  'hive_id': 'hive-1',
  'inspection_id': 'inspection-1',
  'kind': 'audio',
  'storage_path': '$_org/hive-1/media-1.m4a',
  'captured_at': '2026-10-23T07:16:00+00:00',
  'byte_size': 48000,
  'duration_ms': 12000,
};

Map<String, Object?> _miteCountRow(int seq) => {
  ..._standard('mite-count-1', seq),
  'org_id': _org,
  'hive_id': 'hive-1',
  'apiary_id': 'apiary-1',
  'counted_at': '2026-10-23T07:20:00+00:00',
  'method': 'sticky_board',
  'mites': 30,
  'sample_bees': null,
  'days': 3,
};

Map<String, Object?> _refDrugRow(int seq) => {
  ..._standard('ref-drug-1', seq),
  'country_code': 'TR',
  'name_tr': 'Amitraz şerit',
  'name_en': 'Amitraz strip',
  'active_ingredient': 'amitraz',
  'dose_unit': 'strip',
  'withdrawal_days': null,
  'license_no': null,
};

Map<String, Object?> _drugRow(int seq) => {
  ..._standard('drug-1', seq),
  'org_id': _org,
  'name': 'Timol jel',
  'active_ingredient': 'thymol',
  'dose_unit': 'g',
  'withdrawal_days': 14,
  'license_no': null,
};

// Postgres numeric'i tam sayıysa JSON'da ondalıksız döner.
Map<String, Object?> _treatmentRow(int seq) => {
  ..._standard('treatment-1', seq),
  'org_id': _org,
  'hive_id': 'hive-1',
  'apiary_id': 'apiary-1',
  'ref_drug_id': 'ref-drug-1',
  'drug_id': null,
  'application_id': 'application-1',
  'product_name': 'Amitraz şerit',
  'active_ingredient': 'amitraz',
  'batch_no': '24-118',
  'dose': 2,
  'dose_unit': 'strip',
  'started_at': '2026-10-24T09:00:00+00:00',
  'planned_removal_at': '2026-12-05T09:00:00+00:00',
  'withdrawal_days': 0,
};

Map<String, Object?> _feedingRow(int seq) => {
  ..._standard('feeding-1', seq),
  'org_id': _org,
  'hive_id': 'hive-1',
  'apiary_id': 'apiary-1',
  'feeding_group_id': 'feeding-group-1',
  'fed_at': '2026-10-26T09:00:00+00:00',
  'kind': 'syrup_2_1',
  // Sunucunun numeric'i metin değil sayı olarak gelir.
  'amount': 3.785,
};

Map<String, Object?> _taskRow(int seq) => {
  ..._standard('task-1', seq),
  'org_id': _org,
  'title': null,
  'due_at': '2026-11-05T09:00:00+00:00',
  'apiary_id': 'apiary-1',
  'hive_id': 'hive-1',
  'assigned_to': 'user-1',
  'completed_at': null,
  'source': 'inspection',
  'source_id': 'inspection-1',
};

Map<String, Object?> _harvestRow(int seq) => {
  ..._standard('harvest-1', seq),
  'org_id': _org,
  'apiary_id': 'apiary-1',
  'harvested_at': '2026-10-26T09:00:00+00:00',
  'honey_kind': 'pine',
  'unit': 'super',
  'unit_count': 24,
  // Sunucunun numeric'i metin değil sayı olarak gelir.
  'net_kg': 574.5,
};

Map<String, Object?> _harvestHiveRow(int seq) => {
  ..._standard('harvest-hive-1', seq),
  'org_id': _org,
  'harvest_id': 'harvest-1',
  'hive_id': 'hive-1',
  'withdrawal_treatment_id': 'treatment-1',
  'withdrawal_override_reason': 'not_for_sale',
};

Map<String, Object?> _documentRow(int seq) => {
  ..._standard('document-1', seq),
  'org_id': _org,
  'type': 'transport_permit',
  'custom_type_name': null,
  'name': 'Nakil evrakı',
  'description': 'Ula → Köyceğiz',
  // Postgres `date`; saat dilimi yok.
  'expires_on': '2027-05-01',
  'file_kind': 'photo',
  'storage_path': '$_org/document-1/file-1.jpg',
  'byte_size': 2048,
};

Map<String, Object?> _migrationRow(int seq) => {
  ..._standard('migration-1', seq),
  'org_id': _org,
  'year': 2026,
  'name': 'Göç planı',
};

Map<String, Object?> _migrationStopRow(int seq) => {
  ..._standard('stop-1', seq),
  'org_id': _org,
  'migration_id': 'migration-1',
  'position': 4,
  'name': 'Çam',
  'place': 'Ula, Muğla',
  'planned_start_on': '2026-08-01',
  'planned_end_on': '2026-11-15',
  'apiary_id': 'apiary-1',
  'hive_count': 152,
  'status': 'current',
};

Map<String, Object?> _transportRow(int seq) => {
  ..._standard('transport-1', seq),
  'org_id': _org,
  'migration_stop_id': 'stop-1',
  'source_apiary_id': 'apiary-1',
  'destination_apiary_id': 'apiary-2',
  // `jsonb` dizisi.
  'vehicles': ['Kamyon 1', 'Kamyon 2'],
  'status': 'unloading',
  'completed_at': null,
};

Map<String, Object?> _transportItemRow(int seq) => {
  ..._standard('transport-item-1', seq),
  'org_id': _org,
  'transport_id': 'transport-1',
  'hive_id': 'hive-1',
  'vehicle': 'Kamyon 2',
  'loaded_at': '2026-11-15T18:05:00+00:00',
  'unloaded_at': null,
};

Map<String, Object?> _inventoryItemRow(int seq) => {
  ..._standard('inventory-item-1', seq),
  'org_id': _org,
  'name': 'Temel petek',
  'category': 'comb',
  'unit': 'piece',
  'place': 'depo',
  'threshold': 100,
};

Map<String, Object?> _inventoryMoveRow(int seq) => {
  ..._standard('inventory-move-1', seq),
  'org_id': _org,
  'item_id': 'inventory-item-1',
  'kind': 'out',
  'quantity': -12.5,
  'moved_at': '2026-11-15T18:05:00+00:00',
  'linked_table': 'feedings',
  'linked_id': 'feeding-1',
};

Map<String, Object?> _rearingBatchRow(int seq) => {
  ..._standard('rearing-batch-1', seq),
  'org_id': _org,
  'number': 3,
  'mother_queen_id': 'queen-1',
  'grafted_on': '2026-05-12',
  'grafted_count': 40,
  'accepted_count': 34,
};

Map<String, Object?> _matingNucRow(int seq) => {
  ..._standard('mating-nuc-1', seq),
  'org_id': _org,
  'number': '7',
  'apiary_id': 'apiary-1',
  'rearing_batch_id': 'rearing-batch-1',
  'status': 'laying',
  'queen_id': null,
};

Map<String, Object?> _lotRow(int seq) => {
  ..._standard('lot-1', seq),
  'org_id': _org,
  'year': 2026,
  'seq': 7,
  'honey_kind': 'pine',
  'origin': 'Kızılçam',
  'moisture': 17.2,
  'status': 'open',
};

Map<String, Object?> _lotHarvestRow(int seq) => {
  ..._standard('lot-harvest-1', seq),
  'org_id': _org,
  'lot_id': 'lot-1',
  'harvest_id': 'harvest-1',
};

Map<String, Object?> _lotTreatmentRow(int seq) => {
  ..._standard('lot-treatment-1', seq),
  'org_id': _org,
  'lot_id': 'lot-1',
  'harvest_id': 'harvest-1',
  'hive_id': 'hive-1',
  'treatment_id': 'treatment-1',
  'treated_at': '2026-09-01T09:00:00Z',
  'withdrawal_ends_on': '2026-11-10',
  'withdrawal_violation': true,
};

Map<String, Object?> _labResultRow(int seq) => {
  ..._standard('lab-result-1', seq),
  'org_id': _org,
  'lot_id': 'lot-1',
  'tested_on': '2026-10-28',
  'hmf': 12.4,
  'diastase': null,
  'proline': 420,
  'moisture': null,
  'residue': 'none',
  'document_id': null,
};

Map<String, Object?> _lotSaleRow(int seq) => {
  ..._standard('lot-sale-1', seq),
  'org_id': _org,
  'lot_id': 'lot-1',
  'sold_on': '2026-10-29',
  'kg': 100.5,
};

Map<String, Object?> _transactionRow(int seq) => {
  ..._standard('transaction-1', seq),
  'org_id': _org,
  'kind': 'income',
  'category': 'honey',
  'amount': 56000.5,
  'currency': 'TRY',
  'occurred_on': '2026-10-29',
  'description': 'Toptancıya çam balı',
  'receipt_path': null,
  'apiary_id': null,
  'lot_id': 'lot-1',
  'transport_id': null,
  'lot_sale_id': 'lot-sale-1',
  'customer_id': 'customer-1',
};

Map<String, Object?> _customerRow(int seq) => {
  ..._standard('customer-1', seq),
  'org_id': _org,
  'name': 'Ayşe Hanım',
  'phone': '+90 532 000 00 00',
  'address': 'Rize',
  'notes': null,
};

Map<String, Object?> _customerPaymentRow(int seq) => {
  ..._standard('customer-payment-1', seq),
  'org_id': _org,
  'transaction_id': 'transaction-1',
  'amount': 20000,
  'paid_on': '2026-10-30',
};

Map<String, Object?> _supportPeriodRow(int seq) => {
  ..._standard('support-period-1', seq),
  'name': 'Arıcılık desteği',
  'application_starts_on': '2027-01-15',
  'application_ends_on': '2027-02-15',
  'description': null,
  'source_url': 'https://www.tarimorman.gov.tr/',
};

bool _isPull(http.Request request) =>
    request.url.path == '/rest/v1/rpc/sync_pull';

/// Çekme isteğinin tablosu ve imleci.
({String table, int since}) _pullOf(http.Request request) {
  final body = jsonDecode(request.body) as Map<String, dynamic>;
  return (table: body['table_name'] as String, since: body['since_seq'] as int);
}

/// Sahte sunucu: sync_push'a her şeyi kabul eder; sync_pull'a [tables]'daki
/// satırlardan imleçten büyük olanları server_seq sırasıyla döner. Sayfa en
/// çok [maxPage] satır (sunucu istenenden az dönebilir); geriye bakma payı
/// yok.
_Handler _server(Map<String, _Rows> tables, {int maxPage = 1000}) => (request) {
  if (!_isPull(request)) return _accept(request);
  final body = jsonDecode(request.body) as Map<String, dynamic>;
  final (:table, :since) = _pullOf(request);
  final rows = [
    for (final row in tables[table] ?? const <Map<String, Object?>>[])
      if ((row['server_seq']! as int) > since) row,
  ];
  final page = rows.take(math.min(body['page_size'] as int, maxPage)).toList();
  return _json({
    'rows': page,
    'next_seq': page.isEmpty ? since : page.last['server_seq'],
    'has_more': rows.length > page.length,
  });
};

Future<Map<String, int>> _cursors(AppDatabase db) async => {
  for (final cursor in await db.select(db.syncState).get())
    cursor.recordTable: cursor.lastPulledSeq,
};

void main() {
  late AppDatabase db;
  late TestClock clock;
  late List<http.Request> requests;
  late _Handler handler;
  late List<Duration> delays;
  late SupabaseClient client;
  late SyncService service;

  /// Bir sonraki token isteğinde bir kez atılır.
  Exception? nextTokenError;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 10, 23, 9));
    requests = [];
    handler = _accept;
    delays = [];
    nextTokenError = null;
    client = SupabaseClient(
      _url,
      'anon-key',
      accessToken: () async {
        if (nextTokenError case final error?) {
          nextTokenError = null;
          throw error;
        }
        return 'user-token';
      },
      httpClient: MockClient((request) async {
        requests.add(request);
        final response = await handler(request);
        // postgrest yanıtı isteğiyle birlikte okur.
        return http.Response.bytes(
          response.bodyBytes,
          response.statusCode,
          headers: response.headers,
          request: request,
        );
      }),
    );
    addTearDown(client.dispose);
    service = SyncService(
      db,
      client,
      clock: clock.call,
      delay: (duration) async => delays.add(duration),
    );
  });

  /// Outbox'a [count] kovan kaydı ekler; kimlikler sırayla artar.
  Future<void> enqueue(int count) => db.batch(
    (batch) => batch.insertAll(db.outbox, [
      for (var i = 0; i < count; i++)
        OutboxCompanion.insert(
          recordTable: 'hives',
          recordId: 'hive-$i',
          operation: OutboxOperation.upsert,
          payload: {'id': 'hive-$i', 'updated_at': '2026-10-23T09:00:00Z'},
          createdAt: clock.current,
        ),
    ]),
  );

  group('gönderme', () {
    test('outbox boşsa istek atmaz', () async {
      expect(await service.push(), const SyncResult(status: SyncStatus.done));
      expect(requests, isEmpty);
    });

    test('kayıtları sync_push sözleşmesiyle gönderir', () async {
      final repository = ApiaryRepository(db, clock: clock.call);
      final apiary = await repository.create(orgId: 'org-1', name: 'Yayla');
      await repository.delete(apiary.id);
      final entries = await readOutbox(db);

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 2),
      );

      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, '/rest/v1/rpc/sync_push');
      expect(request.headers['Authorization'], 'Bearer user-token');
      expect(jsonDecode(request.body), {
        'changes': [
          {
            'id': entries[0].id,
            'table': 'apiaries',
            'operation': 'upsert',
            'payload': entries[0].payload,
          },
          {
            'id': entries[1].id,
            'table': 'apiaries',
            'operation': 'delete',
            'payload': entries[1].payload,
          },
        ],
        'client_time': '2026-10-23T09:00:00.000Z',
        'schema_version': db.schemaVersion,
      });
      expect(await readOutbox(db), isEmpty);
    });

    test('sırayla 100’lük paketler gönderir, kabul edilenleri siler', () async {
      await enqueue(250);

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 250),
      );
      expect(requests.map(_ids), [
        _range(1, 100),
        _range(101, 200),
        _range(201, 250),
      ]);
      expect(await readOutbox(db), isEmpty);
      expect(delays, isEmpty);
    });

    test('sunucuda aynı ya da daha yeni hâli olan kayıt da silinir', () async {
      await enqueue(2);
      handler = (request) => _results([
        for (final id in _ids(request))
          {'id': id, 'status': 'ok', 'applied': false},
      ]);

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 2),
      );
      expect(await readOutbox(db), isEmpty);
    });

    test('tur sürerken eklenen kayıt aynı turda, sırasıyla gider', () async {
      await enqueue(1);
      handler = (request) async {
        if (requests.length == 1) await enqueue(1);
        return _accept(request);
      };

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 2),
      );
      expect(requests.map(_ids), [
        [1],
        [2],
      ]);
    });
  });

  group('kalıcı ret', () {
    test(
      'reddedilen kaydı işaretler, kuyruğun geri kalanını gönderir',
      () async {
        await enqueue(150);
        handler = (request) =>
            _accept(request, rejected: {2: 'forbidden', 120: 'conflict'});

        expect(
          await service.push(),
          const SyncResult(status: SyncStatus.done, pushed: 148, rejected: 2),
        );
        expect(requests.map(_ids), [_range(1, 100), _range(101, 150)]);

        final left = await readOutbox(db);
        expect(left.map((entry) => entry.id), [2, 120]);
        expect(left.map((entry) => entry.lastError), [
          'forbidden: forbidden mesajı',
          'conflict: conflict mesajı',
        ]);
        expect(left.map((entry) => entry.attempts), [1, 1]);
        expect(delays, isEmpty);
      },
    );

    test('işaretli kayıt sonraki turlarda gönderilmez', () async {
      await enqueue(2);
      handler = (request) => _accept(request, rejected: {1: 'invalid'});
      await service.push();
      requests.clear();

      expect(await service.push(), const SyncResult(status: SyncStatus.done));
      expect(requests, isEmpty);

      await enqueue(1);
      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 1),
      );
      expect(requests.map(_ids), [
        [3],
      ]);
      expect((await readOutbox(db)).map((entry) => entry.id), [1]);
    });
  });

  group('geçici hata', () {
    test('aynı paketi üstel bekleyerek yeniden gönderir', () async {
      await enqueue(3);
      handler = (request) {
        if (requests.length <= 3) throw const SocketException('çevrimdışı');
        return _accept(request);
      };

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 3),
      );
      expect(delays, _seconds([1, 2, 4]));
      expect(requests.map(_ids), List.filled(4, [1, 2, 3]));
      expect(await readOutbox(db), isEmpty);
    });

    test('denemeler tükenince durur; kayıtlar yerinde, deneme sayısı '
        'artar', () async {
      await enqueue(150);
      handler = (_) => throw const SocketException('çevrimdışı');

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.retryLater),
      );
      expect(delays, _seconds([1, 2, 4, 8, 16]));
      expect(requests.map(_ids), List.filled(6, _range(1, 100)));

      final left = await readOutbox(db);
      expect(left, hasLength(150));
      expect(left.take(100).map((entry) => entry.attempts), everyElement(6));
      expect(left.skip(100).map((entry) => entry.attempts), everyElement(0));
      expect(left.map((entry) => entry.lastError), everyElement(isNull));
    });

    test('bekleme her başarılı paketten sonra baştan başlar', () async {
      await enqueue(150);
      final failedOnce = <int>{};
      handler = (request) {
        if (failedOnce.add(_ids(request).first)) {
          throw http.ClientException('bağlantı koptu');
        }
        return _accept(request);
      };

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 150),
      );
      expect(delays, _seconds([1, 1]));
    });

    final transientFailures = <String, _Handler>{
      'bağlantı hatası': (_) => throw http.ClientException('bağlantı koptu'),
      'istek zaman aşımı': (_) => throw TimeoutException('yanıt yok'),
      'kilitlenme (40P01)': (_) => _postgrestError('40P01', 500),
      'serileştirme hatası (40001)': (_) => _postgrestError('40001', 500),
      'sorgu zaman aşımı (57014)': (_) => _postgrestError('57014', 500),
      'kilit beklenemedi (55P03)': (_) => _postgrestError('55P03', 500),
      'veritabanına ulaşılamıyor (PGRST001)': (_) =>
          _postgrestError('PGRST001', 503),
      'JSON dönmeyen ağ geçidi (502)': (_) =>
          http.Response('<html>Bad Gateway</html>', 502),
      'çok sık istek (429)': (_) => _json({'message': 'Too many'}, 429),
    };
    for (final MapEntry(key: name, value: failure)
        in transientFailures.entries) {
      test('geçici sayılır: $name', () async {
        await enqueue(1);
        handler = (request) =>
            requests.length == 1 ? failure(request) : _accept(request);

        expect(
          await service.push(),
          const SyncResult(status: SyncStatus.done, pushed: 1),
        );
        expect(delays, _seconds([1]));
      });
    }

    test(
      'geçici sayılır: süresi dolmuş token çevrimdışı yenilenemedi',
      () async {
        await enqueue(1);
        nextTokenError = AuthRetryableFetchException(message: 'çevrimdışı');

        expect(
          await service.push(),
          const SyncResult(status: SyncStatus.done, pushed: 1),
        );
        expect(delays, _seconds([1]));
        expect(requests, hasLength(1));
      },
    );
  });

  group('yeniden denenmeyen hata', () {
    final fatalFailures = <String, _Handler>{
      'oturum yok (42501)': (_) => _postgrestError('42501', 401),
      'süresi dolmuş JWT (PGRST303)': (_) => _postgrestError('PGRST303', 401),
      'bozuk istek (22023)': (_) => _postgrestError('22023', 400),
      'fonksiyon yok (PGRST202)': (_) => _postgrestError('PGRST202', 404),
      'iç hata (XX000)': (_) => _postgrestError('XX000', 500),
    };
    for (final MapEntry(key: name, value: failure) in fatalFailures.entries) {
      test('turu bitirir: $name', () async {
        await enqueue(2);
        handler = failure;

        expect(
          await service.push(),
          const SyncResult(status: SyncStatus.failed),
        );
        expect(requests, hasLength(1));
        expect(delays, isEmpty);
        final left = await readOutbox(db);
        expect(left.map((entry) => entry.attempts), [1, 1]);
        expect(left.map((entry) => entry.lastError), everyElement(isNull));
      });
    }

    test('turu bitirir: refresh token reddedildi', () async {
      await enqueue(1);
      nextTokenError = const AuthException('Invalid Refresh Token');

      expect(await service.push(), const SyncResult(status: SyncStatus.failed));
      expect(requests, isEmpty);
      expect(delays, isEmpty);
    });

    test('desteklenmeyen şema sürümünde güncelleme ister', () async {
      await enqueue(1);
      handler = (_) => _postgrestError('PT426', 426);

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.upgradeRequired),
      );
      expect(requests, hasLength(1));
      expect(delays, isEmpty);
      expect((await readOutbox(db)).single.lastError, isNull);
    });

    test('yanıtta sonucu olmayan kayıt yerinde kalır ve tur durur', () async {
      await enqueue(150);
      handler = (request) => _results([
        for (final id in _ids(request).take(50))
          {'id': id, 'status': 'ok', 'applied': true},
        {'id': 51, 'status': 'beklenmeyen'},
      ]);

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.failed, pushed: 50),
      );
      expect(requests, hasLength(1));
      final left = await readOutbox(db);
      expect(left.map((entry) => entry.id), _range(51, 150));
      expect(left.map((entry) => entry.attempts), everyElement(0));
      expect(left.map((entry) => entry.lastError), everyElement(isNull));
    });
  });

  group('kilit', () {
    test(
      'tur sürerken gelen çağrı yeni tur başlatmaz, sonucunu bekler',
      () async {
        await enqueue(1);
        final entered = Completer<void>();
        final release = Completer<void>();
        handler = (request) async {
          entered.complete();
          await release.future;
          return _accept(request);
        };

        final first = service.push();
        await entered.future;
        final second = service.push();
        expect(second, same(first));

        release.complete();
        const result = SyncResult(status: SyncStatus.done, pushed: 1);
        expect(await first, result);
        expect(await second, result);
        expect(requests, hasLength(1));
      },
    );

    test(
      'yeniden deneme beklenirken gelen çağrı da aynı turu bekler',
      () async {
        await enqueue(1);
        final waiting = Completer<void>();
        final resume = Completer<void>();
        service = SyncService(
          db,
          client,
          clock: clock.call,
          delay: (_) {
            waiting.complete();
            return resume.future;
          },
        );
        handler = (request) {
          if (requests.length == 1) throw const SocketException('çevrimdışı');
          return _accept(request);
        };

        final first = service.push();
        await waiting.future;
        expect(service.push(), same(first));

        resume.complete();
        expect(
          await first,
          const SyncResult(status: SyncStatus.done, pushed: 1),
        );
        expect(requests, hasLength(2));
      },
    );

    test('biten tur kilidi bırakır, hatayla bitse de', () async {
      await enqueue(1);
      handler = (_) => _postgrestError('42501', 401);
      expect((await service.push()).status, SyncStatus.failed);

      handler = _accept;
      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 1),
      );
      expect(requests, hasLength(2));
    });
  });

  group('çekme', () {
    test('her yerel senkron tablosunu çeker', () {
      expect(service.pullTables.map((table) => table.actualTableName).toSet(), {
        for (final table in db.allTables)
          if (table.$columns.any((column) => column.name == 'server_seq'))
            table.actualTableName,
      });
    });

    test('tabloları sırayla imleçten çeker, satırları yerel DB’ye '
        'sunucudaki değerleriyle yazar', () async {
      handler = _server({
        'organizations': [_organizationRow(1)],
        'memberships': [_membershipRow(2)],
        'apiaries': [_apiaryRow('apiary-1', 3)],
        'queens': [_queenRow(4)],
        'hives': [_hiveRow('hive-1', 5)],
        'hive_location_history': [_moveRow(6)],
        'inspections': [_inspectionRow(7)],
        'media': [_mediaRow(8)],
        'mite_counts': [_miteCountRow(9)],
        'ref_drugs': [_refDrugRow(10)],
        'drugs': [_drugRow(11)],
        'treatments': [_treatmentRow(12)],
        'feedings': [_feedingRow(13)],
        'tasks': [_taskRow(14)],
        'harvests': [_harvestRow(15)],
        'harvest_hives': [_harvestHiveRow(16)],
        'documents': [_documentRow(17)],
        'migrations': [_migrationRow(18)],
        'migration_stops': [_migrationStopRow(19)],
        'transports': [_transportRow(20)],
        'transport_items': [_transportItemRow(21)],
        'inventory_items': [_inventoryItemRow(22)],
        'inventory_moves': [_inventoryMoveRow(23)],
        'queen_rearing_batches': [_rearingBatchRow(24)],
        'mating_nucs': [_matingNucRow(25)],
        'lots': [_lotRow(26)],
        'lot_harvests': [_lotHarvestRow(27)],
        'lot_treatments': [_lotTreatmentRow(28)],
        'lab_results': [_labResultRow(29)],
        'lot_sales': [_lotSaleRow(30)],
        'customers': [_customerRow(32)],
        'transactions': [_transactionRow(31)],
        'customer_payments': [_customerPaymentRow(33)],
        'ref_support_periods': [_supportPeriodRow(34)],
        'hive_status_events': [_statusEventRow(35)],
      });

      expect(
        await service.pull(),
        const SyncResult(status: SyncStatus.done, pulled: 35),
      );

      expect(requests.map(_pullOf), [
        (table: 'organizations', since: 0),
        (table: 'memberships', since: 0),
        (table: 'apiaries', since: 0),
        (table: 'queens', since: 0),
        (table: 'hives', since: 0),
        (table: 'hive_location_history', since: 0),
        (table: 'hive_status_events', since: 0),
        (table: 'inspections', since: 0),
        (table: 'media', since: 0),
        (table: 'mite_counts', since: 0),
        (table: 'ref_drugs', since: 0),
        (table: 'drugs', since: 0),
        (table: 'treatments', since: 0),
        (table: 'feedings', since: 0),
        (table: 'tasks', since: 0),
        (table: 'harvests', since: 0),
        (table: 'harvest_hives', since: 0),
        (table: 'documents', since: 0),
        (table: 'migrations', since: 0),
        (table: 'migration_stops', since: 0),
        (table: 'transports', since: 0),
        (table: 'transport_items', since: 0),
        (table: 'inventory_items', since: 0),
        (table: 'inventory_moves', since: 0),
        (table: 'queen_rearing_batches', since: 0),
        (table: 'mating_nucs', since: 0),
        (table: 'lots', since: 0),
        (table: 'lot_harvests', since: 0),
        (table: 'lot_treatments', since: 0),
        (table: 'lab_results', since: 0),
        (table: 'lot_sales', since: 0),
        (table: 'customers', since: 0),
        (table: 'transactions', since: 0),
        (table: 'customer_payments', since: 0),
        (table: 'ref_support_periods', since: 0),
      ]);
      final body = jsonDecode(requests.first.body) as Map<String, dynamic>;
      expect(body['page_size'], SyncService.pullPageSize);
      expect(requests.first.headers['Authorization'], 'Bearer user-token');

      final organization = await db.select(db.organizations).getSingle();
      expect(organization.name, 'Petek Arıcılık');
      expect(organization.hiveCountRange, HiveCountRange.upTo50);
      expect(organization.trAksHiveCount, 120);
      expect(
        (await db.select(db.memberships).getSingle()).role,
        MembershipRole.owner,
      );

      final apiary = (await ApiaryRepository(db).findById('apiary-1'))!;
      expect(apiary.latitude, 38.41);
      expect(apiary.landTenure, LandTenure.rented);
      expect(apiary.createdBy, 'user-1');
      expect(apiary.serverSeq, 3);
      // Mikrosaniye ve UTC korunur; son yazan kazanır kararı buna dayanır.
      expect(apiary.updatedAt, DateTime.utc(2026, 10, 23, 8, 0, 0, 123, 456));
      expect(apiary.createdAt, DateTime.utc(2026, 10, 23, 7));

      final queen = (await QueenRepository(db).findById('queen-1'))!;
      expect(queen.markColor, QueenMarkColor.yellow);
      expect(queen.source, QueenSource.ownRearing);
      expect(queen.matingStatus, QueenMatingStatus.mated);
      expect(queen.wingClipped, isTrue);

      final hive = (await HiveRepository(db).findById('hive-1'))!;
      expect(hive.type, HiveType.langstroth);
      expect(hive.source, HiveSource.swarm);
      expect(hive.boxCount, 2);

      final move = (await HiveLocationRepository(db).findById('move-1'))!;
      expect(move.movedAt, DateTime.utc(2026, 10, 23, 6, 30));

      final inspection = (await InspectionRepository(db)
          .findById('inspection-1'))!;
      expect(inspection.inspectedAt, DateTime.utc(2026, 10, 23, 7, 15));
      expect(inspection.queenState, QueenState.eggs);
      expect(inspection.temperament, Temperament.nervous);
      expect(inspection.queenCells, QueenCells.swarm);
      expect(inspection.swarmSigns, isTrue);
      expect(inspection.diseaseSuspected, isFalse);
      expect(inspection.beeFrames, 8);
      expect(inspection.honeyFrames, isNull);
      expect(inspection.actions, {
        InspectionAction.superAdded,
        InspectionAction.fed,
      });
      expect(inspection.data['later_field'], 1);

      final media = (await MediaRepository(db).findById('media-1'))!;
      expect(media.kind, MediaKind.audio);
      expect(media.inspectionId, 'inspection-1');
      expect(media.capturedAt, DateTime.utc(2026, 10, 23, 7, 16));
      expect(media.durationMs, 12000);

      final count = (await MiteCountRepository(db).findById('mite-count-1'))!;
      expect(count.method, MiteCountMethod.stickyBoard);
      expect(count.countedAt, DateTime.utc(2026, 10, 23, 7, 20));
      expect(count.mites, 30);
      expect(count.sampleBees, isNull);
      expect(count.days, 3);

      final refDrug = (await RefDrugRepository(db).watchAll().first).single;
      expect(refDrug.countryCode, 'TR');
      expect(refDrug.doseUnit, DrugDoseUnit.strip);
      expect(refDrug.withdrawalDays, isNull);
      final drug = (await DrugRepository(db).findById('drug-1'))!;
      expect(drug.activeIngredient, DrugActiveIngredient.thymol);
      expect(drug.withdrawalDays, 14);
      final treatment = (await TreatmentRepository(db)
          .findById('treatment-1'))!;
      expect(treatment.dose, 2.0);
      expect(treatment.batchNo, '24-118');
      expect(treatment.plannedRemovalAt, DateTime.utc(2026, 12, 5, 9));
      expect(treatment.applicationId, 'application-1');
      final feeding = (await FeedingRepository(db).findById('feeding-1'))!;
      expect(feeding.kind, FeedingKind.syrup2to1);
      expect(feeding.amount, 3.785);
      expect(feeding.feedingGroupId, 'feeding-group-1');
      expect(feeding.fedAt, DateTime.utc(2026, 10, 26, 9));
      final task = (await TaskRepository(db).findById('task-1'))!;
      expect(task.source, TaskSource.inspection);
      expect(task.sourceId, 'inspection-1');
      expect(task.title, isNull);
      expect(task.dueAt, DateTime.utc(2026, 11, 5, 9));
      expect(task.assignedTo, 'user-1');
      final harvests = HarvestRepository(db);
      final harvest = (await harvests.findById('harvest-1'))!;
      expect(harvest.honeyKind, HoneyKind.pine);
      expect(harvest.unit, HarvestUnit.superBox);
      expect(harvest.unitCount, 24);
      expect(harvest.netKg, 574.5);
      expect(harvest.harvestedAt, DateTime.utc(2026, 10, 26, 9));
      final harvested = (await harvests.findHives('harvest-1')).single;
      expect(harvested.hiveId, 'hive-1');
      expect(
        harvested.withdrawalOverride,
        const WithdrawalOverride(
          treatmentId: 'treatment-1',
          reason: WithdrawalOverrideReason.notForSale,
        ),
      );

      expect(await _cursors(db), {
        'organizations': 1,
        'memberships': 2,
        'apiaries': 3,
        'queens': 4,
        'hives': 5,
        'hive_location_history': 6,
        'inspections': 7,
        'media': 8,
        'mite_counts': 9,
        'ref_drugs': 10,
        'drugs': 11,
        'treatments': 12,
        'feedings': 13,
        'tasks': 14,
        'harvests': 15,
        'harvest_hives': 16,
        'documents': 17,
        'migrations': 18,
        'migration_stops': 19,
        'transports': 20,
        'transport_items': 21,
        'inventory_items': 22,
        'inventory_moves': 23,
        'queen_rearing_batches': 24,
        'mating_nucs': 25,
        'lots': 26,
        'lot_harvests': 27,
        'lot_treatments': 28,
        'lab_results': 29,
        'lot_sales': 30,
        'transactions': 31,
        'customers': 32,
        'customer_payments': 33,
        'ref_support_periods': 34,
        'hive_status_events': 35,
        fullPullMarker: 0,
      });
      final statusEvent = await db.select(db.hiveStatusEvents).getSingle();
      expect(statusEvent.toStatus, HiveStatus.dead);
      expect(statusEvent.lossReason, HiveLossReason.wintering);
      final document = (await DocumentRepository(db).findById('document-1'))!;
      expect(document.type, DocumentType.transportPermit);
      expect(document.expiresOn, DateTime(2027, 5));
      expect(document.toJson()['expires_on'], '2027-05-01');
      expect(document.fileKind, DocumentFileKind.photo);
      final migrations = MigrationRepository(db);
      expect((await migrations.findById('migration-1'))!.year, 2026);
      final stop = (await migrations.stops.findById('stop-1'))!;
      expect(stop.status, MigrationStopStatus.current);
      expect(stop.plannedStartOn, DateTime(2026, 8));
      expect(stop.toJson()['planned_end_on'], '2026-11-15');
      expect(stop.hiveCount, 152);
      final transports = TransportRepository(db);
      final transport = (await transports.findById('transport-1'))!;
      expect(transport.vehicles, ['Kamyon 1', 'Kamyon 2']);
      expect(transport.status, TransportStatus.unloading);
      expect(transport.migrationStopId, 'stop-1');
      final item = (await transports.items.findById('transport-item-1'))!;
      expect(item.vehicle, 'Kamyon 2');
      expect(item.loadedAt, DateTime.utc(2026, 11, 15, 18, 5));
      expect(item.unloadedAt, isNull);
      final inventory = InventoryRepository(db);
      final stockItem = (await inventory.findById('inventory-item-1'))!;
      expect(stockItem.category, InventoryCategory.comb);
      expect(stockItem.unit, InventoryUnit.piece);
      expect(stockItem.threshold, 100);
      final stockMove = (await inventory.moves.findById('inventory-move-1'))!;
      expect(stockMove.kind, InventoryMoveKind.stockOut);
      expect(stockMove.quantity, -12.5);
      expect(stockMove.linkedId, 'feeding-1');
      expect(await inventory.moves.stockOf('inventory-item-1'), -12.5);
      final rearing = QueenRearingRepository(db);
      final batch = (await rearing.findById('rearing-batch-1'))!;
      expect(batch.graftedOn, DateTime(2026, 5, 12));
      expect(batch.toJson()['grafted_on'], '2026-05-12');
      expect(batch.acceptedCount, 34);
      final nuc = (await rearing.nucs.findById('mating-nuc-1'))!;
      expect(nuc.status, MatingNucStatus.laying);
      expect(nuc.rearingBatchId, 'rearing-batch-1');
      final lots = LotRepository(db);
      final lot = (await lots.findById('lot-1'))!;
      expect(lot.honeyKind, HoneyKind.pine);
      expect(lot.moisture, 17.2);
      expect(lot.status, LotStatus.open);
      expect((await lots.findByHarvest('harvest-1'))?.id, 'lot-1');
      final lotTreatment = (await lots.treatments.findById('lot-treatment-1'))!;
      expect(lotTreatment.withdrawalEndsOn, DateTime(2026, 11, 10));
      expect(lotTreatment.withdrawalViolation, isTrue);
      final labResult = (await lots.labResults.findById('lab-result-1'))!;
      expect(labResult.residue, ResidueResult.none);
      expect(labResult.toJson()['tested_on'], '2026-10-28');
      expect((await lots.sales.findById('lot-sale-1'))!.kg, 100.5);
      final transaction = (await TransactionRepository(db)
          .findById('transaction-1'))!;
      expect(transaction.kind, TransactionKind.income);
      expect(transaction.category, TransactionCategory.honey);
      expect(transaction.amount, 56000.5);
      expect(transaction.occurredOn, DateTime(2026, 10, 29));
      expect(transaction.lotSaleId, 'lot-sale-1');
      expect(transaction.customerId, 'customer-1');
      final customer = (await CustomerRepository(db).findById('customer-1'))!;
      expect(customer.address, 'Rize');
      final payment = (await CustomerPaymentRepository(
        db,
      ).findBySale('transaction-1')).single;
      expect(payment.amount, 20000);
      expect(payment.paidOn, DateTime(2026, 10, 30));
      final period = (await SupportPeriodRepository(
        db,
      ).watchAll().first).single;
      expect(period.name, 'Arıcılık desteği');
      expect(period.applicationStartsOn, DateTime(2027, 1, 15));
      expect(period.applicationEndsOn, DateTime(2027, 2, 15));
      expect(period.sourceUrl, 'https://www.tarimorman.gov.tr/');
      // Çekme outbox'a yazmaz; inen satırlar geri gönderilmez.
      expect(await readOutbox(db), isEmpty);
    });

    test('mevcut satırı sunucudaki hâliyle günceller', () async {
      handler = _server({
        'apiaries': [_apiaryRow('apiary-1', 3)],
      });
      await service.pull();

      handler = _server({
        'apiaries': [_apiaryRow('apiary-1', 9, name: 'Ova')],
      });
      expect((await service.pull()).pulled, 1);

      expect((await ApiaryRepository(db).findById('apiary-1'))!.name, 'Ova');
      expect(await db.select(db.apiaries).get(), hasLength(1));
      expect((await _cursors(db))['apiaries'], 9);
    });

    test(
      'sayfa sayfa çeker; yarıda kesilirse kaldığı sayfadan sürer',
      () async {
        final hives = [
          for (var seq = 1; seq <= 5; seq++) _hiveRow('h$seq', seq),
        ];
        final serve = _server({'hives': hives}, maxPage: 2);
        handler = (request) {
          final hiveRequests = requests.where(
            (request) => _pullOf(request).table == 'hives',
          );
          // Üçüncü sayfa reddedilir (ör. oturum düştü).
          if (_pullOf(request).table == 'hives' && hiveRequests.length == 3) {
            return _postgrestError('42501', 401);
          }
          return serve(request);
        };

        expect(
          await service.pull(),
          const SyncResult(status: SyncStatus.failed, pulled: 4),
        );
        expect(requests.map(_pullOf).where((pull) => pull.table == 'hives'), [
          (table: 'hives', since: 0),
          (table: 'hives', since: 2),
          (table: 'hives', since: 4),
        ]);
        expect((await _cursors(db))['hives'], 4);
        expect(await db.select(db.hives).get(), hasLength(4));
        expect((await _cursors(db)).containsKey(fullPullMarker), isFalse);

        requests.clear();
        handler = serve;
        expect(
          await service.pull(),
          const SyncResult(status: SyncStatus.done, pulled: 1),
        );
        expect(
          requests.map(_pullOf).firstWhere((pull) => pull.table == 'hives'),
          (table: 'hives', since: 4),
        );
        expect(await db.select(db.hives).get(), hasLength(5));
        expect((await _cursors(db))['hives'], 5);
      },
    );

    test('outbox’ta bekleyen değişikliği olan satırı ezmez; imleç onu '
        'geçmez, gönderilince sunucudaki hâli iner', () async {
      final repository = ApiaryRepository(db, clock: clock.call);
      final local = await repository.create(orgId: _org, name: 'Yerel ad');
      final server = _server({
        'apiaries': [
          _apiaryRow(local.id, 7, name: 'Sunucudaki ad'),
          _apiaryRow('apiary-2', 8),
        ],
      });
      handler = server;

      expect((await service.pull()).pulled, 1);
      expect((await repository.findById(local.id))!.name, 'Yerel ad');
      expect(await repository.findById('apiary-2'), isNotNull);
      expect((await _cursors(db))['apiaries'], 6);

      await service.push();
      requests.clear();
      expect((await service.pull()).pulled, 2);
      expect(
        requests.where(_isPull).map(_pullOf),
        contains((table: 'apiaries', since: 6)),
      );
      expect((await repository.findById(local.id))!.name, 'Sunucudaki ad');
      expect((await _cursors(db))['apiaries'], 8);
    });

    test('sunucunun reddettiği kayıt bekleyen sayılmaz; satır sunucudaki '
        'hâliyle güncellenir', () async {
      final repository = ApiaryRepository(db, clock: clock.call);
      final local = await repository.create(orgId: _org, name: 'Yerel ad');
      await db
          .update(db.outbox)
          .write(const OutboxCompanion(lastError: Value('forbidden: RLS')));
      handler = _server({
        'apiaries': [_apiaryRow(local.id, 7, name: 'Sunucudaki ad')],
      });

      expect((await service.pull()).pulled, 1);
      expect((await repository.findById(local.id))!.name, 'Sunucudaki ad');
      expect((await _cursors(db))['apiaries'], 7);
    });

    test('silinen satır deleted_at ile yazılır, listelerden düşer', () async {
      handler = _server({
        'apiaries': [
          _apiaryRow('apiary-1', 3, deletedAt: '2026-10-23T09:00:00+00:00'),
        ],
      });

      await service.pull();

      expect(await ApiaryRepository(db).findById('apiary-1'), isNull);
      final row = await db.select(db.apiaries).getSingle();
      expect(row.deletedAt, DateTime.utc(2026, 10, 23, 9));
    });

    test('geriye bakma payında yeniden gelen satırlar zararsız', () async {
      // Taze bölgede sunucu satırları döner ama imleci ilerletmez.
      handler = (request) => _isPull(request)
          ? _json({
              'rows': _pullOf(request).table == 'apiaries'
                  ? [_apiaryRow('apiary-1', 3), _apiaryRow('apiary-2', 4)]
                  : const <Object>[],
              'next_seq': 0,
              'has_more': false,
            })
          : _accept(request);

      await service.pull();
      await service.pull();

      expect(await db.select(db.apiaries).get(), hasLength(2));
      expect((await _cursors(db))['apiaries'], 0);
    });

    test('sunucuda olup yerelde olmayan kolon atlanır', () async {
      handler = _server({
        'apiaries': [
          {..._apiaryRow('apiary-1', 3), 'gelecek_kolon': 'değer'},
        ],
      });

      expect((await service.pull()).status, SyncStatus.done);
      expect(await ApiaryRepository(db).findById('apiary-1'), isNotNull);
    });

    final invalidRows = <String, Map<String, Object?>>{
      'tanınmayan enum değeri (daha yeni şema)': _hiveRow(
        'hive-2',
        2,
        type: 'top_bar',
      ),
      'zorunlu alan boş': {..._hiveRow('hive-2', 2), 'number': null},
      'yanlış tür': {..._hiveRow('hive-2', 2), 'box_count': 'iki'},
      'bozuk tarih': {..._hiveRow('hive-2', 2), 'updated_at': 'dün'},
    };
    for (final MapEntry(key: name, value: row) in invalidRows.entries) {
      test('okunamayan satır sayfayı reddeder: $name', () async {
        handler = _server({
          'hives': [_hiveRow('hive-1', 1), row],
        });

        expect(
          await service.pull(),
          const SyncResult(status: SyncStatus.failed),
        );
        expect(await db.select(db.hives).get(), isEmpty);
        expect((await _cursors(db)).containsKey('hives'), isFalse);
      });
    }

    test('nesne olmayan jsonb sayfayı reddeder', () async {
      handler = _server({
        'inspections': [
          {
            ..._inspectionRow(1),
            'data': ['fed'],
          },
        ],
      });

      expect(await service.pull(), const SyncResult(status: SyncStatus.failed));
      expect(await db.select(db.inspections).get(), isEmpty);
    });

    test('ilerlemeden “devamı var” diyen yanıtta durur', () async {
      handler = (request) => _isPull(request)
          ? _json({'rows': const <Object>[], 'next_seq': 0, 'has_more': true})
          : _accept(request);

      expect(await service.pull(), const SyncResult(status: SyncStatus.failed));
      expect(requests, hasLength(1));
    });

    test('geçici hatada aynı sayfayı üstel bekleyerek yeniden ister', () async {
      final serve = _server({
        'apiaries': [_apiaryRow('apiary-1', 3)],
      });
      handler = (request) {
        if (requests.length <= 2) throw const SocketException('çevrimdışı');
        return serve(request);
      };

      expect(
        await service.pull(),
        const SyncResult(status: SyncStatus.done, pulled: 1),
      );
      expect(delays, _seconds([1, 2]));
      expect(requests.take(3).map(_pullOf), [
        for (var i = 0; i < 3; i++) (table: 'organizations', since: 0),
      ]);
    });

    test('denemeler tükenince durur; imleçler yerinde, tam çekme '
        'işaretlenmez', () async {
      handler = (_) => throw const SocketException('çevrimdışı');

      expect(
        await service.pull(),
        const SyncResult(status: SyncStatus.retryLater),
      );
      expect(delays, _seconds([1, 2, 4, 8, 16]));
      expect(await _cursors(db), isEmpty);
    });

    test('yeniden denenmeyen hatada hemen durur', () async {
      handler = (_) => _postgrestError('42501', 401);

      expect(await service.pull(), const SyncResult(status: SyncStatus.failed));
      expect(requests, hasLength(1));
      expect(delays, isEmpty);
    });

    test('ilerlemeyi tablo tablo bildirir', () async {
      handler = _server({
        'organizations': [_organizationRow(1)],
        'apiaries': [_apiaryRow('apiary-1', 3), _apiaryRow('apiary-2', 4)],
      });
      final progress = <SyncProgress>[];

      await service.pull(onProgress: progress.add);

      final tableCount = service.pullTables.length;
      SyncProgress at(int tablesDone, int rows) => SyncProgress(
        tablesDone: tablesDone,
        tableCount: tableCount,
        rowsPulled: rows,
      );
      expect(progress.first, at(0, 0));
      expect(progress.last, at(tableCount, 3));
      expect(progress, contains(at(2, 3)));
      expect(
        progress.map((event) => event.tablesDone),
        orderedEquals([...progress.map((event) => event.tablesDone)]..sort()),
      );
    });

    test('tur sürerken gelen çağrı aynı turu bekler', () async {
      final entered = Completer<void>();
      final release = Completer<void>();
      final serve = _server({});
      handler = (request) async {
        if (!entered.isCompleted) entered.complete();
        await release.future;
        return await serve(request);
      };

      final first = service.pull();
      await entered.future;
      expect(service.pull(), same(first));
      release.complete();
      expect((await first).status, SyncStatus.done);
      expect(requests, hasLength(service.pullTables.length));
    });
  });

  group('tam tur', () {
    test('önce gönderir, sonra çeker; sonuçlar birleşir', () async {
      await enqueue(2);
      handler = _server({
        'hives': [_hiveRow('hive-1', 5)],
      });

      expect(
        await service.sync(),
        const SyncResult(status: SyncStatus.done, pushed: 2, pulled: 1),
      );
      expect(requests.first.url.path, '/rest/v1/rpc/sync_push');
      expect(requests.skip(1).every(_isPull), isTrue);
      expect(requests.skip(1), hasLength(service.pullTables.length));
    });

    test('biten tur son eşitleme anını bu telefona kalıcı yazar', () async {
      handler = _server({});
      final settings = LocalSettingsRepository(db);

      await service.sync();

      expect(
        await settings.watchLastSyncedAt().first,
        DateTime.utc(2026, 10, 23, 9),
      );
    });

    test('bitmeyen tur son eşitleme anını değiştirmez', () async {
      await enqueue(1);
      handler = (_) => throw const SocketException('çevrimdışı');

      await service.sync();

      expect(await LocalSettingsRepository(db).watchLastSyncedAt().first, null);
    });

    test('gönderme bitmezse çekmez', () async {
      await enqueue(1);
      handler = (_) => throw const SocketException('çevrimdışı');

      expect(
        await service.sync(),
        const SyncResult(status: SyncStatus.retryLater),
      );
      expect(requests.where(_isPull), isEmpty);
    });

    test('reddedilen kayıt turu durdurmaz', () async {
      await enqueue(2);
      final serve = _server({});
      handler = (request) => _isPull(request)
          ? serve(request)
          : _accept(request, rejected: {1: 'invalid'});

      expect(
        await service.sync(),
        const SyncResult(status: SyncStatus.done, pushed: 1, rejected: 1),
      );
      expect(requests.where(_isPull), hasLength(service.pullTables.length));
    });

    test('tur sürerken gelen çağrı aynı turu bekler', () async {
      await enqueue(1);
      final entered = Completer<void>();
      final release = Completer<void>();
      final serve = _server({});
      handler = (request) async {
        if (!entered.isCompleted) entered.complete();
        await release.future;
        return await serve(request);
      };

      final first = service.sync();
      await entered.future;
      expect(service.sync(), same(first));
      release.complete();
      expect(await first, const SyncResult(status: SyncStatus.done, pushed: 1));
      expect(requests, hasLength(1 + service.pullTables.length));
    });
  });
}
