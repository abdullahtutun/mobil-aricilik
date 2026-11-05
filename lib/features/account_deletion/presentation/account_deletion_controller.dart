import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion_rules.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_deletion_controller.freezed.dart';
part 'account_deletion_controller.g.dart';

/// Silme akışının adımları; bitiş ekranı ayrı rotada (oturum kapandıktan
/// sonra da açık kalır).
enum DeletionStep {
  /// Ne gideceği.
  overview,

  /// Önce verini al.
  backup,

  /// E-postaya gelen kodla kimlik doğrulama.
  verify,

  /// Son onay.
  confirm,
}

@freezed
abstract class DeletionFlowState with _$DeletionFlowState {
  const factory({
    @Default(DeletionStep.overview) DeletionStep step,

    /// Ekipli sahibin seçimi.
    OwnerDeletionChoice? choice,

    /// Devirde seçilen ortağın kullanıcı kimliği.
    String? transferTo,

    /// Kod bu akışta doğrulandı mı; doğrulanmadan son onaya geçilmez.
    @Default(false) bool verified,

    /// Talep gönderiliyor.
    @Default(false) bool busy,
    AccountDeletionFailure? failure,
  }) = _DeletionFlowState;
}

/// Ayarlar > Hesabımı sil akışı. Ekran dinlediği sürece yaşar; raporlar
/// ekranına gidip dönünce de durum kalır (ekran yığında durur).
@riverpod
class DeletionFlowController extends _$DeletionFlowController {
  @override
  DeletionFlowState build() => const DeletionFlowState();

  void choose(OwnerDeletionChoice choice) {
    if (state.busy) return;
    state = state.copyWith(choice: choice, failure: null);
  }

  void selectTransferTarget(String userId) {
    if (state.busy) return;
    state = state.copyWith(transferTo: userId, failure: null);
  }

  /// Sonraki adıma geçer; adımın şartı sağlanmıyorsa yerinde kalır. Kod
  /// adımından yalnız [codeVerified] ile çıkılır.
  void next() {
    if (state.busy) return;
    final next = switch (state.step) {
      DeletionStep.overview =>
        canLeaveOverview(
              scenario: ref.read(deletionScenarioProvider),
              choice: state.choice,
              transferTo: state.transferTo,
            )
            ? DeletionStep.backup
            : null,
      DeletionStep.backup => DeletionStep.verify,
      DeletionStep.verify => state.verified ? DeletionStep.confirm : null,
      DeletionStep.confirm => null,
    };
    if (next != null) state = state.copyWith(step: next, failure: null);
  }

  /// Önceki adıma döner; ilk adımdaysa false (ekran kapanır). Doğrulanmış
  /// kod geri gidince de geçerli kalır.
  bool back() {
    if (state.busy) return true;
    final previous = switch (state.step) {
      DeletionStep.overview => null,
      DeletionStep.backup => DeletionStep.overview,
      DeletionStep.verify => DeletionStep.backup,
      DeletionStep.confirm => DeletionStep.verify,
    };
    if (previous == null) return false;
    state = state.copyWith(step: previous, failure: null);
    return true;
  }

  /// Kod doğrulandı; son onaya geçilir.
  void codeVerified() {
    if (state.step != DeletionStep.verify) return;
    state = state.copyWith(verified: true, step: DeletionStep.confirm);
  }

  /// Talebi açar; açıldıysa true (sonuç [lastDeletionOutcomeProvider]'da).
  /// Kod doğrulanmadıysa ya da son onayda değilse bir şey yapmaz.
  Future<bool> submit() async {
    final orgId = ref.read(currentOrgIdProvider);
    if (state.busy ||
        !state.verified ||
        state.step != DeletionStep.confirm ||
        orgId == null) {
      return false;
    }
    final scenario = ref.read(deletionScenarioProvider);
    final transfer =
        scenario == DeletionScenario.ownerWithTeam &&
        state.choice == OwnerDeletionChoice.transfer;
    state = state.copyWith(busy: true, failure: null);
    try {
      await ref
          .read(accountDeletionActionsProvider)
          .request(
            orgId: orgId,
            deleteOrganization:
                scenario == DeletionScenario.ownerWithTeam &&
                state.choice == OwnerDeletionChoice.deleteOrganization,
            transferTo: transfer ? state.transferTo : null,
          );
    } on AccountDeletionException catch (error) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, failure: error.failure);
      }
      return false;
    }
    if (ref.mounted) state = state.copyWith(busy: false);
    return true;
  }
}
