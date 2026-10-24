import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_card.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Ekranı bölümlere ayıran kart: isteğe bağlı başlık ve içerik.
class SectionCard extends StatelessWidget {
  const new({required this.child, super.key, this.title});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final title = this.title;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Semantics(
                header: true,
                child: Text(title, style: context.typography.subtitle),
              ),
              SizedBox(height: spacing.md),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
