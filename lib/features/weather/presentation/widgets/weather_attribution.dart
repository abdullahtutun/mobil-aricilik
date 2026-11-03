import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/url_launcher_service_provider.dart';

/// WeatherAPI.com'un istediği atıf: "Powered by WeatherAPI.com",
/// sağlayıcının adı sitesine bağlantı. Hava görünen her yerde; metin her
/// dilde aynı. Dokunma hedefi en az `touchTargets.field` (56dp).
class WeatherAttribution extends ConsumerWidget {
  const new({super.key});

  static final Uri url = Uri.parse('https://www.weatherapi.com/');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final style = context.typography.bodySmall.copyWith(
      color: colors.textSecondary,
    );

    return Semantics(
      link: true,
      child: InkWell(
        onTap: () => ref.read(urlLauncherServiceProvider).open(url),
        borderRadius: BorderRadius.circular(context.radii.small),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: 1,
            child: Text.rich(
              TextSpan(
                text: l10n.weatherAttributionPrefix,
                children: [
                  TextSpan(
                    text: l10n.weatherAttributionLink,
                    style: style.copyWith(
                      color: colors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: colors.primary,
                    ),
                  ),
                ],
              ),
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
