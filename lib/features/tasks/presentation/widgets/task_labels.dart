import 'package:flutter/widgets.dart' show StringCharacters;
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing_rules.dart';
import 'package:mobil_arici/features/queens/presentation/widgets/queen_rearing_labels.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

/// Görevin başlığı: elle açılanda yazılan, otomatik görevde kaynaktan
/// ([autoTaskTitle]).
String taskTitle(AppLocalizations l10n, TaskView view) =>
    view.task.source == TaskSource.manual
    ? view.task.title ?? ''
    : autoTaskTitle(
        l10n,
        view.task.source,
        hiveNumber: view.hiveNumber,
        step: view.task.sourceStep,
      );

/// Otomatik görevin başlığı ("Kovan 103 · tekrar bak", arılığın tümünde
/// "Şeritleri çıkar"); ana yetiştirmede takvim gününün ([step]) adımı
/// ("Memeleri dağıt").
String autoTaskTitle(
  AppLocalizations l10n,
  TaskSource source, {
  required String? hiveNumber,
  int? step,
}) => switch ((source, hiveNumber)) {
  (TaskSource.manual, _) => '',
  (TaskSource.inspection, final number?) => l10n.taskInspectionTitle(number),
  (TaskSource.inspection, null) => l10n.taskInspectionTitleNoHive,
  (TaskSource.treatment, final number?) => l10n.taskTreatmentTitle(number),
  (TaskSource.treatment, null) => l10n.taskTreatmentTitleApiary,
  (TaskSource.queenRearing, _) => switch (RearingStep.ofDay(step)) {
    final step? => rearingStepTitle(l10n, step),
    null => l10n.rearingTitle,
  },
  (TaskSource.aksUpdate, _) => l10n.taskAksUpdateTitle,
};

/// Otomatik görevin nereden geldiği ("muayeneden", "ilaç"); elle açılanda
/// null.
String? taskSourceLabel(AppLocalizations l10n, TaskSource source) =>
    switch (source) {
      TaskSource.manual => null,
      TaskSource.inspection => l10n.taskSourceInspection,
      TaskSource.treatment => l10n.taskSourceTreatment,
      TaskSource.queenRearing => l10n.taskSourceQueenRearing,
      TaskSource.aksUpdate => l10n.taskSourceAks,
    };

/// Başlığın altındaki bağlam parçaları: arılık ([withApiary] ise), elle
/// açılan görevde kovan, otomatik görevde kaynak.
List<String> taskContext(
  AppLocalizations l10n,
  TaskView view, {
  bool withApiary = true,
}) {
  final number = view.hiveNumber;
  return [
    if (withApiary) ?view.apiaryName,
    if (view.task.source == TaskSource.manual && number != null)
      l10n.hiveLabel(number),
    ?taskSourceLabel(l10n, view.task.source),
  ];
}

/// Bildirimin metni: bağlam ("Kızılçam · ilaç"); bağlam yoksa genel metin.
String taskNotificationBody(AppLocalizations l10n, TaskView view) {
  final context = taskContext(l10n, view);
  return context.isEmpty ? l10n.taskReminderBody : context.join(' · ');
}

/// Üyenin rolü.
String membershipRoleLabel(AppLocalizations l10n, MembershipRole role) =>
    switch (role) {
      MembershipRole.owner => l10n.roleOwner,
      MembershipRole.partner => l10n.rolePartner,
      MembershipRole.worker => l10n.roleWorker,
      MembershipRole.viewer => l10n.roleViewer,
    };

/// Görev atanabilecek kişi: kullanıcı kimliği ve adı. Adlar henüz yok;
/// oturumdaki kullanıcı "Ben", diğerleri rolüyle, aynı rolden birden
/// fazlaysa sırayla numaralı ("İşçi 2").
typedef TaskAssignee = ({String userId, String label, String badge});

/// [members] arasından atanabilecekler: önce [userId] ("Ben"), sonra
/// diğerleri eklenme sırasıyla. İzleyici (viewer) görev yazamadığı için
/// listede yok; ona atanmış görevin rozeti yine gösterilir
/// ([assigneeOf]).
List<TaskAssignee> taskAssignees(
  AppLocalizations l10n,
  List<Member> members, {
  required String? userId,
}) => [
  for (final assignee in _labelled(l10n, members, userId: userId))
    if (assignee.userId == userId || assignee.role != MembershipRole.viewer)
      (userId: assignee.userId, label: assignee.label, badge: assignee.badge),
]..sort((a, b) => (a.userId == userId ? 0 : 1) - (b.userId == userId ? 0 : 1));

/// Görevin atandığı kişi; atanmamışsa ya da üyelik bulunamıyorsa null.
TaskAssignee? assigneeOf(
  AppLocalizations l10n,
  List<Member> members,
  String? assignedTo, {
  required String? userId,
}) {
  if (assignedTo == null) return null;
  for (final assignee in _labelled(l10n, members, userId: userId)) {
    if (assignee.userId == assignedTo) {
      return (
        userId: assignee.userId,
        label: assignee.label,
        badge: assignee.badge,
      );
    }
  }
  return null;
}

Iterable<({String userId, MembershipRole role, String label, String badge})>
_labelled(
  AppLocalizations l10n,
  List<Member> members, {
  required String? userId,
}) sync* {
  final others = [
    for (final member in members)
      if (member.userId != userId) member,
  ];
  final counts = <MembershipRole, int>{};
  for (final member in others) {
    counts[member.role] = (counts[member.role] ?? 0) + 1;
  }
  final seen = <MembershipRole, int>{};
  for (final member in members) {
    if (member.userId == userId) {
      yield (
        userId: member.userId,
        role: member.role,
        label: l10n.taskAssigneeMe,
        badge: l10n.taskAssigneeMe,
      );
      continue;
    }
    final role = membershipRoleLabel(l10n, member.role);
    final index = seen[member.role] = (seen[member.role] ?? 0) + 1;
    final label = (counts[member.role] ?? 0) > 1
        ? l10n.taskMemberNumbered(role, index)
        : role;
    final initial = role.characters.first;
    yield (
      userId: member.userId,
      role: member.role,
      label: label,
      badge: (counts[member.role] ?? 0) > 1 ? '$initial$index' : initial,
    );
  }
}
