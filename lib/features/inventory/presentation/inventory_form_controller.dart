import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/inventory_rules.dart';
import 'package:mobil_arici/features/inventory/presentation/inventory_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inventory_form_controller.freezed.dart';
part 'inventory_form_controller.g.dart';

@freezed
abstract class InventoryFormState with _$InventoryFormState {
  const factory({
    @Default('') String name,
    InventoryCategory? category,
    InventoryUnit? unit,
    @Default('') String place,

    /// Yazıldığı gibi; boşsa eşik yok.
    @Default('') String threshold,
    @Default(false) bool saving,
  }) = _InventoryFormState;
}

extension InventoryFormProgress on InventoryFormState {
  /// Yazılan eşik geçersiz (birim seçildiyse birime göre).
  bool get thresholdInvalid =>
      threshold.trim().isNotEmpty &&
      parseInventoryQuantity(threshold, unit ?? InventoryUnit.kg) == null;

  double? get thresholdValue => threshold.trim().isEmpty
      ? null
      : parseInventoryQuantity(threshold, unit ?? InventoryUnit.kg);

  bool get canSave =>
      name.trim().isNotEmpty &&
      category != null &&
      unit != null &&
      !thresholdInvalid &&
      !saving;
}

/// Stok kalemi ekleme ([itemId] null) ve düzenleme formu: ad, kategori,
/// birim, konum ve eşik. Düzenlenecek kalem yoksa ya da silinmişse durum
/// null. Yeni kalemin kategorisi [category] (listede açık sekme).
@riverpod
class InventoryFormController extends _$InventoryFormController {
  @override
  Future<InventoryFormState?> build(
    String? itemId, {
    InventoryCategory? category,
  }) async {
    if (itemId == null) return InventoryFormState(category: category);
    final item = await ref.read(inventoryRepositoryProvider).findById(itemId);
    return item == null
        ? null
        : InventoryFormState(
            name: item.name,
            category: item.category,
            unit: item.unit,
            place: item.place ?? '',
            threshold: switch (item.threshold) {
              final value? => _editableNumber(value),
              null => '',
            },
          );
  }

  void setName(String name) => _update((form) => form.copyWith(name: name));

  void setCategory(InventoryCategory category) =>
      _update((form) => form.copyWith(category: category));

  void setUnit(InventoryUnit unit) =>
      _update((form) => form.copyWith(unit: unit));

  void setPlace(String place) => _update((form) => form.copyWith(place: place));

  void setThreshold(String threshold) =>
      _update((form) => form.copyWith(threshold: threshold));

  /// Kalemi yazar ve döner; kaydedilemiyorsa ya da düzenlenen kalem bu
  /// arada silindiyse null.
  Future<InventoryItem?> save() async {
    final form = state.value;
    final orgId = ref.read(currentOrgIdProvider);
    if (form == null || !form.canSave || orgId == null) return null;
    _update((form) => form.copyWith(saving: true));

    final repository = ref.read(inventoryRepositoryProvider);
    final id = itemId;
    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      if (id == null) {
        return await repository.create(
          orgId: orgId,
          name: form.name,
          category: form.category!,
          unit: form.unit!,
          place: form.place,
          threshold: form.thresholdValue,
        );
      }
      final latest = await repository.findById(id);
      if (latest == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      return await repository.update(
        latest.copyWith(
          name: form.name,
          category: form.category!,
          unit: form.unit!,
          place: form.place,
          threshold: form.thresholdValue,
        ),
      );
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(InventoryFormState Function(InventoryFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}

/// Alana yazılacak sayı: tam sayıda ondalık yok, ondalık ayırıcı virgül
/// değil nokta (ayrıştırıcı ikisini de kabul eder).
String _editableNumber(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toString();
