import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';
import 'package:mobil_arici/core/sync/receipt_sync_service.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';

import '../../helpers/fake_pocketbase_files.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late Directory directory;
  late MediaFileStore files;
  late TransactionRepository transactions;
  late ReceiptSyncService service;
  late FakePocketBaseFiles server;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    directory = Directory.systemTemp.createTempSync('receipt_sync_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    files = MediaFileStore(Future.value(directory));
    transactions = TransactionRepository(db, clock: clock.call);
    server = FakePocketBaseFiles();
    service = ReceiptSyncService(
      db,
      PocketBaseFileStore(server.client()),
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
    for (final upload in server.uploads) upload.body['path'] as String,
  ];

  group('yükleme', () {
    test('bekleyenleri sırayla doğru yola, adıyla ve oturumla '
        'yükler; yüklenen yeniden gönderilmez', () async {
      final first = await add('f1');
      final second = await add('f2');

      final result = await service.uploadPending();

      expect(result.done, 2);
      expect(uploadedPaths(), [first.receiptPath, second.receiptPath]);
      expect(server.uploads.first.authorization, isNotEmpty);
      expect(utf8.decode(server.uploads.first.bytes), 'bytes:f1');
      expect(server.uploads.first.fileName, 'f1.jpg');
      expect(
        (await uploadOf(first.receiptPath!)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
      expect(await transactions.watchPendingReceiptCount().first, 0);

      await service.uploadPending();
      expect(server.requests, hasLength(2));
    });

    test('sunucuda zaten olan fiş yüklendi sayılır', () async {
      final saved = await add('f1');
      server.handler = (_) => fakePocketBaseAlreadyUploaded();

      await service.uploadPending();

      expect(
        (await uploadOf(saved.receiptPath!)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
    });

    test('geçici hatada ertelenir ve tur durur', () async {
      final first = await add('f1');
      await add('f2');
      server.handler = (_) => fakePocketBaseError(503, message: 'Unavailable');

      final result = await service.uploadPending();

      expect(result.retryLater, isTrue);
      expect(server.requests, hasLength(1));
      final postponed = await uploadOf(first.receiptPath!);
      expect(postponed.uploadStatus, MediaUploadStatus.pending);
      expect(postponed.attempts, 1);
      expect(postponed.nextAttemptAt, isNotNull);
    });

    test('yetki hatası ve kayıp dosya kalıcı; kuyruk durmaz', () async {
      final forbidden = await add('f1');
      final missing = await add('f2', withFile: false);
      final fine = await add('f3');
      server.handler = (request) =>
          latin1.decode(request.bodyBytes).contains('bytes:f1')
          ? fakePocketBaseError(403, message: 'Unauthorized')
          : null;

      final result = await service.uploadPending();

      expect(result.failed, 2);
      expect(result.done, 1);
      expect(
        (await uploadOf(forbidden.receiptPath!)).lastError,
        startsWith('403'),
      );
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
      server
        ..put('receipt_files', 'org-1/remote-1/r1.jpg', [1, 2, 3])
        ..put('receipt_files', 'org-2/remote-2/r2.jpg', [4]);

      final result = await service.downloadMissing('org-1');

      expect(result.done, 1);
      expect(server.fileGets, hasLength(1));
      expect((await files.find('r1.jpg'))!.readAsBytesSync(), [1, 2, 3]);
      expect(await files.find('r2.jpg'), isNull);

      server.requests.clear();
      await service.downloadMissing('org-1');
      expect(server.requests, isEmpty);
    });

    test('ağ yoksa tur durur', () async {
      await pulled('remote-1', 'r1');
      await pulled('remote-2', 'r2');
      server.handler = (_) => throw const SocketException('ağ yok');

      final result = await service.downloadMissing('org-1');

      expect(result.retryLater, isTrue);
      expect(server.requests, hasLength(1));
    });
  });

  group('PocketBase', () {
    Future<void> pulledPb(String id, String fileId) => db
        .into(db.transactions)
        .insert(
          FinanceTransaction(
            id: id,
            orgId: 'org-1',
            kind: TransactionKind.expense,
            category: TransactionCategory.labor,
            amount: 50,
            currency: 'TRY',
            occurredOn: DateTime(2026, 10, 22),
            receiptPath: 'org-1/$id/$fileId.jpg',
            createdAt: clock.current,
            updatedAt: clock.current,
          ).toInsertable(),
        );

    test('ilk yükleme receipt_files’a gider; sunucuda zaten olan (ikinci '
        'yükleme) yüklendi sayılır', () async {
      final first = await add('f1');
      final second = await add('f2');
      server.put('receipt_files', second.receiptPath!, [9]);

      final result = await service.uploadPending();

      expect(result.done, 2);
      expect(server.uploads.map((u) => u.body), [
        {'id': 'f1', 'org_id': 'org-1', 'path': first.receiptPath!},
        {'id': 'f2', 'org_id': 'org-1', 'path': second.receiptPath!},
      ]);
      expect(server.uploads.first.collection, 'receipt_files');
      expect(utf8.decode(server.uploads.first.bytes), 'bytes:f1');
      expect(
        (await uploadOf(second.receiptPath!)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
    });

    test('boyut sınırı (400 ve 413) kalıcı; kuyruk durmaz', () async {
      final big = await add('big');
      final huge = await add('huge');
      final fine = await add('fine');
      server.handler = (request) {
        final body = latin1.decode(request.bodyBytes);
        if (body.contains('bytes:big')) {
          return fakePocketBaseError(
            400,
            data: {'file': 'validation_file_size_limit'},
          );
        }
        if (body.contains('bytes:huge')) {
          return http.Response('too large', 413);
        }
        return null;
      };

      final result = await service.uploadPending();

      expect(result.done, 1);
      expect(result.failed, 2);
      expect(
        (await uploadOf(big.receiptPath!)).lastError,
        contains('validation_file_size_limit'),
      );
      expect((await uploadOf(huge.receiptPath!)).lastError, startsWith('413'));
      expect(
        (await uploadOf(fine.receiptPath!)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
    });

    test('ağ hatası geçici: ertelenir, tur durur', () async {
      final first = await add('f1');
      await add('f2');
      server.handler = (_) => throw const SocketException('ağ yok');

      final result = await service.uploadPending();

      expect(result.retryLater, isTrue);
      expect(server.requests, hasLength(1));
      final postponed = await uploadOf(first.receiptPath!);
      expect(postponed.uploadStatus, MediaUploadStatus.pending);
      expect(postponed.attempts, 1);
    });

    test('indirme dosya token’ıyla; yüklenmemiş dosya (404) atlanır', () async {
      await pulledPb('remote-1', 'r1');
      await pulledPb('remote-2', 'r2');
      server.put('receipt_files', 'org-1/remote-2/r2.jpg', [1, 2, 3]);

      final result = await service.downloadMissing('org-1');

      expect(result.done, 1);
      expect(result.failed, 1);
      expect(await files.find('r1.jpg'), isNull);
      expect((await files.find('r2.jpg'))!.readAsBytesSync(), [1, 2, 3]);
      expect(server.fileGets.single.url.queryParameters['token'], isNotEmpty);
    });
  });
}
