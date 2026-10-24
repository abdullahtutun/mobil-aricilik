import 'dart:math' as math;

import 'package:mobil_arici/features/media/domain/media_item.dart';

/// `media` bucket'ındaki yol: `org_id/hive_id/id.jpg|m4a`. Sunucu aynı
/// kuralı CHECK ile denetler.
String mediaStoragePath({
  required String orgId,
  required String hiveId,
  required String id,
  required MediaKind kind,
}) => '$orgId/$hiveId/$id.${kind.extension}';

/// Başka telefonda çekilen medyanın indirilince bu telefondaki dosya adı.
String downloadFileName(MediaItem media) =>
    '${media.id}.${media.kind.extension}';

/// Fotoğrafı uzun kenarı [maxEdge] olacak şekilde küçültmek için
/// sıkıştırıcıya verilecek kısa kenar.
///
/// Sıkıştırıcı (flutter_image_compress) iki platformda da kısa kenarı
/// verilen değere indirir. Oran döndürmeyle değişmediği için EXIF yönü
/// bilinmeden hesaplanabilir. Görüntü zaten küçükse kısa kenarın kendisi
/// döner; büyütme yapılmaz.
int compressShortEdge(int width, int height, {int maxEdge = maxPhotoEdge}) {
  final long = math.max(width, height);
  final short = math.min(width, height);
  if (long <= maxEdge) return short;
  return math.max(1, (short * maxEdge / long).round());
}

/// Yükleme denemeleri arasındaki bekleme: 30 sn'den başlar, her başarısız
/// denemede ikiye katlanır, en çok 6 saat. [attempts] o ana kadarki
/// başarısız deneme sayısı (1'den başlar).
Duration uploadBackoff(int attempts) {
  const first = Duration(seconds: 30);
  const max = Duration(hours: 6);
  final exponent = math.min(math.max(attempts - 1, 0), 20);
  final delay = first * (1 << exponent);
  return delay > max ? max : delay;
}

/// Sesli notun süresi "0:07", "12:30" biçiminde.
String formatVoiceDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}
