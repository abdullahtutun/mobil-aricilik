import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/services/pocketbase_app_api.dart';
import 'package:mobil_arici/core/sync/lot_report_service.dart';
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/data/lot_report_api.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';

import '../../helpers/test_database.dart';

/// Sunucunun istediği raporu [statuses]'tan verir, yüklemeleri kaydeder.
class _FakeApi implements LotReportApi {
  final statuses = <String, LotReportStatus>{};
  final uploads = <({String lotId, String documentId, String fileName})>[];
  final statusCalls = <String>[];
  PocketBaseApiException? statusError;
  PocketBaseApiException? uploadError;

  @override
  Future<LotReportStatus> status(String lotId) async {
    statusCalls.add(lotId);
    if (statusError case final error?) throw error;
    return statuses[lotId] ?? (documentId: null, uploaded: false);
  }

  @override
  Future<void> upload({
    required String lotId,
    required String documentId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (uploadError case final error?) throw error;
    uploads.add((lotId: lotId, documentId: documentId, fileName: fileName));
  }
}

void main() {
  late AppDatabase db;
  late LotRepository lots;
  late DocumentRepository documents;
  late Directory directory;
  late _FakeApi api;
  late LotReportService service;
  late TestClock clock;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 11, 20, 9));
    lots = LotRepository(db, clock: clock.call);
    documents = DocumentRepository(db, clock: clock.call);
    directory = Directory.systemTemp.createTempSync('lot_report');
    addTearDown(() => directory.deleteSync(recursive: true));
    api = _FakeApi();
    service = LotReportService(
      lots,
      documents,
      MediaFileStore(Future.value(directory)),
      api,
    );
  });

  Future<Lot> lot({bool published = true, bool publicReport = true}) async {
    final harvest = (await HarvestRepository(db, clock: clock.call).add(
      orgId: 'org-1',
      plan: (
        apiaryId: 'apiary-1',
        harvestedAt: DateTime.utc(2026, 10, 1, 9),
        honeyKind: HoneyKind.pine,
        unit: HarvestUnit.superBox,
        unitCount: 4,
        netKg: 80,
      ),
      hiveIds: const ['hive-1'],
    )).harvest;
    final created = await lots.createWithHarvest(harvest);
    return await lots.setPublication(
      created.id,
      published: published,
      publicReport: publicReport,
    );
  }

  Future<VaultDocument> report({
    String fileId = 'file-1',
    bool onThisPhone = true,
  }) async {
    final document = await documents.create(
      orgId: 'org-1',
      type: DocumentType.analysisReport,
      name: 'Analiz',
      file: (fileId: fileId, kind: DocumentFileKind.pdf, byteSize: 4),
    );
    if (onThisPhone) {
      File('${directory.path}/${documentFileName(document.storagePath)}')
          .writeAsBytesSync([1, 2, 3, 4]);
    }
    return document;
  }

  test('sunucuda olmayan raporu bu telefondaki dosyadan yükler', () async {
    final published = await lot();
    final document = await report();
    api.statuses[published.id] = (documentId: document.id, uploaded: false);

    final result = await service.uploadReports('org-1');

    expect(result.done, 1);
    expect(api.uploads, [
      (lotId: published.id, documentId: document.id, fileName: 'file-1.pdf'),
    ]);
  });

  test('yüklenmiş rapor, dosyası başka telefonda olan rapor ve rapor '
      'istemeyen lot gönderilmez', () async {
    final uploaded = await lot();
    final elsewhere = await lot();
    final none = await lot();
    final here = await report();
    final other = await report(fileId: 'file-2', onThisPhone: false);
    api.statuses
      ..[uploaded.id] = (documentId: here.id, uploaded: true)
      ..[elsewhere.id] = (documentId: other.id, uploaded: false)
      ..[none.id] = (documentId: null, uploaded: false);

    final result = await service.uploadReports('org-1');

    expect(result.done, 0);
    expect(api.uploads, isEmpty);
    expect(api.statusCalls, hasLength(3));
  });

  test('yayımda olmayan ya da raporu kapalı lot sorulmaz', () async {
    await lot(published: false);
    await lot(publicReport: false);

    await service.uploadReports('org-1');

    expect(api.statusCalls, isEmpty);
  });

  test('bağlantı hatasında tur durur, 409 lotu atlar', () async {
    final first = await lot();
    final document = await report();
    api
      ..statuses[first.id] = (documentId: document.id, uploaded: false)
      ..statusError = const PocketBaseApiException(0);
    expect((await service.uploadReports('org-1')).retryLater, isTrue);

    api
      ..statusError = null
      ..uploadError = const PocketBaseApiException(409, code: 'not_current');
    final result = await service.uploadReports('org-1');
    expect(result.retryLater, isFalse);
    expect(result.failed, 1);
  });
}
