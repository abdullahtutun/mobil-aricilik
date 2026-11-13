import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/team/data/pocketbase_team_service.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';

import '../../../helpers/fake_pocketbase_api.dart';
import '../../../helpers/fake_pocketbase_files.dart';

const _orgId = '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a';

Matcher _throwsFailure(TeamFailure failure) => throwsA(
  isA<TeamServiceException>().having((e) => e.failure, 'failure', failure),
);

void main() {
  late FakePocketBaseApi server;
  late PocketBaseTeamService service;

  setUp(() {
    server = FakePocketBaseApi();
    service = PocketBaseTeamService(
      server.client(token: 'a.b.c'),
      timeout: const Duration(milliseconds: 200),
    );
  });

  Map<String, Object?> body(http.Request request) =>
      FakePocketBaseApi.body(request);

  test('createInvite team/create’e action’sız gövdeyle istek atar', () async {
    // Yanıt Edge Function'ınkiyle aynı; zaman K-5 biçiminde.
    server.handler = (_) => fakePocketBaseJson({
      'code': 'AR7K2Q',
      'role': 'worker',
      'expires_at': '2026-10-29T09:00:00.000000Z',
    });

    final invite = await service.createInvite(
      orgId: _orgId,
      role: MembershipRole.worker,
    );

    final request = server.requests.single;
    expect(request.method, 'POST');
    expect(request.url.path, '/api/app/team/create');
    expect(body(request), {'org_id': _orgId, 'role': 'worker'});
    expect(request.headers['Authorization'], 'a.b.c');
    expect(invite.code, 'AR7K2Q');
    expect(invite.role, MembershipRole.worker);
    expect(invite.expiresAt, DateTime.utc(2026, 10, 29, 9));
  });

  test('redeem kodu gönderir ve işletme kimliğini döner', () async {
    server.handler = (_) =>
        fakePocketBaseJson({'org_id': _orgId, 'role': 'worker'});

    expect(await service.redeem('AR7K2Q'), _orgId);
    expect(server.requests.single.url.path, '/api/app/team/redeem');
    expect(body(server.requests.single), {'code': 'AR7K2Q'});
  });

  test('fetchMemberEmails kullanıcı kimliğine göre harita verir', () async {
    server.handler = (_) => fakePocketBaseJson({
      'members': [
        {'user_id': 'u1', 'email': 'a@x.test'},
        {'user_id': 'u2', 'email': null},
      ],
    });

    expect(await service.fetchMemberEmails(_orgId), {
      'u1': 'a@x.test',
      'u2': null,
    });
    expect(server.requests.single.url.path, '/api/app/team/members');
    expect(body(server.requests.single), {'org_id': _orgId});
  });

  test('setRole ve removeMember kendi route’larına gider', () async {
    await service.setRole(
      orgId: _orgId,
      userId: 'u1',
      role: MembershipRole.viewer,
    );
    await service.removeMember(orgId: _orgId, userId: 'u1');

    expect(server.requests.map((r) => r.url.path), [
      '/api/app/team/set_role',
      '/api/app/team/remove',
    ]);
    expect(body(server.requests[0]), {
      'org_id': _orgId,
      'user_id': 'u1',
      'role': 'viewer',
    });
    expect(body(server.requests[1]), {'org_id': _orgId, 'user_id': 'u1'});
  });

  test('beklenmeyen yanıt bilinmeyen hata', () async {
    server.handler = (_) => fakePocketBaseJson({'org': _orgId});

    await expectLater(
      service.redeem('AR7K2Q'),
      _throwsFailure(TeamFailure.unknown),
    );
  });

  group('hata eşleme: kod data.code’da', () {
    final cases = <(int, String, TeamFailure)>[
      (404, 'invalid_code', TeamFailure.invalidCode),
      (409, 'already_member', TeamFailure.alreadyMember),
      (409, 'owner_locked', TeamFailure.ownerLocked),
      (409, 'member_leaving', TeamFailure.memberLeaving),
      (429, 'too_many_requests', TeamFailure.tooManyAttempts),
      (403, 'forbidden', TeamFailure.forbidden),
      (401, 'unauthorized', TeamFailure.forbidden),
      (500, 'server', TeamFailure.network),
      (502, 'server', TeamFailure.network),
      (400, 'bad_request', TeamFailure.unknown),
      (400, 'bad_role', TeamFailure.unknown),
      (404, 'not_found', TeamFailure.unknown),
    ];
    for (final (status, code, failure) in cases) {
      test('$status $code → ${failure.name}', () async {
        server.handler = (_) => fakePocketBaseAppError(status, code);
        await expectLater(service.redeem('AR7K2Q'), _throwsFailure(failure));
      });
    }

    test('Edge Function biçimindeki `error` okunmaz', () async {
      server.handler = (_) =>
          fakePocketBaseJson({'error': 'already_member'}, 409);
      await expectLater(
        service.redeem('AR7K2Q'),
        _throwsFailure(TeamFailure.unknown),
      );
    });

    test('bağlantı hatası ve zaman aşımı ağ hatası (durum 0)', () async {
      server.handler = (_) => throw const SocketException('offline');
      await expectLater(
        service.createInvite(orgId: _orgId, role: MembershipRole.worker),
        _throwsFailure(TeamFailure.network),
      );

      server.handler = (_) => Completer<http.Response>().future;
      await expectLater(
        service.fetchMemberEmails(_orgId),
        _throwsFailure(TeamFailure.network),
      );
    });
  });
}
