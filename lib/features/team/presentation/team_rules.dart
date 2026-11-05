import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/team/domain/activity_rules.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';

String roleLabel(AppLocalizations l10n, MembershipRole role) => switch (role) {
  MembershipRole.owner => l10n.teamRoleOwner,
  MembershipRole.partner => l10n.teamRolePartner,
  MembershipRole.worker => l10n.teamRoleWorker,
  MembershipRole.viewer => l10n.teamRoleViewer,
};

/// Rolün ne yapabildiğini anlatan tek cümle; owner davetle verilmez.
String roleHint(AppLocalizations l10n, MembershipRole role) => switch (role) {
  MembershipRole.partner => l10n.teamRoleHintPartner,
  MembershipRole.viewer => l10n.teamRoleHintViewer,
  _ => l10n.teamRoleHintWorker,
};

String failureMessage(AppLocalizations l10n, TeamFailure failure) =>
    switch (failure) {
      TeamFailure.network => l10n.teamErrorOffline,
      TeamFailure.invalidCode => l10n.teamErrorInvalidCode,
      TeamFailure.alreadyMember => l10n.teamErrorAlreadyMember,
      TeamFailure.forbidden => l10n.teamErrorForbidden,
      TeamFailure.ownerLocked => l10n.teamErrorOwnerLocked,
      TeamFailure.memberLeaving => l10n.teamErrorMemberLeaving,
      TeamFailure.unknown => l10n.teamErrorUnknown,
    };

/// Akışta görünen kişi adı: e-postanın `@`'den önceki kısmı; e-posta yoksa
/// ya da boşsa null.
String? activityName(String? email) {
  final name = email?.split('@').first.trim();
  return name == null || name.isEmpty ? null : name;
}

String activityText(AppLocalizations l10n, ActivityKind kind, int count) =>
    switch (kind) {
      ActivityKind.inspection => l10n.teamActivityInspection(count),
      ActivityKind.treatment => l10n.teamActivityTreatment(count),
      ActivityKind.feeding => l10n.teamActivityFeeding(count),
      ActivityKind.harvest => l10n.teamActivityHarvest(count),
      ActivityKind.miteCount => l10n.teamActivityMiteCount(count),
      ActivityKind.task => l10n.teamActivityTask(count),
    };

String activityAgeText(
  AppLocalizations l10n,
  AppFormat format,
  DateTime at,
  DateTime now,
) {
  final age = activityAge(at, now);
  return switch (age.unit) {
    ActivityAgeUnit.justNow => l10n.teamActivityJustNow,
    ActivityAgeUnit.minutes => l10n.teamActivityMinutesAgo(age.value),
    ActivityAgeUnit.hours => l10n.teamActivityHoursAgo(age.value),
    ActivityAgeUnit.yesterday => l10n.teamActivityYesterday,
    ActivityAgeUnit.days => l10n.teamActivityDaysAgo(age.value),
    ActivityAgeUnit.date => format.dayMonth(at.toLocal()),
  };
}

/// Owner bu üyenin rolünü değiştirip onu ekipten çıkarabilir mi: kendisi
/// değil, owner değil ve hesabını silmeyi onaylamamış (bekleme süresinde
/// dokunulmaz; sunucu da 409 member_leaving ile reddeder).
bool canChangeMember({
  required bool manage,
  required bool isSelf,
  required MembershipRole role,
  required DateTime? deletionScheduledFor,
}) =>
    manage &&
    !isSelf &&
    role != MembershipRole.owner &&
    deletionScheduledFor == null;
