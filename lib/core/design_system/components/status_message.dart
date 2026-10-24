import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Durum cümlesi (ör. hata, uyarı): durumun ikonu ve rengiyle birlikte;
/// renk tek başına anlam taşımaz. Ekran okuyucu cümle çıkınca kendiliğinden
/// okur.
class StatusMessage extends StatelessWidget {
  const new({required this.status, required this.message, super.key});

  final AppStatus status;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            status.icon,
            size: context.sizes.icon,
            color: status.colorIn(context.colors),
          ),
          SizedBox(width: context.spacing.sm),
          Expanded(child: Text(message, style: context.typography.body)),
        ],
      ),
    );
  }
}
