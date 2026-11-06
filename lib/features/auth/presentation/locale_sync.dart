import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderListenableSelect;
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_sync.g.dart';

/// Arayüz dilini oturumdaki kullanıcının hesabına yazar; görev bildirimi
/// ve hesap e-postaları gibi sunucunun gönderdikleri bu dilde gider. Giriş
/// yapılınca ve dil değişince çalışır; çevrimdışıysa sessizce vazgeçer,
/// sonraki açılışta yeniden dener.
@Riverpod(keepAlive: true)
void localeSync(Ref ref) {
  if (ref.watch(currentUserProvider.select((user) => user?.id)) == null) {
    return;
  }
  final locale =
      ref.watch(languageProvider).locale ??
      resolveAppLocale(
        PlatformDispatcher.instance.locales,
        AppLocalizations.supportedLocales,
      );
  unawaited(ref.read(authServiceProvider).updateLocale(locale.languageCode));
}
