import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/place_search_service.dart';
import 'package:mobil_arici/core/services/place_search_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_search_controller.g.dart';

/// Harita seçicideki il, ilçe ve yer araması. Durum null: henüz aranmadı ya
/// da arama temizlendi. Sonuçlar işletmenin ülkesiyle sınırlı.
@riverpod
class PlaceSearchController extends _$PlaceSearchController {
  /// Son aramanın sırası; eskiyen aramanın sonucu yok sayılır.
  int _request = 0;

  @override
  AsyncValue<List<PlaceResult>>? build() => null;

  /// Boş sorgu aramayı temizler.
  Future<void> search(String query, {required String languageCode}) async {
    final trimmed = query.trim();
    final request = ++_request;
    if (trimmed.isEmpty) {
      state = null;
      return;
    }
    state = const AsyncLoading<List<PlaceResult>>();
    final countryCode = ref.read(regionConfigProvider).countryCode;
    try {
      final results = await ref
          .read(placeSearchServiceProvider)
          .search(
            trimmed,
            languageCode: languageCode,
            countryCode: countryCode,
          );
      if (!ref.mounted || request != _request) return;
      state = AsyncData(results);
    } on PlaceSearchUnavailable catch (error, stackTrace) {
      if (!ref.mounted || request != _request) return;
      state = AsyncError<List<PlaceResult>>(error, stackTrace);
    }
  }

  /// Sonuç listesini kapatır (ör. bir sonuç seçilince).
  void clear() {
    _request++;
    state = null;
  }
}
