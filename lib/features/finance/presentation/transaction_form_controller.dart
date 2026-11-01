import 'dart:async';

import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/services/receipt_file_store_provider.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_form_controller.freezed.dart';
part 'transaction_form_controller.g.dart';

@freezed
abstract class TransactionFormState with _$TransactionFormState {
  const factory({
    required TransactionKind kind,
    required DateTime occurredOn,
    TransactionCategory? category,

    /// Ayrıştırılmış tutar; boş ya da bozuksa null.
    double? amount,
    @Default('') String description,

    /// Bu formda çekilen, henüz kaydedilmemiş fiş.
    ReceiptCapture? receipt,
    String? apiaryId,
    String? lotId,
    String? transportId,

    /// Lottan satılan bal (kg); yalnız lotlu gelirde.
    double? saleKg,
    @Default(false) bool saving,
  }) = _TransactionFormState;
}

extension TransactionFormProgress on TransactionFormState {
  bool get canSave => category != null && amount != null && !saving;

  /// Satılan kilogram girilebilir: lotlu gelir.
  bool get canSell => kind == TransactionKind.income && lotId != null;
}

/// Gelir ya da gider ekleme formu. Ekran açık kaldığı sürece yaşar. Her
/// şey yerel DB'ye ve fiş klasörüne yazılır; kaydedilmeden kapanan formun
/// çektiği fiş silinir.
@riverpod
class TransactionFormController extends _$TransactionFormController {
  var _saved = false;

  /// Çekilen fişin adı; kapanırken `state` okunamadığı için ayrıca.
  String? _picked;

  @override
  TransactionFormState build(TransactionKind kind) {
    final files = ref.read(receiptFileStoreProvider);
    ref.onDispose(() {
      if (_picked case final fileName? when !_saved) {
        unawaited(files.delete(fileName));
      }
    });
    return TransactionFormState(kind: kind, occurredOn: dateOnly(clock.now()));
  }

  void setCategory(TransactionCategory? category) =>
      state = state.copyWith(category: category);

  void setAmount(double? amount) => state = state.copyWith(amount: amount);

  void setOccurredOn(DateTime day) =>
      state = state.copyWith(occurredOn: dateOnly(day));

  void setDescription(String description) =>
      state = state.copyWith(description: description);

  void setApiary(String? apiaryId) =>
      state = state.copyWith(apiaryId: apiaryId);

  /// Lot değişince satılan kilogram sıfırlanır.
  void setLot(String? lotId) =>
      state = state.copyWith(lotId: lotId, saleKg: null);

  void setTransport(String? transportId) =>
      state = state.copyWith(transportId: transportId);

  void setSaleKg(double? kg) => state = state.copyWith(saleKg: kg);

  /// Kamerayla fişin fotoğrafını çeker.
  Future<void> takePhoto() => _pickImage(fromGallery: false);

  /// Galeriden fişin fotoğrafını seçtirir.
  Future<void> pickImage() => _pickImage(fromGallery: true);

  /// Çekilen fişi bırakır ve siler.
  Future<void> removeReceipt() async {
    final previous = _picked;
    _picked = null;
    state = state.copyWith(receipt: null);
    if (previous != null) {
      await ref.read(receiptFileStoreProvider).delete(previous);
    }
  }

  /// Vazgeçilirse bir şey değişmez. Hata `MediaCaptureException`.
  Future<void> _pickImage({required bool fromGallery}) async {
    final files = ref.read(receiptFileStoreProvider);
    final fileId = generateId();
    final fileName = (fileId: fileId, byteSize: 0).fileName;
    final path = await files.pathOf(fileName);
    final camera = ref.read(cameraServiceProvider);
    final byteSize = fromGallery
        ? await camera.pickImage(path)
        : await camera.takePhoto(path);
    if (byteSize == null) return;
    if (!ref.mounted) {
      await files.delete(fileName);
      return;
    }
    final previous = _picked;
    _picked = fileName;
    state = state.copyWith(receipt: (fileId: fileId, byteSize: byteSize));
    if (previous != null) await files.delete(previous);
  }

  /// Hareketi yazar ve döner; kaydedilemiyorsa null. Satılan kilogram
  /// yalnız lotlu gelirde yazılır.
  Future<FinanceTransaction?> save() async {
    final form = state;
    final orgId = ref.read(currentOrgIdProvider);
    final currency = ref.read(financeCurrencyProvider);
    if (!form.canSave || orgId == null || currency == null) return null;
    state = form.copyWith(saving: true);
    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      final saved = await ref
          .read(transactionRepositoryProvider)
          .create(
            orgId: orgId,
            kind: form.kind,
            category: form.category!,
            amount: form.amount!,
            currency: currency,
            occurredOn: form.occurredOn,
            description: form.description,
            receipt: form.receipt,
            apiaryId: form.apiaryId,
            lotId: form.lotId,
            transportId: form.transportId,
            saleKg: form.canSell ? form.saleKg : null,
          );
      _saved = true;
      return saved;
    } finally {
      if (ref.mounted) state = state.copyWith(saving: false);
    }
  }
}
