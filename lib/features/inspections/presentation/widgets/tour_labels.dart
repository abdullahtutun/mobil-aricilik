import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/inspections/domain/tour_rules.dart';

/// Turun süresi: "38 dk", saati geçince "1 sa 52 dk".
String tourDuration(AppLocalizations l10n, Duration duration) {
  final minutes = duration.inMinutes < 0 ? 0 : duration.inMinutes;
  return minutes < Duration.minutesPerHour
      ? l10n.tourMinutes(minutes)
      : l10n.tourHoursMinutes(
          minutes ~/ Duration.minutesPerHour,
          minutes % Duration.minutesPerHour,
        );
}

extension TourHiveStateLabel on TourHiveState {
  String label(AppLocalizations l10n) => switch (this) {
    TourHiveState.done => l10n.tourStateDone,
    TourHiveState.skipped => l10n.tourStateSkipped,
    TourHiveState.pending => l10n.tourStatePending,
  };
}

/// Önerilen görevin başlığı ("Ana ver: 103, 117"); çok kovanda ilk
/// [maxTourTaskNumbers] numara ve "+N".
String tourTaskTitle(AppLocalizations l10n, TourTaskSuggestion suggestion) {
  final (:shown, :more) = tourTaskNumbers(suggestion.hives);
  final list = shown.join(l10n.listSeparator);
  final numbers = more == 0 ? list : l10n.tourTaskMoreNumbers(list, more);
  return switch (suggestion.kind) {
    TourTaskKind.requeen => l10n.tourTaskRequeen(numbers),
    TourTaskKind.feedWeak => l10n.tourTaskFeedWeak(numbers),
    TourTaskKind.swarmCheck => l10n.tourTaskSwarmCheck(numbers),
    TourTaskKind.revisitSkipped => l10n.tourTaskRevisit(numbers),
  };
}
