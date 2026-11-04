import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/services/place_search_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_search_service_provider.g.dart';

/// Haritada yer araması; testler ağsız sahteyle override eder.
@Riverpod(keepAlive: true)
PlaceSearchService placeSearchService(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return NominatimPlaceSearchService(client);
}
