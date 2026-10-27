import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';

VaultDocument _document({
  String id = 'doc-1',
  String name = 'Sağlık raporu',
  DateTime? expiresOn,
  DocumentType type = DocumentType.healthReport,
  String? customTypeName,
}) => VaultDocument(
  id: id,
  orgId: 'org-1',
  type: type,
  customTypeName: customTypeName,
  name: name,
  expiresOn: expiresOn,
  fileKind: DocumentFileKind.pdf,
  storagePath: 'org-1/$id/file-$id.pdf',
  byteSize: 1000,
  createdAt: DateTime.utc(2026, 10, 27),
  updatedAt: DateTime.utc(2026, 10, 27),
);

void main() {
  group('saatsiz gün', () {
    test('"2027-05-01" biçiminde yazılır ve okunur; saat atılır', () {
      expect(formatDateOnly(DateTime(2027, 5, 1, 23, 59)), '2027-05-01');
      expect(parseDateOnly('2027-05-01'), DateTime(2027, 5));
      expect(dateOnly(DateTime(2027, 5, 1, 18)), DateTime(2027, 5));
    });

    test('biçim tutmazsa FormatException', () {
      expect(
        () => parseDateOnly('2027-05-01T00:00:00Z'),
        throwsFormatException,
      );
    });

    test("JSON'da da aynı biçim; null korunur", () {
      final document = _document(expiresOn: DateTime(2027, 5));
      final json = document.toJson();
      expect(json['expires_on'], '2027-05-01');
      expect(json.containsKey('server_seq'), isFalse);
      expect(VaultDocument.fromJson(json), document);
      expect(_document().toJson()['expires_on'], isNull);
    });
  });

  test('Storage yolu işletme/belge/dosya ve türün uzantısı; yerel ad son '
      'parça', () {
    final path = documentStoragePath(
      orgId: 'org',
      documentId: 'doc',
      fileId: 'file',
      kind: DocumentFileKind.photo,
    );
    expect(path, 'org/doc/file.jpg');
    expect(documentFileName(path), 'file.jpg');
    expect(DocumentFileKind.pdf.contentType, 'application/pdf');
  });

  group('geçerlilik', () {
    final now = DateTime(2026, 10, 27, 15);

    DocumentExpiry expiry(DateTime? day) => documentExpiry(day, now);

    test('tarih yoksa süresiz', () {
      expect(expiry(null), (level: DocumentExpiryLevel.none, daysLeft: null));
    });

    test('son gün dahil geçerli; ertesi gün süresi dolmuş', () {
      expect(expiry(DateTime(2026, 10, 27)), (
        level: DocumentExpiryLevel.urgent,
        daysLeft: 0,
      ));
      expect(expiry(DateTime(2026, 10, 26)), (
        level: DocumentExpiryLevel.expired,
        daysLeft: -1,
      ));
    });

    test('30 gün içinde acil, 90 gün içinde yakın, sonrası geçerli', () {
      expect(expiry(DateTime(2026, 11, 26)).level, DocumentExpiryLevel.urgent);
      expect(expiry(DateTime(2026, 11, 27)).level, DocumentExpiryLevel.soon);
      expect(expiry(DateTime(2027, 1, 25)).level, DocumentExpiryLevel.soon);
      expect(expiry(DateTime(2027, 1, 26)).level, DocumentExpiryLevel.valid);
    });

    test('yaz saati geçişinde gün kaymaz', () {
      expect(
        calendarDaysBetween(DateTime(2026, 3, 28, 23), DateTime(2026, 3, 30)),
        2,
      );
    });

    test('ay sayısı tam 30 günlükler, en az 1', () {
      expect(monthsLeft(31), 1);
      expect(monthsLeft(59), 1);
      expect(monthsLeft(60), 2);
      expect(monthsLeft(90), 3);
      expect(monthsLeft(12), 1);
    });
  });

  test('kasa sırası: önce dolan önce, süresizler sonda, sonra ad', () {
    final sorted = sortDocuments([
      _document(id: 'a', name: 'Tescil'),
      _document(id: 'b', name: 'Nakil 10', expiresOn: DateTime(2027, 5)),
      _document(id: 'c', name: 'Nakil 2', expiresOn: DateTime(2027, 5)),
      _document(id: 'd', name: 'Rapor', expiresOn: DateTime(2026, 11)),
      _document(id: 'e', name: 'Arazi'),
    ]);
    expect([for (final d in sorted) d.id], ['d', 'c', 'b', 'e', 'a']);
  });

  test('kullanıcı tanımlı türler: büyük/küçük harf ve boşluk farkı tek, '
      'hazır türler yok', () {
    expect(
      customDocumentTypes([
        _document(
          id: 'a',
          type: DocumentType.custom,
          customTypeName: 'Insurance ',
        ),
        _document(id: 'b', type: DocumentType.custom, customTypeName: 'permit'),
        _document(
          id: 'c',
          type: DocumentType.custom,
          customTypeName: 'insurance',
        ),
        _document(id: 'd'),
      ]),
      ['Insurance', 'permit'],
    );
  });

  group('hatırlatma planı', () {
    test("son günden 30, 7 ve 1 gün önce saat 9'da; geçmiş olanlar yok", () {
      final plan = documentReminderPlan([
        _document(id: 'near', expiresOn: DateTime(2026, 11, 5)),
        _document(id: 'far', expiresOn: DateTime(2027, 5)),
        _document(id: 'none'),
        _document(id: 'gone', expiresOn: DateTime(2026, 10)),
      ], now: DateTime(2026, 10, 27, 15));

      expect(
        [for (final r in plan) (r.document.id, r.daysLeft, r.at)],
        [
          // 30 gün önce (6 Ekim) geçti.
          ('near', 7, DateTime(2026, 10, 29, 9)),
          ('near', 1, DateTime(2026, 11, 4, 9)),
          ('far', 30, DateTime(2027, 4, 1, 9)),
          ('far', 7, DateTime(2027, 4, 24, 9)),
          ('far', 1, DateTime(2027, 4, 30, 9)),
        ],
      );
    });

    test("bugünün saat 9'u geçtiyse kurulmaz, geçmediyse kurulur", () {
      final document = _document(expiresOn: DateTime(2026, 10, 28));
      expect(
        documentReminderPlan([document], now: DateTime(2026, 10, 27, 10)),
        isEmpty,
      );
      expect(
        documentReminderPlan([document], now: DateTime(2026, 10, 27, 8)),
        hasLength(1),
      );
    });

    test('bildirim kimliği belge ve güne göre sabit ve ayrı', () {
      expect(documentReminderId('doc', 7), documentReminderId('doc', 7));
      expect(documentReminderId('doc', 7), isNot(documentReminderId('doc', 1)));
      expect(documentReminderId('doc', 7), greaterThanOrEqualTo(0));
    });
  });
}
