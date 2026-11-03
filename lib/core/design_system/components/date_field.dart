import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Metin alanı görünümünde tarih; dokununca [onTap] (genelde takvim) açılır.
/// Adı `LabeledField` ile üstte verilir.
class DateField extends StatelessWidget {
  const new({required this.text, required this.onTap, super.key});

  /// Biçimlenmiş tarih (`AppFormat.date`).
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.radii.button),
        child: InputDecorator(
          decoration: const InputDecoration(),
          child: Text(text, style: context.typography.body),
        ),
      ),
    );
  }
}
