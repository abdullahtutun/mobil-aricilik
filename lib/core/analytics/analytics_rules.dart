/// Gizlilik dostu kullanım olayları (teknik.md §11 "İzleme"). Olaylarda
/// kimlik (kullanıcı, işletme, kovan), serbest metin ya da konum yok;
/// yalnız sayılar, evet/hayır ve sabit enum değerleri.
enum AnalyticsEvent {
  /// Hızlı muayene kaydedildi: formun açık kaldığı süre.
  inspectionSaved('inspection_saved'),

  /// Okut ekranı kapandı: kovan bulundu, kod tanınmadı ya da vazgeçildi.
  scanFinished('scan_finished'),

  /// Senkron gönderimi bitti: bekleyen kaydın sunucuya ulaşma gecikmesi.
  syncPushed('sync_pushed');

  new(this.value);

  /// Sunucudaki `analytics_events.name`.
  final String value;
}

/// Kuyrukta en fazla bu kadar olay bekler; fazlası en eskiden silinir.
const analyticsQueueLimit = 1000;

/// Tek istekte gönderilen olay sayısı.
const analyticsBatchSize = 200;

/// Süreler bu değerde kesilir; telefonda açık unutulan ekran ortalamayı
/// bozmasın.
const analyticsMaxDuration = Duration(hours: 24);

final _propKey = RegExp(r'^[a-z][a-z_]{0,31}$');
final _enumValue = RegExp(r'^[a-z][a-z_]{0,31}$');

/// Olay değerlerinden yalnız gizlilik açısından güvenli olanları bırakır:
/// anahtar küçük harf ve alt çizgi; değer sayı (sonlu), evet/hayır ya da
/// enum biçiminde kısa metin (`found`, `cancelled`). Serbest metin, boşluk,
/// rakam ya da büyük harf içeren metin (ad, kod, kimlik) atılır.
Map<String, Object> sanitizeAnalyticsProps(Map<String, Object?> props) => {
  for (final MapEntry(:key, :value) in props.entries)
    if (_propKey.hasMatch(key)) key: ?_safeValue(value),
};

Object? _safeValue(Object? value) => switch (value) {
  final bool flag => flag,
  final int number => number,
  final double number when number.isFinite => number,
  final String text when _enumValue.hasMatch(text) => text,
  _ => null,
};

/// Süre, tam saniye olarak; [analyticsMaxDuration]'da kesilir, eksi süre
/// (saat geri alındıysa) sıfır olur.
int durationSeconds(Duration duration) {
  if (duration.isNegative) return 0;
  final capped = duration > analyticsMaxDuration
      ? analyticsMaxDuration
      : duration;
  return (capped.inMilliseconds / 1000).round();
}
