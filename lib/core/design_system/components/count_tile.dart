import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_card.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Sayı karosu (Bugün'deki "Dikkat isteyenler", tur özeti): büyük sayı ve
/// altında ad. [status] verilirse durumun zemininde, sayı durum renginde
/// ve adın önünde durumun ikonu; yoksa nötr. [onTap] verilirse
/// dokunulabilir. Ekran okuyucu karoyu tek parça okur.
class CountTile extends StatelessWidget {
  const new({
    required this.count,
    required this.label,
    super.key,
    this.status,
    this.onTap,
  });

  final int count;
  final String label;
  final AppStatus? status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final status = this.status;
    final color = status?.colorIn(colors) ?? colors.textSecondary;

    return MergeSemantics(
      child: AppCard(
        status: status,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: context.typography.numberLarge.copyWith(color: color),
                ),
                SizedBox(height: spacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (status != null) ...[
                      Icon(
                        status.icon,
                        size: context.sizes.iconSmall,
                        color: color,
                      ),
                      SizedBox(width: spacing.xs),
                    ],
                    Flexible(
                      child: Text(label, style: context.typography.subtitle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
