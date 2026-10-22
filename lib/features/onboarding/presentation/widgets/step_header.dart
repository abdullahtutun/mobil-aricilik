import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';

/// Adımın sorusu ve altında kısa açıklaması.
class StepHeader extends StatelessWidget {
  const new({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: context.typography.headline),
        ),
        SizedBox(height: context.spacing.sm),
        Text(
          message,
          style: context.typography.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
