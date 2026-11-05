import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

/// Hesap silmede kullanıcının durumu; ilk adımın metni ve seçenekleri buna
/// göre değişir. Kurallar sunucudakiyle aynı (`account_deletion_request`).
enum DeletionScenario {
  /// Tek kişilik işletmenin sahibi: hesapla birlikte işletme ve tüm
  /// kayıtları silinir.
  soloOwner,

  /// Ekipli işletmenin sahibi: sahipliği bir ortağa devredip ayrılır ya da
  /// işletmeyi tümüyle siler.
  ownerWithTeam,

  /// Üye (ortak, işçi, danışman): yalnız hesabı silinir, işletme kalır.
  member,

  /// Üyelik bu telefona henüz inmedi; durum bilinmiyor.
  unknown,
}

/// Ekipli sahibin seçimi.
enum OwnerDeletionChoice { transfer, deleteOrganization }

/// [userId]'nin işletmedeki ([members], etkin üyelikler) durumu.
DeletionScenario deletionScenarioOf({
  required String? userId,
  required List<Member> members,
}) {
  final own = members.where((member) => member.userId == userId).firstOrNull;
  if (userId == null || own == null) return DeletionScenario.unknown;
  if (own.role != MembershipRole.owner) return DeletionScenario.member;
  final others = members.where((member) => member.userId != userId);
  return others.isEmpty
      ? DeletionScenario.soloOwner
      : DeletionScenario.ownerWithTeam;
}

/// Sahipliğin devredilebileceği üyeler: yalnız ortaklar (partner), eklenme
/// sırasıyla; kullanıcının kendisi hariç.
List<MemberProfile> transferCandidates(
  List<MemberProfile> members, {
  required String? userId,
}) => [
  for (final member in members)
    if (member.role == MembershipRole.partner && member.userId != userId)
      member,
];

/// İşletme ve tüm kayıtları da silinecek mi.
bool deletesOrganization(
  DeletionScenario scenario,
  OwnerDeletionChoice? choice,
) =>
    scenario == DeletionScenario.soloOwner ||
    (scenario == DeletionScenario.ownerWithTeam &&
        choice == OwnerDeletionChoice.deleteOrganization);

/// İlk adımdan devam edilebilir mi: durum bilinmeli; ekipli sahip bir seçim
/// yapmalı, devirde bir ortak seçmeli.
bool canLeaveOverview({
  required DeletionScenario scenario,
  required OwnerDeletionChoice? choice,
  required String? transferTo,
}) => switch (scenario) {
  DeletionScenario.unknown => false,
  DeletionScenario.soloOwner || DeletionScenario.member => true,
  DeletionScenario.ownerWithTeam => switch (choice) {
    null => false,
    OwnerDeletionChoice.deleteOrganization => true,
    OwnerDeletionChoice.transfer => transferTo != null,
  },
};

/// Son onayda yazılan metin beklenenle eşleşiyor mu. Baştaki ve sondaki
/// boşluk ile aradaki fazla boşluk yok sayılır; büyük/küçük harf yerelin
/// kuralıyla ([upperCase]: Türkçede `i` → `İ`) karşılaştırılır.
bool confirmationMatches(
  String typed,
  String expected, {
  required String Function(String value) upperCase,
}) {
  String normalize(String value) =>
      upperCase(value.trim().replaceAll(RegExp(r'\s+'), ' '));
  final target = normalize(expected);
  return target.isNotEmpty && normalize(typed) == target;
}
