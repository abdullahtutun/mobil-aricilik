import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show AsyncData;
import 'package:flutter_riverpod/misc.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/core/sync/sync_service_provider.dart';

/// Ağsız senkron servisi: turları sayar, verilen ilerlemeyi bildirir ve
/// [result]'u döner.
class FakeSyncService implements SyncService {
  /// Sonraki turların sonucu.
  SyncResult result = const SyncResult(status: SyncStatus.done);

  /// Tur başında sırayla bildirilir.
  List<SyncProgress> progress = const [];

  /// Doluysa tur bu tamamlanana kadar sürer.
  Completer<void>? gate;

  /// Tur [SyncStatus.done] ile biterken çağrılır (ör. ilk tam çekme
  /// işaretini yazmak için).
  Future<void> Function()? onDone;

  int syncCount = 0;
  Future<SyncResult>? _running;

  @override
  Future<SyncResult> sync({void Function(SyncProgress progress)? onProgress}) =>
      _running ??= _sync(onProgress).whenComplete(() => _running = null);

  Future<SyncResult> _sync(
    void Function(SyncProgress progress)? onProgress,
  ) async {
    syncCount++;
    progress.forEach(onProgress ?? (_) {});
    await gate?.future;
    final result = this.result;
    if (result.status == SyncStatus.done) await onDone?.call();
    return result;
  }

  @override
  Future<SyncResult> push() => throw UnimplementedError();

  @override
  Future<SyncResult> pull({void Function(SyncProgress progress)? onProgress}) =>
      throw UnimplementedError();

  @override
  List<TableInfo<Table, Object?>> get pullTables => throw UnimplementedError();

  @override
  DateTime Function() get clock => DateTime.now;

  @override
  Future<void> Function(Duration duration) get delay => Future.delayed;
}

/// Senkron sahte servisle çalışır. [fullPullDone] doğruysa ilk tam çekme
/// bitmiş sayılır ve router ilk çekme ekranını hiç açmaz; yanlışsa durum
/// yerel DB'den okunur.
List<Override> syncOverrides({
  FakeSyncService? service,
  bool fullPullDone = true,
}) => [
  syncServiceProvider.overrideWithValue(service ?? FakeSyncService()),
  if (fullPullDone)
    fullPullDoneProvider.overrideWithValue(const AsyncData(true)),
];
