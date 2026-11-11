import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/team/data/supabase_team_service.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _url = 'http://supabase.test';
const _orgId = '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a';

http.Response _json(Object? body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json'},
);

Matcher _throwsFailure(TeamFailure failure) => throwsA(
  isA<TeamServiceException>().having((e) => e.failure, 'failure', failure),
);

void main() {
  late List<http.Request> requests;
  late FutureOr<http.Response> Function(http.Request) handler;
  late SupabaseClient client;
  late SupabaseTeamService service;

  setUp(() {
    requests = [];
    handler = (_) => _json({});
    client = SupabaseClient(
      _url,
      'anon-key',
      accessToken: () async => 'user-token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return await handler(request);
      }),
    );
    service = SupabaseTeamService(client);
  });

  tearDown(() => client.dispose());

  Map<String, Object?> body(http.Request request) =>
      jsonDecode(request.body) as Map<String, Object?>;

  test('createInvite invite fonksiyonuna rolle istek atar', () async {
    handler = (_) => _json({
      'code': 'AR7K2Q',
      'role': 'worker',
      'expires_at': '2026-10-29T09:00:00.000Z',
    });

    final invite = await service.createInvite(
      orgId: _orgId,
      role: MembershipRole.worker,
    );

    expect(requests.single.url.path, '/functions/v1/invite');
    expect(body(requests.single), {
      'action': 'create',
      'org_id': _orgId,
      'role': 'worker',
    });
    expect(requests.single.headers['Authorization'], 'Bearer user-token');
    expect(invite.code, 'AR7K2Q');
    expect(invite.role, MembershipRole.worker);
    expect(invite.expiresAt, DateTime.utc(2026, 10, 29, 9));
  });

  test('redeem kodu gönderir ve işletme kimliğini döner', () async {
    handler = (_) => _json({'org_id': _orgId, 'role': 'worker'});

    expect(await service.redeem('AR7K2Q'), _orgId);
    expect(body(requests.single), {'action': 'redeem', 'code': 'AR7K2Q'});
  });

  test('fetchMemberEmails kullanıcı kimliğine göre harita verir', () async {
    handler = (_) => _json({
      'members': [
        {'user_id': 'u1', 'email': 'a@x.test'},
        {'user_id': 'u2', 'email': null},
      ],
    });

    expect(await service.fetchMemberEmails(_orgId), {
      'u1': 'a@x.test',
      'u2': null,
    });
  });

  test('setRole ve removeMember eylemlerini gönderir', () async {
    await service.setRole(
      orgId: _orgId,
      userId: 'u1',
      role: MembershipRole.viewer,
    );
    await service.removeMember(orgId: _orgId, userId: 'u1');

    expect(body(requests[0]), {
      'action': 'set_role',
      'org_id': _orgId,
      'user_id': 'u1',
      'role': 'viewer',
    });
    expect(body(requests[1]), {
      'action': 'remove',
      'org_id': _orgId,
      'user_id': 'u1',
    });
  });

  group('hata eşleme', () {
    final cases = <(int, String, TeamFailure)>[
      (404, 'invalid_code', TeamFailure.invalidCode),
      (409, 'already_member', TeamFailure.alreadyMember),
      (409, 'owner_locked', TeamFailure.ownerLocked),
      (403, 'forbidden', TeamFailure.forbidden),
      (401, 'unauthorized', TeamFailure.forbidden),
      (502, 'server', TeamFailure.network),
      (400, 'bad_request', TeamFailure.unknown),
    ];
    for (final (status, error, failure) in cases) {
      test('$status $error → ${failure.name}', () async {
        handler = (_) => _json({'error': error}, status);
        await expectLater(service.redeem('AR7K2Q'), _throwsFailure(failure));
      });
    }

    test('bağlantı hatası ağ hatasıdır', () async {
      handler = (_) => throw const SocketException('offline');
      await expectLater(
        service.createInvite(orgId: _orgId, role: MembershipRole.worker),
        _throwsFailure(TeamFailure.network),
      );
    });
  });
}
