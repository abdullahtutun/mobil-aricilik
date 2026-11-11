import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/features/organization/data/pocketbase_organization_service.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';

import '../../../helpers/fake_pocketbase_api.dart';
import '../../../helpers/fake_pocketbase_files.dart';

const _organization = Organization(
  id: '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a',
  name: 'Petek Arıcılık',
  countryCode: 'DE',
  currency: 'EUR',
  hiveCountRange: HiveCountRange.upTo200,
);

/// Sunucunun döndüğü satır: pull'daki satır (`RowJSON`), işletmenin bütün
/// kolonlarıyla.
const _row = <String, Object?>{
  'id': '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a',
  'name': 'Petek Arıcılık',
  'country_code': 'DE',
  'currency': 'EUR',
  'hive_count_range': 'up_to_200',
  'operation_type': 'migratory',
  'created_at': '2026-11-12T08:00:00.000000Z',
  'updated_at': '2026-11-12T08:00:00.000000Z',
  'created_by': fakePocketBaseUserId,
  'deleted_at': null,
  'server_seq': 7,
  'tr_registration_no': null,
  'tr_aks_no': null,
};

Matcher _throwsFailure(OrganizationFailure failure) => throwsA(
  isA<OrganizationServiceException>().having(
    (e) => e.failure,
    'failure',
    failure,
  ),
);

void main() {
  late FakePocketBaseApi server;
  late PocketBaseOrganizationService service;

  setUp(() {
    server = FakePocketBaseApi();
    service = PocketBaseOrganizationService(
      server.client(token: 'a.b.c'),
      timeout: const Duration(milliseconds: 200),
    );
  });

  group('fetchCurrent', () {
    test('organizations/mine’ı token’la ister, satırı okur', () async {
      server.handler = (_) => fakePocketBaseJson(_row);

      expect(await service.fetchCurrent(), _organization);

      final request = server.requests.single;
      expect(request.method, 'GET');
      expect(request.url.path, '/api/app/organizations/mine');
      expect(request.headers['Authorization'], 'a.b.c');
    });

    test('işletme yoksa sunucu null döner, servis de null', () async {
      server.handler = (_) => fakePocketBaseJson(null);

      expect(await service.fetchCurrent(), isNull);
    });

    test('kovan sayısı boş olabilir', () async {
      server.handler = (_) =>
          fakePocketBaseJson({..._row, 'hive_count_range': null});

      expect(
        await service.fetchCurrent(),
        _organization.copyWith(hiveCountRange: null),
      );
    });

    test('bağlantı hatası, zaman aşımı ve 5xx ağ hatası', () async {
      final responses = <FutureOr<http.Response> Function()>[
        () => throw const SocketException('çevrimdışı'),
        () => Completer<http.Response>().future,
        () => fakePocketBaseJson({'status': 503, 'message': 'x'}, 503),
        () => fakePocketBaseJson({'status': 429, 'message': 'x'}, 429),
      ];
      for (final response in responses) {
        server.handler = (_) => response();
        await expectLater(
          service.fetchCurrent(),
          _throwsFailure(OrganizationFailure.network),
        );
      }
    });

    test('401 ve beklenmeyen yanıt bilinmeyen hata', () async {
      server.handler = (_) => fakePocketBaseJson({
        'status': 401,
        'message': 'x',
        'data': <String, Object?>{},
      }, 401);
      await expectLater(
        service.fetchCurrent(),
        _throwsFailure(OrganizationFailure.unknown),
      );

      server.handler = (_) => fakePocketBaseJson(['liste']);
      await expectLater(
        service.fetchCurrent(),
        _throwsFailure(OrganizationFailure.unknown),
      );
    });
  });

  group('create', () {
    test('organizations’a POST eder, sunucudaki hâli döner', () async {
      server.handler = (_) =>
          fakePocketBaseJson({..._row, 'name': 'Petek Arıcılık (sunucu)'});

      final created = await service.create(_organization);

      expect(created, _organization.copyWith(name: 'Petek Arıcılık (sunucu)'));
      final request = server.requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, '/api/app/organizations');
      expect(request.headers['Authorization'], 'a.b.c');
      expect(FakePocketBaseApi.body(request), {
        'id': _organization.id,
        'name': 'Petek Arıcılık',
        'country_code': 'DE',
        'currency': 'EUR',
        'hive_count_range': 'up_to_200',
        'operation_type': 'migratory',
      });
    });

    test('sabit işletme türü gider ve yanıttan okunur; kovan sayısı '
        'verilmezse null gider', () async {
      server.handler = (_) => fakePocketBaseJson({
        ..._row,
        'operation_type': 'stationary',
        'hive_count_range': null,
      });

      final created = await service.create(
        _organization.copyWith(
          operationType: OperationType.stationary,
          hiveCountRange: null,
        ),
      );

      final body = FakePocketBaseApi.body(server.requests.single);
      expect(body['operation_type'], 'stationary');
      expect(body.containsKey('hive_count_range'), isTrue);
      expect(body['hive_count_range'], isNull);
      expect(created.operationType, OperationType.stationary);
    });

    test('400 invalid ve 409 conflict bilinmeyen hata', () async {
      for (final (status, code) in [(400, 'invalid'), (409, 'conflict')]) {
        server.handler = (_) => fakePocketBaseAppError(status, code);
        await expectLater(
          service.create(_organization),
          _throwsFailure(OrganizationFailure.unknown),
        );
      }
    });

    test('bağlantı hatası ağ hatası', () async {
      server.handler = (_) => throw http.ClientException('çevrimdışı');

      await expectLater(
        service.create(_organization),
        _throwsFailure(OrganizationFailure.network),
      );
    });
  });
}
