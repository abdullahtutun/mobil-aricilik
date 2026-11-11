import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/receipt_sync_service.dart';
import 'package:mobil_arici/core/sync/supabase_file_store.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/test_database.dart';

const _url = 'http://supabase.test';
const _objectPath = '/storage/v1/object/receipts/';

typedef _Handler = FutureOr<http.Response> Function(http.Request request);

http.Response _storageError(int status, String error) => http.Response(
  jsonEncode({'statusCode': '$status', 'error': error, 'message': error}),
  status == 409 ? 400 : status,
  headers: {'content-type': 'application/json'},
);

void main() {
  late AppDatabase db;
  late TestClock clock;
  late Directory directory;
  late MediaFileStore files;
  late TransactionRepository transactions;
  late ReceiptSyncService service;
  late List<http.Request> requests;
  late _Handler handler;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    directory = Directory.systemTemp.createTempSync('receipt_sync_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    files = MediaFileStore(Future.value(directory));
    transactions = TransactionRepository(db, clock: clock.call);
    requests = [];
    handler = (_) => http.Response(jsonEncode({'Key': 'ok'}), 200);
    final client = SupabaseClient(
      _url,
      'anon-key',
      accessToken: () async => 'user-token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return await handler(request);
      }),
    );
    addTearDown(client.dispose);
    service = ReceiptSyncService(
      db,
      SupabaseFileStore(client),
      files,
      clock: clock.call,
    );
  });

  /// Fişi fiş klasöründe olan bir gider yazar.
  Future<FinanceTransaction> add(String fileId, {bool withFile = true}) async {
    final receipt = (fileId: fileId, byteSize: 10);
    if (withFile) {
      await files.write(receipt.fileName, utf8.encode('bytes:$fileId'));
    }
    clock.advance(const Duration(seconds: 1));
    return await transactions.create(
      orgId: 'org-1',
      kind: TransactionKind.expense,
      category: TransactionCategory.feeding,
      amount: 100,
      currency: 'TRY',
      occurredOn: DateTime(2026, 10, 22),
      receipt: receipt,
    );
  }

  Future<ReceiptUpload> uploadOf(String storagePath) => (db.select(
    db.receiptUploads,
  )..where((t) => t.storagePath.equals(storagePath))).getSingle();

  List<String> uploadedPaths() => [
    for (final request in requests)
      if (request.method == 'POST')
        request.url.path.substring(_objectPath.length),
  ];

  group('yükleme', () {
    test('bekleyenleri sırayla doğru yola, JPEG olarak ve oturumla '
        'yükler; yüklenen yeniden gönderilmez', () async {
      final first = await add('f1');
      final second = await add('f2');

      final result = await service.uploadPending();

      expect(result.done, 2);
      expect(uploadedPaths(), [first.receiptPath, second.receiptPath]);
      expect(requests[0].headers['Authorization'], 'Bearer user-token');
      expect(utf8.decode(requests[0].bodyBytes), contains('bytes:f1'));
      expect(
        utf8.decode(requests[0].bodyBytes),
        contains('content-type: image/jpeg'),
      );
      expect(
        (await uploadOf(first.receiptPath!)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
      expect(await transactions.watchPendingReceiptCount().first, 0);

      await service.uploadPending();
      expect(requests, hasLength(2));
    });

    test('Storage’da zaten olan fiş (409) yüklendi sayılır', () async {
      final saved = await add('f1');
      handler = (_) => _storageError(409, 'Duplicate');

      await service.uploadPending();

      expect(
        (await uploadOf(saved.receiptPath!)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
    });

    test('geçici hatada ertelenir ve tur durur', () async {
      final first = await add('f1');
      await add('f2');
      handler = (_) => _storageError(503, 'Unavailable');

      final result = await service.uploadPending();

      expect(result.retryLater, isTrue);
      expect(requests, hasLength(1));
      final postponed = await uploadOf(first.receiptPath!);
      expect(postponed.uploadStatus, MediaUploadStatus.pending);
      expect(postponed.attempts, 1);
      expect(postponed.nextAttemptAt, isNotNull);
    });

    test('yetki hatası ve kayıp dosya kalıcı; kuyruk durmaz', () async {
      final forbidden = await add('f1');
      final missing = await add('f2', withFile: false);
      final fine = await add('f3');
      handler = (request) => request.url.path.endsWith(forbidden.receiptPath!)
          ? _storageError(403, 'Unauthorized')
          : http.Response(jsonEncode({'Key': 'ok'}), 200);

      final result = await service.uploadPending();

      expect(result.failed, 2);
      expect(result.done, 1);
      expect(
        (await uploadOf(missing.receiptPath!)).lastError,
        startsWith('missing_file'),
      );
      expect(
        (await uploadOf(fine.receiptPath!)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
    });
  });

  group('indirme', () {
    Future<void> pulled(String id, String fileId, {String org = 'org-1'}) => db
        .into(db.transactions)
        .insert(
          FinanceTransaction(
            id: id,
            orgId: org,
            kind: TransactionKind.expense,
            category: TransactionCategory.labor,
            amount: 50,
            currency: 'TRY',
            occurredOn: DateTime(2026, 10, 22),
            receiptPath: '$org/$id/$fileId.jpg',
            createdAt: clock.current,
            updatedAt: clock.current,
          ).toInsertable(),
        );

    test('fişi bu telefonda olmayanları yolun son parçası adıyla indirir; '
        'olanı ve başka işletmeninkini istemez', () async {
      await add('local');
      await pulled('remote-1', 'r1');
      await pulled('remote-2', 'r2', org: 'org-2');
      handler = (_) => http.Response.bytes([1, 2, 3], 200);

      final result = await service.downloadMissing('org-1');

      expect(result.done, 1);
      expect(requests.single.method, 'GET');
      expect(requests.single.url.path, '${_objectPath}org-1/remote-1/r1.jpg');
      expect((await files.find('r1.jpg'))!.readAsBytesSync(), [1, 2, 3]);

      requests.clear();
      await service.downloadMissing('org-1');
      expect(requests, isEmpty);
    });

    test('ağ yoksa tur durur', () async {
      await pulled('remote-1', 'r1');
      await pulled('remote-2', 'r2');
      handler = (_) => throw const SocketException('ağ yok');

      final result = await service.downloadMissing('org-1');

      expect(result.retryLater, isTrue);
      expect(requests, hasLength(1));
    });
  });
}
