import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
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
      TeamFailure.unknown => l10n.teamErrorUnknown,
    };
