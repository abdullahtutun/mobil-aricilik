import 'package:mobil_arici/features/hives/domain/hive.dart';

/// Toplu oluşturmada tek seferde en fazla bu kadar kovan; yanlışlıkla
/// "2000" yazılırsa arılık binlerce kovanla dolmasın.
const maxBulkHiveCount = 500;

extension HiveStatusRules on HiveStatus {
  /// Arılığın kovan sayısına giriyor. Sönen, birleşen, satılan ve kaybolan
  /// kovanlar sayılmaz.
  bool get isCounted => this == HiveStatus.active;
}

/// Durum değişikliği onay ister mi: aktif kovan sayısını düşüren her geçiş
/// (aktiften söndü, birleşti, satıldı ya da kayboldu'ya) onaylanır. Öbür
/// geçişler hemen yazılır ve geri alınabilir (teknik.md §10).
bool statusChangeNeedsConfirmation({
  required HiveStatus from,
  required HiveStatus to,
}) => from.isCounted && !to.isCounted;

/// Toplu oluşturmanın kovan numaraları: [start]'tan başlayarak [count]
/// ardışık sayı ("101", 3 → 101, 102, 103). Baştaki sıfırlar korunur
/// ("001" → 001, 002); sayı haneyi aşınca uzar ("99", 2 → 99, 100).
///
/// [start] yalnız rakamdan oluşmalı, [count] 1 ile [maxBulkHiveCount]
/// arasında olmalı; değilse [ArgumentError].
List<String> bulkHiveNumbers({required String start, required int count}) {
  if (!isBulkStartNumber(start)) {
    throw ArgumentError.value(start, 'start', 'yalnız rakam olmalı');
  }
  if (count < 1 || count > maxBulkHiveCount) {
    throw ArgumentError.value(count, 'count', '1–$maxBulkHiveCount arası');
  }
  final first = BigInt.parse(start);
  return [
    for (var i = 0; i < count; i++)
      (first + BigInt.from(i)).toString().padLeft(start.length, '0'),
  ];
}

/// Toplu oluşturmanın başlangıç numarası olabilir: boş değil, yalnız
/// rakam.
bool isBulkStartNumber(String start) => _digits.hasMatch(start);

final _digits = RegExp(r'^[0-9]+$');
