import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/features/weather/data/pocketbase_weather_service.dart';
import 'package:mobil_arici/features/weather/data/weather_service.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';

import '../../../helpers/fake_pocketbase_api.dart';
import '../../../helpers/fake_pocketbase_files.dart';
import '../../../helpers/fake_weather_service.dart';

final _bundle = WeatherBundle(
  generatedAt: DateTime.utc(2026, 11, 12, 8, 0, 0, 0, 123),
  forecasts: [
    ApiaryForecast(
      apiaryId: '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a',
      cell: '37.10,28.39',
      fetchedAt: DateTime.utc(2026, 11, 12, 7, 30),
      forecast: testForecast(at: DateTime.utc(2026, 11, 12, 8)),
    ),
  ],
);

/// Sunucunun gövdesi: `generated_at` ve `fetched_at` K-5 biçiminde
/// (mikrosaniyeli UTC).
Map<String, Object?> _response() {
  final json = jsonDecode(jsonEncode(_bundle.toJson())) as Map<String, Object?>;
  return {
    ...json,
    'generated_at': '2026-11-12T08:00:00.000123Z',
    'forecasts': [
      {
        ...((json['forecasts']! as List).single as Map<String, Object?>),
        'fetched_at': '2026-11-12T07:30:00.000000Z',
      },
    ],
  };
}

Matcher get _throwsWeatherError => throwsA(isA<WeatherServiceException>());

void main() {
  late FakePocketBaseApi server;
  late PocketBaseWeatherService service;

  setUp(() {
    server = FakePocketBaseApi();
    service = PocketBaseWeatherService(
      server.client(token: 'a.b.c'),
      timeout: const Duration(milliseconds: 200),
    );
  });

  test('POST /api/app/weather token’la gider, paketi okur', () async {
    server.handler = (_) => fakePocketBaseJson(_response());

    final bundle = await service.fetchBundle();

    expect(bundle, _bundle);
    final request = server.requests.single;
    expect(request.method, 'POST');
    expect(request.url.path, '/api/app/weather');
    expect(request.headers['Authorization'], 'a.b.c');
  });

  test('arılık yoksa boş paket', () async {
    server.handler = (_) => fakePocketBaseJson({
      'generated_at': '2026-11-12T08:00:00.000000Z',
      'forecasts': <Object?>[],
    });

    expect((await service.fetchBundle()).forecasts, isEmpty);
  });

  test('anahtar yokken 503 config, sağlayıcı hatasında 502 upstream, '
      '401, bağlantı hatası, zaman aşımı ve bozuk yanıt hava hatası', () async {
    final responses = <FutureOr<http.Response> Function()>[
      () => fakePocketBaseAppError(503, 'config'),
      () => fakePocketBaseAppError(502, 'upstream'),
      () => fakePocketBaseJson({'status': 401, 'message': 'x'}, 401),
      () => throw const SocketException('çevrimdışı'),
      () => Completer<http.Response>().future,
      () => fakePocketBaseJson({'forecasts': 'yok'}),
      () => fakePocketBaseJson(null),
    ];
    for (final response in responses) {
      server.handler = (_) => response();
      await expectLater(service.fetchBundle(), _throwsWeatherError);
    }
  });
}
