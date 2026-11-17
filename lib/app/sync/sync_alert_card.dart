import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';

/// Senkronun kullanıcıdan bir şey beklediği durumun kartı: durum ikonu,
/// başlık ve tek cümle. Renk tek başına anlam taşımaz; ikon ve kelime
/// birlikte. [onTap] verilirse kart dokunulabilir (Bugün'de senkron
/// ekranını açar).
class SyncAlertCard extends StatelessWidget {
  const new({
    required this.status,
    required this.title,
    required this.message,
    super.key,
    this.onTap,
  });

  final AppStatus status;
  final String title;
  final String message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return MergeSemantics(
      child: AppCard(
        status: status,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                status.icon,
                size: context.sizes.icon,
                color: status.colorIn(context.colors),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.typography.label),
                    SizedBox(height: spacing.xs),
                    Text(message, style: context.typography.body),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
