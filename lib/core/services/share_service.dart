import 'package:share_plus/share_plus.dart';

/// Metni sistemin paylaşma sayfasıyla telefondan çıkarır (WhatsApp, SMS,
/// e-posta); ağ gerekmez.
abstract interface class ShareService {
  Future<void> shareText(String text, {String? subject});
}

class SharePlusShareService implements ShareService {
  const new();

  @override
  Future<void> shareText(String text, {String? subject}) =>
      SharePlus.instance.share(ShareParams(text: text, subject: subject));
}
