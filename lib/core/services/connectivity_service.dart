import 'package:connectivity_plus/connectivity_plus.dart';

/// Ağ bağlantısının geri gelişi. connectivity_plus yalnız bir ağ
/// arayüzünün (Wi‑Fi, mobil veri) bağlı olduğunu söyler, internete gerçekten
/// ulaşılıp ulaşılmadığını değil; ulaşılamazsa senkron yeniden dener.
abstract interface class ConnectivityService {
  /// Bağlantı yokken geri gelince bir olay.
  Stream<void> get reconnected;
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
