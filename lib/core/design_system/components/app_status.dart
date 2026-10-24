import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/tokens/app_colors.dart';

/// Durum türü. Her durumun ayrı bir ikon şekli var (✓, !, ×, i); renk tek
/// başına anlam taşımasın diye ikon ve kelimeyle birlikte gösterilir.
enum AppStatus {
  good(Icons.check_rounded),
  warning(Icons.priority_high_rounded),
  critical(Icons.close_rounded),
  info(Icons.info_outline_rounded);

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

  /// Durumun açık zemini; üstündeki yazı ve ikon [colorIn] rengiyle.
  Color containerIn(AppColors colors) {
    return switch (this) {
      AppStatus.good => colors.statusGoodContainer,
      AppStatus.warning => colors.statusWarningContainer,
      AppStatus.critical => colors.statusCriticalContainer,
      AppStatus.info => colors.statusInfoContainer,
    };
  }
}
