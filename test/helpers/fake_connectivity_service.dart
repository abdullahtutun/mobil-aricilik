import 'dart:async';

import 'package:mobil_arici/core/services/connectivity_service.dart';

/// Ağ olayları elle verilir; [unmetered] o anki ağın Wi‑Fi olup olmadığı.
class FakeConnectivityService implements ConnectivityService {
  final _reconnected = StreamController<void>.broadcast();
  final _unmeteredConnected = StreamController<void>.broadcast();

  bool unmetered = true;

  void reconnect() => _reconnected.add(null);

  /// Wi‑Fi'a geçer.
  void connectUnmetered() {
    unmetered = true;
    _unmeteredConnected.add(null);
  }

  @override
  Stream<void> get reconnected => _reconnected.stream;

  @override
  Stream<void> get unmeteredConnected => _unmeteredConnected.stream;

  @override
  Future<bool> isUnmetered() async => unmetered;
}
