import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Başlık ile açıklama arasındaki boşluk; ikisi tek cümle gibi akar.
const _titleSeparator = ' ';

/// Kritik kilit: işlemi engelleyen durumu anlatan kart (ör. bekleme
/// süresindeki kovana bal katı). Kritik zeminde kalın kenarlık, kilit ikonu;
/// [title] kalın ve kritik renkte, [message] onun ardından düz yazıyla.
/// Renk tek başına kalmaz: ikon ve kelimeler birlikte. Ekran okuyucu kart
/// çıkınca kendiliğinden okur.
class CriticalLockCard extends StatelessWidget {
  const new({required this.title, required this.message, super.key});

  /// Kısa durum adı ("Bekleme süresinde.").
  final String title;

  /// Neyin neden engellendiği, tek cümle.
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final body = context.typography.body;

    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.statusCriticalContainer,
          borderRadius: BorderRadius.circular(context.radii.button),
          border: Border.all(
            color: colors.statusCritical,
            width: context.strokes.focus,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: context.sizes.icon,
                color: colors.statusCritical,
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: body.copyWith(
                          color: colors.statusCritical,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: _titleSeparator),
                      TextSpan(text: message),
                    ],
                  ),
                  style: body.copyWith(color: colors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
