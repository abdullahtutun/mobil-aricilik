import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/services/place_search_service.dart';

void main() {
  group('NominatimPlaceSearchService', () {
    test('ülkeyle sınırlı sorar, adı ve sınır kutusunu okur', () async {
      late http.Request sent;
      final service = NominatimPlaceSearchService(
        MockClient((request) async {
          sent = request;
          return http.Response.bytes(
            utf8.encode(
              jsonEncode([
                {
                  'lat': '39.2611',
                  'lon': '38.4950',
                  'name': 'Kemaliye',
                  'display_name': 'Kemaliye, Erzincan, Türkiye',
                  'boundingbox': ['38.9', '39.5', '38.1', '38.9'],
                },
                {
                  'lat': '39.75',
                  'lon': '39.49',
                  'name': '',
                  'display_name': 'Erzincan, Türkiye',
                },
              ]),
            ),
            200,
          );
        }),
      );

      final results = await service.search(
        'Kemaliye',
        languageCode: 'tr',
        countryCode: 'TR',
      );

      expect(sent.url.host, NominatimPlaceSearchService.host);
      expect(sent.url.queryParameters, {
        'q': 'Kemaliye',
        'format': 'jsonv2',
        'limit': '${NominatimPlaceSearchService.resultLimit}',
        'accept-language': 'tr',
        'countrycodes': 'tr',
      });
      expect(
        sent.headers['User-Agent'],
        NominatimPlaceSearchService.defaultUserAgent,
      );
      expect(results, [
        const PlaceResult(
          name: 'Kemaliye',
          displayName: 'Kemaliye, Erzincan, Türkiye',
          latitude: 39.2611,
          longitude: 38.495,
          bounds: PlaceBounds(south: 38.9, north: 39.5, west: 38.1, east: 38.9),
        ),
        // Adı boş gelen yer tam adın ilk parçasıyla.
        const PlaceResult(
          name: 'Erzincan',
          displayName: 'Erzincan, Türkiye',
          latitude: 39.75,
          longitude: 39.49,
        ),
      ]);
    });

    test('ağ hatası, HTTP hatası ve bozuk yanıt aranamadı olur', () async {
      for (final handler in <MockClientHandler>[
        (_) async => throw http.ClientException('internet yok'),
        (_) async => http.Response('', 503),
        (_) async => http.Response('{"hata": 1}', 200),
      ]) {
        final service = NominatimPlaceSearchService(MockClient(handler));
        await expectLater(
          service.search('Kemaliye', languageCode: 'tr'),
          throwsA(isA<PlaceSearchUnavailable>()),
        );
      }
    });
  });
}
