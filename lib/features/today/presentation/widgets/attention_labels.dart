import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';

/// Dikkat grubunun metinleri ve durumu; karo ve liste ekranı aynı yerden
/// alır.
extension AttentionKindLabels on AttentionKind {
  /// Karodaki kısa ad ("Anasız").
  String label(AppLocalizations l10n) => switch (this) {
    AttentionKind.queenless => l10n.attentionQueenless,
    AttentionKind.weak => l10n.attentionWeak,
    AttentionKind.swarming => l10n.attentionSwarming,
    AttentionKind.treatmentRemoval => l10n.attentionTreatmentRemoval,
  };

  /// Liste ekranının başlığı ("Anasız kovanlar").
  String title(AppLocalizations l10n) => switch (this) {
    AttentionKind.queenless => l10n.attentionQueenlessTitle,
    AttentionKind.weak => l10n.attentionWeakTitle,
    AttentionKind.swarming => l10n.attentionSwarmingTitle,
    AttentionKind.treatmentRemoval => l10n.attentionTreatmentRemovalTitle,
  };

  /// Liste ekranında grubun neye göre seçildiği.
  String intro(AppLocalizations l10n) => switch (this) {
    AttentionKind.queenless => l10n.attentionQueenlessIntro,
    AttentionKind.weak => l10n.attentionWeakIntro(weakStrengthMax),
    AttentionKind.swarming => l10n.attentionSwarmingIntro,
    AttentionKind.treatmentRemoval => l10n.attentionTreatmentRemovalIntro,
  };

  /// Kovan varken karonun durumu; renk ikonu ve kelimeyle birlikte.
  AppStatus get status => switch (this) {
    AttentionKind.queenless => AppStatus.critical,
    AttentionKind.weak || AttentionKind.swarming => AppStatus.warning,
    AttentionKind.treatmentRemoval => AppStatus.info,
  };
}
