import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/role_permissions.dart'
    as permissions;
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/team/data/team_service.dart';
import 'package:mobil_arici/features/team/domain/invite.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'team_providers.g.dart';

/// Testler sahtesiyle override eder.
@Riverpod(keepAlive: true)
TeamService teamService(Ref ref) =>
    SupabaseTeamService(ref.watch(supabaseClientProvider));

/// Oturumdaki kullanıcının işletmedeki rolü; üyeliği henüz yerel DB'ye
/// inmediyse null.
@riverpod
MembershipRole? currentRole(Ref ref) {
  final userId = ref.watch(currentUserProvider.select((user) => user?.id));
  final members = ref.watch(organizationMembersProvider).value ?? const [];
  for (final member in members) {
    if (member.userId == userId) return member.role;
  }
  return null;
}

/// Kayıt ekleme/düzenleme butonları görünsün mü (viewer görmez).
@riverpod
bool canWriteRecords(Ref ref) =>
    permissions.canWriteRecords(ref.watch(currentRoleProvider));

/// Finans menüsü görünsün mü (worker ve viewer görmez).
@riverpod
bool canSeeFinance(Ref ref) =>
    permissions.canSeeFinance(ref.watch(currentRoleProvider));

/// Üyelerin e-postaları (kullanıcı kimliğine göre). Çevrimdışıysa ya da
/// çağrı başarısızsa boş harita; liste yerel üyeliklerle yine çizilir.
@riverpod
Future<Map<String, String?>> memberEmails(Ref ref) async {
  final orgId = ref.watch(currentOrgIdProvider);
  // Üyelik değişince (senkronla ya da rol/çıkarma sonrası) yeniden alınır.
  await ref.watch(organizationMembersProvider.future);
  if (orgId == null) return const {};
  try {
    return await ref.watch(teamServiceProvider).fetchMemberEmails(orgId);
  } on TeamServiceException {
    return const {};
  }
}

/// Ekip ekranındaki davet kartı: seçili rol ve üretilen kod.
class InviteState {
  const new({
    this.role = MembershipRole.worker,
    this.invite,
    this.busy = false,
  });

  final MembershipRole role;

  /// [role] için üretilmiş kod; rol değişince silinir.
  final Invite? invite;
  final bool busy;

  InviteState copyWith({
    MembershipRole? role,
    Invite? Function()? invite,
    bool? busy,
  }) => InviteState(
    role: role ?? this.role,
    invite: invite == null ? this.invite : invite(),
    busy: busy ?? this.busy,
  );
}

@riverpod
class InviteController extends _$InviteController {
  @override
  InviteState build() => const InviteState();

  void selectRole(MembershipRole role) {
    if (role == state.role) return;
    state = InviteState(role: role);
  }

  /// Seçili rol için yeni kod üretir. Hata [TeamServiceException] olarak
  /// gelir.
  Future<void> generate() async {
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null || state.busy) return;
    final role = state.role;
    state = state.copyWith(busy: true);
    try {
      final invite = await ref
          .read(teamServiceProvider)
          .createInvite(orgId: orgId, role: role);
      // Üretilirken rol değiştiyse kod eski role aittir; gösterilmez.
      if (ref.mounted && state.role == role) {
        state = state.copyWith(invite: () => invite);
      }
    } finally {
      if (ref.mounted) state = state.copyWith(busy: false);
    }
  }
}

/// Üyelik işlemleri (katılma, rol, çıkarma). Hata [TeamServiceException]
/// olarak gelir. İşlem ağ beklerken ekranın dinlemesi bitebilir; `keepAlive`
/// olmazsa `ref` ilk `await`'ten sonra geçersiz olur.
@Riverpod(keepAlive: true)
TeamActions teamActions(Ref ref) => TeamActions(ref);

class TeamActions {
  const new(this._ref);

  final Ref _ref;

  /// Kodla katılır; sonra üyelikleri çekmek için senkron başlatılır.
  Future<void> join(String code) async {
    await _ref.read(teamServiceProvider).redeem(normalizeInviteCode(code));
    await _ref.read(syncControllerProvider.notifier).sync();
  }

  Future<void> setRole(String userId, MembershipRole role) => _change(
    (orgId) => _ref
        .read(teamServiceProvider)
        .setRole(orgId: orgId, userId: userId, role: role),
  );

  Future<void> remove(String userId) => _change(
    (orgId) => _ref
        .read(teamServiceProvider)
        .removeMember(orgId: orgId, userId: userId),
  );

  /// Sunucudaki değişiklik yerel DB'ye senkronla iner.
  Future<void> _change(Future<void> Function(String orgId) call) async {
    final orgId = _ref.read(currentOrgIdProvider);
    if (orgId == null) return;
    await call(orgId);
    await _ref.read(syncControllerProvider.notifier).sync();
  }
}
