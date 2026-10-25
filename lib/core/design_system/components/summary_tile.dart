import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_card.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/components/section_label.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Özet karosu (kovan kartı, arılık): küçük büyük harfli etiket, büyük
/// değer ve altında ayrıntı. [status] verilirse durumun zemininde,
/// etiketi durum renginde ve önünde durumun ikonu. [onTap] verilirse karo
/// dokunulabilir (ör. tarihi değiştirmek). Ekran okuyucu karoyu tek parça
/// okur.
class SummaryTile extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    super.key,
    this.detail,
    this.status,
    this.onTap,
  });

  final String label;
  final String value;
  final String? detail;
  final AppStatus? status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final detail = this.detail;
    final status = this.status;

    return MergeSemantics(
      child: AppCard(
        status: status,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (status == null)
                SectionLabel(label)
              else
                // Durum yalnız renkle değil ikonuyla da görünsün.
                Row(
                  children: [
                    Icon(
                      status.icon,
                      size: context.sizes.iconSmall,
                      color: status.colorIn(context.colors),
                    ),
                    SizedBox(width: spacing.xs),
                    Flexible(child: SectionLabel(label, status: status)),
                  ],
                ),
              SizedBox(height: spacing.xs),
              Text(value, style: context.typography.title),
              if (detail != null) ...[
                SizedBox(height: spacing.xs),
                Text(
                  detail,
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
