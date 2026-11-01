import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/queens/presentation/queen_rearing_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'queen_rearing_form_controller.freezed.dart';
part 'queen_rearing_form_controller.g.dart';

/// Yeni serinin varsayılan larva sayısı.
const defaultGraftedCount = 40;

@freezed
abstract class QueenRearingFormState with _$QueenRearingFormState {
  const factory({
    required DateTime graftedOn,
    @Default(defaultGraftedCount) int graftedCount,
    String? motherQueenId,

    /// Kabul edilen meme; sayılmadıysa boş.
    int? acceptedCount,
    @Default(false) bool saving,
  }) = _QueenRearingFormState;
}

extension QueenRearingFormProgress on QueenRearingFormState {
  bool get canSave => !saving;
}

/// Seri ekleme ([batchId] null) ve düzenleme formu: anne ana, aktarma
/// günü, aktarılan ve kabul edilen sayısı. Düzenlenecek seri yoksa ya da
/// silinmişse durum null. Yeni serinin aktarma günü bugün.
@riverpod
class QueenRearingFormController extends _$QueenRearingFormController {
  @override
  Future<QueenRearingFormState?> build(String? batchId) async {
    if (batchId == null) {
      return QueenRearingFormState(graftedOn: dateOnly(clock.now()));
    }
    final batch = await ref
        .read(queenRearingRepositoryProvider)
        .findById(batchId);
    return batch == null
        ? null
        : QueenRearingFormState(
            graftedOn: batch.graftedOn,
            graftedCount: batch.graftedCount,
            motherQueenId: batch.motherQueenId,
            acceptedCount: batch.acceptedCount,
          );
  }

  void setGraftedOn(DateTime day) =>
      _update((form) => form.copyWith(graftedOn: dateOnly(day)));

  /// Aktarılan sayısı; kabul edilen bundan fazlaysa ona iner.
  void setGraftedCount(int count) => _update(
    (form) => form.copyWith(
      graftedCount: count,
      acceptedCount: switch (form.acceptedCount) {
        final accepted? when accepted > count => count,
        final accepted => accepted,
      },
    ),
  );

  void selectMother(String? queenId) =>
      _update((form) => form.copyWith(motherQueenId: queenId));

  /// Kabul edilen sayısı; null sayılmadı.
  void setAcceptedCount(int? count) =>
      _update((form) => form.copyWith(acceptedCount: count));

  /// Seriyi yazar ve döner; kaydedilemiyorsa ya da düzenlenen seri bu
  /// arada silindiyse null. Yeni serinin takvim görevleri oturumdaki
  /// kullanıcıya atanır.
  Future<QueenRearingBatch?> save() async {
    final form = state.value;
    final orgId = ref.read(currentOrgIdProvider);
    if (form == null || !form.canSave || orgId == null) return null;
    _update((form) => form.copyWith(saving: true));

    final repository = ref.read(queenRearingRepositoryProvider);
    final id = batchId;
    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      if (id == null) {
        return await repository.create(
          orgId: orgId,
          graftedOn: form.graftedOn,
          graftedCount: form.graftedCount,
          motherQueenId: form.motherQueenId,
          acceptedCount: form.acceptedCount,
          assignedTo: ref.read(currentUserIdProvider),
        );
      }
      final latest = await repository.findById(id);
      if (latest == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      return await repository.update(
        latest.copyWith(
          graftedOn: form.graftedOn,
          graftedCount: form.graftedCount,
          motherQueenId: form.motherQueenId,
          acceptedCount: form.acceptedCount,
        ),
      );
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(
    QueenRearingFormState Function(QueenRearingFormState form) change,
  ) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
