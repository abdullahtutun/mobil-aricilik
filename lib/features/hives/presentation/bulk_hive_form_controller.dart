import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bulk_hive_form_controller.freezed.dart';
part 'bulk_hive_form_controller.g.dart';

@freezed
abstract class BulkHiveFormState with _$BulkHiveFormState {
  const factory({
    /// Kaç kovan; alan yazıldığı gibi.
    @Default('') String count,
    @Default('') String startNumber,
    @Default(HiveType.langstroth) HiveType type,
    HiveSource? source,
    @Default(false) bool saving,
  }) = _BulkHiveFormState;
}

extension BulkHiveFormProgress on BulkHiveFormState {
  int? get _count => int.tryParse(count.trim());

  /// Sayı [maxBulkHiveCount]'u aşıyor; alan uyarı gösterir.
  bool get countTooLarge => (_count ?? 0) > maxBulkHiveCount;

  /// Oluşturulacak numaralar; alanlar eksik ya da geçersizse null.
  List<String>? get numbers {
    final count = _count;
    final start = startNumber.trim();
    if (count == null || count < 1 || countTooLarge) return null;
    if (!isBulkStartNumber(start)) return null;
    return bulkHiveNumbers(start: start, count: count);
  }

  bool get canSave => numbers != null && !saving;
}

/// "20 kovan oluştur, 101'den başla": aynı tip ve kaynakta ardışık
/// numaralı aktif kovanlar. Ekran açık kaldığı sürece yaşar. Arılık yoksa
/// ya da silinmişse durum null. Hepsi tek transaction'da yerel DB'ye
/// yazılır.
@riverpod
class BulkHiveFormController extends _$BulkHiveFormController {
  @override
  Future<BulkHiveFormState?> build(String apiaryId) async {
    final apiary = await ref.read(apiaryRepositoryProvider).findById(apiaryId);
    return apiary == null ? null : const BulkHiveFormState();
  }

  void updateCount(String count) =>
      _update((form) => form.copyWith(count: count));

  void updateStartNumber(String startNumber) =>
      _update((form) => form.copyWith(startNumber: startNumber));

  void selectType(HiveType type) =>
      _update((form) => form.copyWith(type: type));

  void selectSource(HiveSource? source) =>
      _update((form) => form.copyWith(source: source));

  /// Kovanları yazar ve kaç tane oluştuğunu döner. Kaydedilemiyorsa
  /// ([BulkHiveFormProgress.canSave]) null döner.
  Future<int?> save() async {
    final form = state.value;
    final numbers = form?.numbers;
    final orgId = ref.read(currentOrgIdProvider);
    if (form == null || numbers == null || form.saving || orgId == null) {
      return null;
    }
    _update((form) => form.copyWith(saving: true));
    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      final created = await ref
          .read(hiveRepositoryProvider)
          .createMany(
            orgId: orgId,
            apiaryId: apiaryId,
            numbers: numbers,
            type: form.type,
            source: form.source,
          );
      return created.length;
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(BulkHiveFormState Function(BulkHiveFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
