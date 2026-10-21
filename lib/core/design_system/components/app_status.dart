import 'package:flutter/material.dart';
import 'package:mobil_aricilik/core/design_system/tokens/app_colors.dart';

/// Durum türü. Her durumun ayrı bir ikon şekli var; renk tek başına anlam
/// taşımasın diye ikon ve kelimeyle birlikte gösterilir.
enum AppStatus {
  good(Icons.check_circle_rounded),
  warning(Icons.warning_rounded),
  critical(Icons.error_rounded),
  info(Icons.info_rounded);

  new(this.icon);

  final IconData icon;

  Color colorIn(AppColors colors) {
    return switch (this) {
      AppStatus.good => colors.statusGood,
      AppStatus.warning => colors.statusWarning,
      AppStatus.critical => colors.statusCritical,
      AppStatus.info => colors.statusInfo,
    };
  }
}
