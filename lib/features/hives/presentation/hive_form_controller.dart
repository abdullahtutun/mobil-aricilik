import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_form_controller.freezed.dart';
part 'hive_form_controller.g.dart';

@freezed
abstract class HiveFormState with _$HiveFormState {
  const factory({
    @Default('') String number,
    @Default(HiveType.langstroth) HiveType type,
    @Default(HiveStatus.active) HiveStatus status,
    HiveSource? source,

    /// Düzenlenen kovanın form açılırkenki durumu; yeni kovanda null.
    HiveStatus? savedStatus,
    @Default(false) bool saving,
  }) = _HiveFormState;

  factory fromHive(Hive hive) => HiveFormState(
    number: hive.number,
    type: hive.type,
    status: hive.status,
    source: hive.source,
    savedStatus: hive.status,
  );
}

extension HiveFormProgress on HiveFormState {
  bool get canSave => number.trim().isNotEmpty && !saving;

  /// Kaydetmek aktif kovan sayısını düşürür; ekran önce onay ister. Yeni
  /// kovan henüz sayılmadığı için onay istemez.
  bool get needsConfirmation => switch (savedStatus) {
    final saved? => statusChangeNeedsConfirmation(from: saved, to: status),
    null => false,
  };
}

/// Kovan ekleme ([hiveId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Eklenecek arılık ya da düzenlenecek kovan yoksa (ya da
/// silinmişse) durum null. Her şey yerel DB'ye yazılır.
@riverpod
class HiveFormController extends _$HiveFormController {
  @override
  Future<HiveFormState?> build({
    required String apiaryId,
    String? hiveId,
  }) async {
    if (hiveId == null) {
      final apiary = await ref
          .read(apiaryRepositoryProvider)
          .findById(apiaryId);
      return apiary == null ? null : const HiveFormState();
    }
    final hive = await ref.read(hiveRepositoryProvider).findById(hiveId);
    return hive == null ? null : HiveFormState.fromHive(hive);
  }

  void updateNumber(String number) =>
      _update((form) => form.copyWith(number: number));

  void selectType(HiveType type) =>
      _update((form) => form.copyWith(type: type));

  void selectStatus(HiveStatus status) =>
      _update((form) => form.copyWith(status: status));

  void selectSource(HiveSource? source) =>
      _update((form) => form.copyWith(source: source));

  /// Kovanı yerel DB'ye yazar ve kimliğini döner. Kaydedilemiyorsa
  /// ([HiveFormProgress.canSave]) null döner. Düzenlenen kovan bu arada
  /// silindiyse durum null olur. Onay gerekiyorsa
  /// ([HiveFormProgress.needsConfirmation]) çağırmadan önce ekran sorar.
  Future<String?> save() async {
    final form = state.value;
    if (form == null || !form.canSave) return null;
    final repository = ref.read(hiveRepositoryProvider);
    final id = hiveId;
    final orgId = ref.read(currentOrgIdProvider);
    if (id == null && orgId == null) return null;
    _update((form) => form.copyWith(saving: true));

    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      final Hive saved;
      if (id == null) {
        saved = await repository.create(
          orgId: orgId!,
          number: form.number.trim(),
          type: form.type,
          apiaryId: apiaryId,
          status: form.status,
          source: form.source,
        );
      } else {
        // Formda olmayan alanlar (ör. arılık, ana arı) en son hâlinden
        // alınır.
        final latest = await repository.findById(id);
        if (latest == null) {
          if (ref.mounted) state = const AsyncData(null);
          return null;
        }
        saved = await repository.update(
          latest.copyWith(
            number: form.number.trim(),
            type: form.type,
            status: form.status,
            source: form.source,
          ),
        );
      }
      return saved.id;
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(HiveFormState Function(HiveFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
