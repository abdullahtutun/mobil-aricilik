import 'package:connectivity_plus/connectivity_plus.dart';

/// Ağ bağlantısının geri gelişi ve türü. connectivity_plus yalnız bir ağ
/// arayüzünün (Wi‑Fi, mobil veri) bağlı olduğunu söyler, internete gerçekten
/// ulaşılıp ulaşılmadığını değil; ulaşılamazsa senkron yeniden dener.
abstract interface class ConnectivityService {
  /// Bağlantı yokken geri gelince bir olay.
  Stream<void> get reconnected;

  /// Kotasız ağa (Wi‑Fi, kablolu) her geçişte bir olay; "sadece Wi‑Fi'da
  /// yükle" seçiliyken bekleyen medya bununla yüklenir.
  Stream<void> get unmeteredConnected;

  /// Şu an kotasız ağda mı (mobil veri harcanmaz).
  Future<bool> isUnmetered();
}

class PlusConnectivityService implements ConnectivityService {
  new([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Stream<void> get reconnected => reconnections(
    _connectivity.onConnectivityChanged.map(
      (results) => results.any((result) => result != ConnectivityResult.none),
    ),
  );

  @override
  Stream<void> get unmeteredConnected =>
      reconnections(_connectivity.onConnectivityChanged.map(_unmetered));

  @override
  Future<bool> isUnmetered() async =>
      _unmetered(await _connectivity.checkConnectivity());

  static bool _unmetered(List<ConnectivityResult> results) => results.any(
    (result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet,
  );
}

/// [online] akışında çevrimdışından çevrimiçine her geçişte bir olay. İlk
/// değer geçiş sayılmaz: abone olununca bildirilen o anki durumdur.
Stream<void> reconnections(Stream<bool> online) async* {
  bool? previous;
  await for (final value in online) {
    if (previous == false && value) yield null;
    previous = value;
  }
}
