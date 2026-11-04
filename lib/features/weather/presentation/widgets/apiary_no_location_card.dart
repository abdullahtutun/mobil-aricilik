import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Konumu olmayan arılığın şeritteki kartı: ad, "Konum yok" ve yazma yetkisi
/// varsa "Hava için konum ekle". Dokununca arılığın düzenleme formu açılır;
/// yetki yoksa dokunulmaz. Ekran okuyucu kartı tek öğe olarak okur.
class ApiaryNoLocationCard extends ConsumerWidget {
  const new({required this.apiary, super.key});

  final Apiary apiary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final typography = context.typography;
    final colors = context.colors;
    final canWrite = ref.watch(canWriteRecordsProvider);

    return MergeSemantics(
      child: AppCard(
        onTap: canWrite
            ? () => context.push(AppRoutes.apiaryEdit(apiary.id))
            : null,
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
                      Icons.location_off_rounded,
                      size: context.sizes.icon,
                      color: colors.textSecondary,
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Text(
                        l10n.weatherNoLocationTitle,
                        style: typography.body,
                      ),
                    ),
                  ],
                ),
                if (canWrite) ...[
                  SizedBox(height: spacing.sm),
                  Text(
                    l10n.weatherNoLocationAction,
                    style: typography.body.copyWith(
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
