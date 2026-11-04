import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;

part 'place_search_service.freezed.dart';

/// Yer araması sonucu: il, ilçe, köy ya da başka bir yer adı.
@freezed
abstract class PlaceResult with _$PlaceResult {
  const factory({
    /// Kısa ad (ör. "Kemaliye").
    required String name,

    /// Bağlı olduğu yerlerle tam ad (ör. "Kemaliye, Erzincan, Türkiye").
    required String displayName,
    required double latitude,
    required double longitude,

    /// Yerin sınır kutusu (güney, kuzey, batı, doğu); harita yeri bütün
    /// gösterecek kadar yakınlaşır. Bilinmiyorsa null.
    PlaceBounds? bounds,
  }) = _PlaceResult;
}

@freezed
abstract class PlaceBounds with _$PlaceBounds {
  const factory({
    required double south,
    required double north,
    required double west,
    required double east,
  }) = _PlaceBounds;
}

/// Arama yapılamadı: internet yok, sunucuya ulaşılamadı ya da yanıt
/// okunamadı.
class PlaceSearchUnavailable implements Exception {
  const new(this.cause);

  final Object cause;

  @override
  String toString() => 'PlaceSearchUnavailable($cause)';
}

/// Yer adından konum arar. Ağa giden çağrı; ekranlar buna provider
/// üzerinden ulaşır.
abstract interface class PlaceSearchService {
  /// [countryCode] (ISO 3166-1 alpha-2) doluysa sonuçlar o ülkeyle sınırlı.
  /// Adlar [languageCode] dilinde gelir. Hata [PlaceSearchUnavailable]
  /// olarak gelir.
  Future<List<PlaceResult>> search(
    String query, {
    required String languageCode,
    String? countryCode,
  });
}

/// OpenStreetMap Nominatim. Hesap ve anahtar istemez; kullanım koşulları
/// gereği uygulamayı tanıtan [userAgent] gönderilir ve yazarken değil
/// yalnız arama tuşuna basılınca sorgulanır.
class NominatimPlaceSearchService implements PlaceSearchService {
  new(this._client, {this.userAgent = defaultUserAgent});

  final http.Client _client;
  final String userAgent;

  static const defaultUserAgent = 'MobilArici-place-search/1.0';
  static const host = 'nominatim.openstreetmap.org';
  static const resultLimit = 8;
  static const timeout = Duration(seconds: 15);

  @override
  Future<List<PlaceResult>> search(
    String query, {
    required String languageCode,
    String? countryCode,
  }) async {
    final uri = Uri.https(host, '/search', {
      'q': query,
      'format': 'jsonv2',
      'limit': '$resultLimit',
      'accept-language': languageCode,
      if (countryCode != null) 'countrycodes': countryCode.toLowerCase(),
    });
    final http.Response response;
    try {
      response = await _client
          .get(uri, headers: {'User-Agent': userAgent})
          .timeout(timeout);
    } on Object catch (error) {
      throw PlaceSearchUnavailable(error);
    }
    if (response.statusCode != 200) {
      throw PlaceSearchUnavailable('HTTP ${response.statusCode}');
    }
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<Object?>;
      return [
        for (final item in body.cast<Map<String, Object?>>()) _parse(item),
      ];
    } on Object catch (error) {
      throw PlaceSearchUnavailable(error);
    }
  }

  static PlaceResult _parse(Map<String, Object?> item) {
    final displayName = item['display_name']! as String;
    final name = item['name'] as String?;
    final box = (item['boundingbox'] as List<Object?>?)
        ?.map((value) => double.parse(value! as String))
        .toList();
    return PlaceResult(
      name: name == null || name.isEmpty
          ? displayName.split(',').first.trim()
          : name,
      displayName: displayName,
      latitude: double.parse(item['lat']! as String),
      longitude: double.parse(item['lon']! as String),
      bounds: box != null && box.length == 4
          ? PlaceBounds(
              south: box[0],
              north: box[1],
              west: box[2],
              east: box[3],
            )
          : null,
    );
  }
}
