import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_card.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/components/section_label.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Özet karosu (kovan kartı, arılık): küçük büyük harfli etiket, büyük
/// değer ve altında ayrıntı. [status] verilirse durumun zemininde ve
/// etiketi durum renginde. Ekran okuyucu karoyu tek parça okur.
class SummaryTile extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    super.key,
    this.detail,
    this.status,
  });

  final String label;
  final String value;
  final String? detail;
  final AppStatus? status;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final detail = this.detail;

    return MergeSemantics(
      child: AppCard(
        status: status,
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel(label, status: status),
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
