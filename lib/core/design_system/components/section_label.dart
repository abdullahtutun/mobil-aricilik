import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';
import 'package:mobil_arici/core/utils/app_format.dart';

/// Bölüm başlığı: küçük, kalın, büyük harf ("ANA ARI", "GENEL"). Büyük harf
/// uygulamanın dilinin kuralıyla yapılır; ekran okuyucu metni olduğu gibi
/// okur. [status] verilirse durum renginde yazar (ör. "SORUN · 1"); anlamı
/// kelimesi taşır.
class SectionLabel extends StatelessWidget {
  const new(this.text, {super.key, this.status});

  final String text;
  final AppStatus? status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      header: true,
      child: Text(
        AppFormat.of(context).upperCase(text),
        semanticsLabel: text,
        style: context.typography.labelSmall.copyWith(
          color: status?.colorIn(colors) ?? colors.textSecondary,
        ),
      ),
    );
  }
}
