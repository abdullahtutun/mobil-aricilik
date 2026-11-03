import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/feeding/domain/feeding_rules.dart';
import 'package:mobil_arici/features/feeding/presentation/feeding_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/stock_usage_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feeding_form_controller.freezed.dart';
part 'feeding_form_controller.g.dart';

/// Beslemenin yazılacağı kovanlar: açılan kovan ya da arılığındaki aktif
/// kovanlar.
enum FeedingScope { hive, apiary }

@freezed
abstract class FeedingFormState with _$FeedingFormState {
  const factory({
    required Hive hive,
    @Default(FeedingScope.hive) FeedingScope scope,

    /// Seçilene kadar boş ve Kaydet kapalı.
    FeedingKind? kind,

    /// Kovan başına, kullanıcının biriminde (şurupta hacim, değilse kütle).
    @Default(1) int amount,

    /// Stoktan düşülecek kalem; seçilmediyse türün son kullanılanı.
    @Default(defaultStockChoice) StockChoice stock,
    @Default(false) bool saving,
  }) = _FeedingFormState;
}

/// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
/// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
/// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.
/// [wholeApiary] formu arılığın tümü seçili açar.
@riverpod
class FeedingFormController extends _$FeedingFormController {
  @override
  Future<FeedingFormState?> build(
    String hiveId, {
    bool wholeApiary = false,
  }) async {
    final hive = await ref.read(hiveRepositoryProvider).findById(hiveId);
    if (hive == null) return null;
    return FeedingFormState(
      hive: hive,
      scope: wholeApiary ? FeedingScope.apiary : FeedingScope.hive,
    );
  }

  void setScope(FeedingScope scope) =>
      _update((form) => form.copyWith(scope: scope));

  void selectKind(FeedingKind kind) =>
      _update((form) => form.copyWith(kind: kind));

  void setAmount(int amount) =>
      _update((form) => form.copyWith(amount: amount));

  /// Stoktan düşülecek kalemi seçer; null "Düşme".
  void selectStockItem(String? itemId) =>
      _update((form) => form.copyWith(stock: (chosen: true, itemId: itemId)));

  /// Beslemeyi yazar ve yazılanları döner; [stockItem] verilirse kullanılan
  /// miktar ondan düşülür. Tür seçilmemişse ya da kovan bu arada silindiyse
  /// null.
  Future<List<Feeding>?> save({InventoryItem? stockItem}) async {
    final form = state.value;
    final kind = form?.kind;
    if (form == null || kind == null || form.saving) return null;
    _update((form) => form.copyWith(saving: true));

    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      final hive = await ref.read(hiveRepositoryProvider).findById(hiveId);
      if (hive == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      final plan = (
        kind: kind,
        amount: storedFeedingAmount(
          kind,
          form.amount,
          ref.read(regionConfigProvider).defaultUnits,
        ),
        fedAt: clock.now(),
      );
      final repository = ref.read(feedingRepositoryProvider);
      return switch (form.scope) {
        FeedingScope.hive => [
          await repository.addToHive(hive, plan, stockItem: stockItem),
        ],
        FeedingScope.apiary => await repository.addToApiary(
          hive.apiaryId,
          plan,
          stockItem: stockItem,
        ),
      };
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(FeedingFormState Function(FeedingFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
