import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Şu anki havası olmayan arılığın şeritteki kartı. Konumsuzsa ad,
/// "Konum yok" ve yazma yetkisi varsa "Hava için konum ekle"; dokununca
/// düzenleme formu açılır, yetki yoksa dokunulmaz. Konumluysa (tahmin henüz
/// gelmedi) "Hava bilgisi yok · Bağlantı gelince gelir"; dokununca arılığın
/// hava ekranı açılır. Ekran okuyucu kartı tek öğe olarak okur.
class ApiaryNoWeatherCard extends ConsumerWidget {
  const new({required this.apiary, super.key});

  final Apiary apiary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final typography = context.typography;
    final colors = context.colors;
    final hasLocation = apiary.latitude != null;
    final canWrite = ref.watch(canWriteRecordsProvider);
    final hint = hasLocation
        ? l10n.weatherPendingHint
        : (canWrite ? l10n.weatherNoLocationAction : null);
    final onTap = hasLocation
        ? () => context.push(AppRoutes.apiaryWeather(apiary.id))
        : (canWrite
              ? () => context.push(AppRoutes.apiaryEdit(apiary.id))
              : null);

    return MergeSemantics(
      child: AppCard(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(apiary.name, style: typography.subtitle),
                SizedBox(height: spacing.sm),
                Row(
                  children: [
                    Icon(
                      hasLocation
                          ? Icons.cloud_off_outlined
                          : Icons.location_off_rounded,
                      size: context.sizes.icon,
                      color: colors.textSecondary,
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Text(
                        hasLocation
                            ? l10n.weatherEmptyTitle
                            : l10n.weatherNoLocationTitle,
                        style: typography.body,
                      ),
                    ),
                  ],
                ),
                if (hint != null) ...[
                  SizedBox(height: spacing.sm),
                  Text(
                    hint,
                    style: typography.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
