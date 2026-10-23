import 'package:mobil_arici/app/deep_link.dart';

/// Kovan etiketi linkinin ilk parçası: `mobilarici://h/<kimlik>`. Router'da
/// `/h/<kimlik>` olur.
const hiveLabelHost = 'h';

/// Kovan etiketinin QR içeriği: `mobilarici://h/<kovan kimliği>`. Kimlik
/// istemcide üretildiği için offline oluşturulan kovanın etiketi de hemen
/// basılabilir. Telefonun kendi kamerasıyla okutulunca da uygulama açılır.
String hiveLabelCode(String hiveId) =>
    '$deepLinkScheme://$hiveLabelHost/$hiveId';

/// Okunan kod bizim kovan etiketimizse içindeki kovan kimliği (küçük
/// harf), değilse null. Kimlik UUID biçiminde olmalı.
String? hiveIdFromLabelCode(String code) {
  final uri = Uri.tryParse(code.trim());
  if (uri == null ||
      uri.scheme != deepLinkScheme ||
      uri.host != hiveLabelHost ||
      uri.hasQuery ||
      uri.hasFragment) {
    return null;
  }
  final segments = uri.pathSegments;
  if (segments.length != 1 || !_uuid.hasMatch(segments.single)) return null;
  return segments.single.toLowerCase();
}

/// Etiket kodunun saklanan ve aranan biçimi: bizim etiketimizse standart
/// link, değilse baştaki ve sondaki boşlukları atılmış hâli. Aynı etiket
/// her okutmada aynı koda çıkar.
String normalizeLabelCode(String code) => switch (hiveIdFromLabelCode(code)) {
  final hiveId? => hiveLabelCode(hiveId),
  null => code.trim(),
};

final _uuid = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  caseSensitive: false,
);
