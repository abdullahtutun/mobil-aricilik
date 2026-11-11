import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/features/account_deletion/data/pocketbase_account_deletion_service.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';

import '../../../helpers/fake_pocketbase_api.dart';
import '../../../helpers/fake_pocketbase_files.dart';

const _orgId = '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a';
const _partnerId = '0199a3b2-7c1e-7d40-8a5b-000000000002';

/// `RequestJSON` (`server/internal/deletion`): zamanlar K-5 biçiminde.
const _request = <String, Object?>{
  'id': '0199a3b2-7c1e-7d40-8a5b-0000000000aa',
  'org_id': _orgId,
  'kind': 'hesap_ve_isletme',
  'channel': 'uygulama',
  'status': 'beklemede',
  'requested_at': '2026-11-12T08:00:00.000000Z',
  'scheduled_for': '2026-11-19T08:00:00.000000Z',
  'delete_org_ids': [_orgId],
};

Matcher _throwsFailure(AccountDeletionFailure failure) => throwsA(
  isA<AccountDeletionException>().having((e) => e.failure, 'failure', failure),
);

void main() {
  late FakePocketBaseApi server;
  late PocketBaseAccountDeletionService service;

  setUp(() {
    server = FakePocketBaseApi();
    service = PocketBaseAccountDeletionService(
      server.client(token: 'a.b.c'),
      timeout: const Duration(milliseconds: 200),
    );
  });

  http.Request only() => server.requests.single;

  test('sendCode ve verifyCode kendi route’larına action’sız gider', () async {
    server.handler = (_) => fakePocketBaseJson({'sent': true});
    await service.sendCode();
    server.handler = (_) => fakePocketBaseJson({'verified': true});
    await service.verifyCode('123456');

    expect(server.requests.map((r) => r.url.path), [
      '/api/app/account-deletion/send_code',
      '/api/app/account-deletion/verify_code',
    ]);
    expect(server.requests.map((r) => r.method).toSet(), {'POST'});
    expect(server.requests.first.headers['Authorization'], 'a.b.c');
    // Boş gövde gönderilmez; sunucu bunu `{}` sayar (`readBody`).
    expect(server.requests.first.body, isEmpty);
    expect(FakePocketBaseApi.body(server.requests.last), {'code': '123456'});
  });

  test('request gövdesi ve yanıttaki talep', () async {
    server.handler = (_) => fakePocketBaseJson({
      'request': _request,
      'counts': {
        'hives': 3,
        'apiaries': 1,
        'inspections': 0,
        'harvests': 0,
        'documents': 0,
        'photos': 0,
        'public_lot_pages': 0,
      },
      'already_pending': false,
    });

    final info = await service.request(orgId: _orgId, deleteOrganization: true);

    expect(only().url.path, '/api/app/account-deletion/request');
    expect(FakePocketBaseApi.body(only()), {
      'org_id': _orgId,
      'delete_organization': true,
      'channel': 'uygulama',
    });
    expect(info.scheduledFor, DateTime.utc(2026, 11, 19, 8));
    expect(info.kind, DeletionKind.accountAndOrganization);
  });

  test('devirde transfer_to gider', () async {
    server.handler = (_) => fakePocketBaseJson({
      'request': {..._request, 'kind': 'hesap'},
    });

    final info = await service.request(orgId: _orgId, transferTo: _partnerId);

    expect(FakePocketBaseApi.body(only()), {
      'org_id': _orgId,
      'delete_organization': false,
      'transfer_to': _partnerId,
      'channel': 'uygulama',
    });
    expect(info.kind, DeletionKind.account);
  });

  test('yanıtta talep yoksa bilinmeyen hata', () async {
    server.handler = (_) => fakePocketBaseJson({'request': null});

    await expectLater(
      service.request(orgId: _orgId),
      _throwsFailure(AccountDeletionFailure.unknown),
    );
  });

  test('pending status’u sorar: talep ya da null', () async {
    server.handler = (_) => fakePocketBaseJson({'request': _request});
    final pending = await service.pending();
    expect(only().url.path, '/api/app/account-deletion/status');
    expect(pending?.scheduledFor, DateTime.utc(2026, 11, 19, 8));

    server.handler = (_) => fakePocketBaseJson({'request': null});
    expect(await service.pending(), isNull);
  });

  test('cancel sunucunun cevabını döner', () async {
    server.handler = (_) => fakePocketBaseJson({'cancelled': true});
    expect(await service.cancel(), isTrue);
    expect(only().url.path, '/api/app/account-deletion/cancel');

    server.handler = (_) => fakePocketBaseJson({'cancelled': false});
    expect(await service.cancel(), isFalse);
  });

  group('hata eşleme: kod data.code’da', () {
    final cases = <(int, String, AccountDeletionFailure)>[
      (403, 'code_required', AccountDeletionFailure.codeRequired),
      (
        422,
        'invalid_transfer_target',
        AccountDeletionFailure.invalidTransferTarget,
      ),
      (409, 'owner_must_transfer', AccountDeletionFailure.ownerMustTransfer),
      (429, 'rate_limited', AccountDeletionFailure.rateLimited),
      (429, 'too_many_attempts', AccountDeletionFailure.tooManyAttempts),
      (400, 'invalid_code', AccountDeletionFailure.invalidCode),
      (403, 'forbidden', AccountDeletionFailure.forbidden),
      (401, 'unauthorized', AccountDeletionFailure.forbidden),
      (502, 'mail_failed', AccountDeletionFailure.network),
      (503, 'mail_unavailable', AccountDeletionFailure.network),
      (500, 'server', AccountDeletionFailure.network),
      (400, 'bad_request', AccountDeletionFailure.unknown),
    ];
    for (final (status, code, failure) in cases) {
      test('$status $code → ${failure.name}', () async {
        server.handler = (_) => fakePocketBaseAppError(
          status,
          code,
          data: {
            if (code == 'owner_must_transfer') 'org_ids': [_orgId],
          },
        );
        await expectLater(
          service.request(orgId: _orgId),
          _throwsFailure(failure),
        );
      });
    }

    test('bağlantı hatası ve zaman aşımı ağ hatası', () async {
      server.handler = (_) => throw const SocketException('çevrimdışı');
      await expectLater(
        service.sendCode(),
        _throwsFailure(AccountDeletionFailure.network),
      );

      server.handler = (_) => Completer<http.Response>().future;
      await expectLater(
        service.pending(),
        _throwsFailure(AccountDeletionFailure.network),
      );
    });
  });
}
