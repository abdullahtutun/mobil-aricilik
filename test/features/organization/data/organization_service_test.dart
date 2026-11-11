import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/features/organization/data/supabase_organization_service.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _url = 'http://supabase.test';

const _organization = Organization(
  id: '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a',
  name: 'Petek Arıcılık',
  countryCode: 'DE',
  currency: 'EUR',
  hiveCountRange: HiveCountRange.upTo200,
);

const _row = {
  'id': '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a',
  'name': 'Petek Arıcılık',
  'country_code': 'DE',
  'currency': 'EUR',
  'hive_count_range': 'up_to_200',
};

http.Response _json(Object? body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

typedef _Handler = FutureOr<http.Response> Function(http.Request request);

Matcher _throwsFailure(OrganizationFailure failure) => throwsA(
  isA<OrganizationServiceException>().having(
    (e) => e.failure,
    'failure',
    failure,
  ),
);

void main() {
  group('SupabaseOrganizationService', () {
    late List<http.Request> requests;
    late _Handler handler;
    late SupabaseClient client;
    late SupabaseOrganizationService service;

    setUp(() {
      requests = [];
      handler = (_) => _json(<Object?>[]);
      client = SupabaseClient(
        _url,
        'anon-key',
        accessToken: () async => 'user-token',
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
      service = SupabaseOrganizationService(client);
    });

    tearDown(() => client.dispose());

    group('fetchCurrent', () {
      test('üye olunan en eski, silinmemiş işletmeyi ister', () async {
        handler = (_) => _json([_row]);

        expect(await service.fetchCurrent(), _organization);

        final request = requests.single;
        expect(request.method, 'GET');
        expect(request.url.path, '/rest/v1/organizations');
        expect(request.url.queryParameters, {
          'select':
              'id,name,country_code,currency,hive_count_range,operation_type',
          'deleted_at': 'is.null',
          'order': 'created_at.asc.nullslast',
          'limit': '1',
        });
        expect(request.headers['Authorization'], 'Bearer user-token');
      });

      test('işletme yoksa null döner', () async {
        expect(await service.fetchCurrent(), isNull);
      });

      test('kovan sayısı boş olabilir', () async {
        handler = (_) => _json([
          {..._row, 'hive_count_range': null},
        ]);

        expect(
          await service.fetchCurrent(),
          _organization.copyWith(hiveCountRange: null),
        );
      });

      // Sahte saat: postgrest GET'i ağ hatasında 1, 2 ve 4 sn arayla
      // yeniden dener.
      testWidgets('bağlantı hatası yeniden denemelerden sonra ağ hatasına '
          'çevrilir', (tester) async {
        handler = (_) => throw const SocketException('çevrimdışı');

        final result = expectLater(
          service.fetchCurrent(),
          _throwsFailure(OrganizationFailure.network),
        );
        await tester.pump(const Duration(seconds: 8));
        await result;

        expect(requests, hasLength(4));
      });

      test('sunucu hatası bilinmeyen hataya çevrilir', () async {
        handler = (_) => _json({
          'code': '42501',
          'message': 'permission denied',
          'details': null,
          'hint': null,
        }, 403);

        await expectLater(
          service.fetchCurrent(),
          _throwsFailure(OrganizationFailure.unknown),
        );
      });
    });

    group('create', () {
      test(
        'create_organization RPC’sini çağırır, sunucudaki hâli döner',
        () async {
          handler = (_) => _json({..._row, 'name': 'Petek Arıcılık (sunucu)'});

          final created = await service.create(_organization);

          expect(
            created,
            _organization.copyWith(name: 'Petek Arıcılık (sunucu)'),
          );
          final request = requests.single;
          expect(request.method, 'POST');
          expect(request.url.path, '/rest/v1/rpc/create_organization');
          expect(jsonDecode(request.body), {
            'id': _organization.id,
            'name': 'Petek Arıcılık',
            'country_code': 'DE',
            'currency': 'EUR',
            'hive_count_range': 'up_to_200',
            'operation_type': 'migratory',
          });
        },
      );

      test('sabit işletme türü RPC’ye gider ve yanıttan okunur', () async {
        handler = (_) => _json({..._row, 'operation_type': 'stationary'});

        final created = await service.create(
          _organization.copyWith(operationType: OperationType.stationary),
        );

        expect(
          (jsonDecode(requests.single.body) as Map)['operation_type'],
          'stationary',
        );
        expect(created.operationType, OperationType.stationary);
      });

      test('kovan sayısı verilmezse null gönderilir', () async {
        handler = (_) => _json({..._row, 'hive_count_range': null});

        await service.create(_organization.copyWith(hiveCountRange: null));

        expect(
          (jsonDecode(requests.single.body) as Map)['hive_count_range'],
          isNull,
        );
      });

      test('bağlantı hatası ağ hatasına çevrilir', () async {
        handler = (_) => throw http.ClientException('çevrimdışı');

        await expectLater(
          service.create(_organization),
          _throwsFailure(OrganizationFailure.network),
        );
      });

      test('reddedilen istek bilinmeyen hataya çevrilir', () async {
        handler = (_) => _json({
          'code': '23505',
          'message': 'Bu kimlik başka bir işletmenin',
          'details': null,
          'hint': null,
        }, 409);

        await expectLater(
          service.create(_organization),
          _throwsFailure(OrganizationFailure.unknown),
        );
      });
    });
  });

  group('HiveCountRange', () {
    test('değerler Postgres enum’uyla aynı', () {
      expect(HiveCountRange.values.map((range) => range.value), [
        'none',
        'up_to_10',
        'up_to_50',
        'up_to_200',
        'over_200',
      ]);
    });
  });
}
