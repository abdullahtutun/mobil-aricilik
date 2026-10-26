import 'package:mobil_arici/core/services/app_info_service.dart';

/// Mesajın en uzun hâli; sunucudaki CHECK ile aynı.
const feedbackMessageMaxLength = 4000;

/// Gönderilecek mesaj: baştaki ve sondaki boşluk atılır. Boşsa ya da
/// [feedbackMessageMaxLength]'i aşıyorsa null; Gönder kapalı kalır.
String? feedbackMessage(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty || trimmed.length > feedbackMessageMaxLength) {
    return null;
  }
  return trimmed;
}

/// Ekran görüntüsünün `feedback` bucket'ındaki yolu; sunucudaki CHECK ve
/// Storage politikası bu biçimi bekler.
String feedbackScreenshotPath({required String orgId, required String id}) =>
    '$orgId/$id.jpg';

/// "Cihaz ve sürüm bilgisini ekle" seçiliyse görüşe eklenen bilgi; kimlik
/// (cihaz kimliği, e-posta) içermez.
Map<String, String> feedbackDeviceInfo(
  AppInfo info, {
  required String locale,
}) => {
  'app_version': info.appVersion,
  'platform': info.platform,
  'os_version': info.osVersion,
  'model': info.model,
  'locale': locale,
};
