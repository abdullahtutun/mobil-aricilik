import 'package:mobil_arici/core/services/place_search_service.dart';

/// Ağsız yer araması: [results]'u döner ya da [fail] doğruysa internet yokmuş
/// gibi hata atar. Sorguları kaydeder.
class FakePlaceSearchService implements PlaceSearchService {
  new({this.results = const [], this.fail = false});

  List<PlaceResult> results;
  bool fail;
  final queries =
      <({String query, String languageCode, String? countryCode})>[];

  @override
  Future<List<PlaceResult>> search(
    String query, {
    required String languageCode,
    String? countryCode,
  }) async {
    queries.add((
      query: query,
      languageCode: languageCode,
      countryCode: countryCode,
    ));
    if (fail) throw const PlaceSearchUnavailable('çevrimdışı');
    return results;
  }
}
