import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/receipt_file_store_provider.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'finance_providers.g.dart';

@Riverpod(keepAlive: true)
TransactionRepository transactionRepository(Ref ref) =>
    TransactionRepository(ref.watch(appDatabaseProvider));

/// Oturumdaki işletmenin hareketleri, yeni önce; işletme yoksa boş.
@riverpod
Stream<List<TransactionRow>> transactionRows(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(transactionRepositoryProvider).watchRows(orgId);
}

/// Hareket; yoksa ya da silinmişse (Geri al) null.
@riverpod
Stream<TransactionRow?> transactionRow(Ref ref, String id) =>
    ref.watch(transactionRepositoryProvider).watchRow(id);

/// Gidere bağlanabilecek son taşımalar; işletme yoksa boş.
@riverpod
Stream<List<TransportChoice>> transportChoices(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(transactionRepositoryProvider).watchTransportChoices(orgId);
}

/// İşletmenin para birimi; hareketler bununla yazılır. İşletme henüz
/// yüklenmediyse null.
@riverpod
String? financeCurrency(Ref ref) => ref.watch(
  currentOrganizationProvider.select(
    (organization) => organization.value?.currency,
  ),
);

/// Bu sezonun (takvim yılı) özeti: işletmenin para birimindeki gelir,
/// gider, net ve aktif kovan başı maliyet.
@riverpod
Future<SeasonSummary?> financeSeason(Ref ref) async {
  final currency = ref.watch(financeCurrencyProvider);
  if (currency == null) return null;
  final rows = await ref.watch(transactionRowsProvider.future);
  final apiaries = await ref.watch(apiaryListProvider.future);
  return seasonSummary(
    [for (final row in rows) row.transaction],
    year: clock.now().year,
    currency: currency,
    activeHives: apiaries.fold(0, (sum, item) => sum + item.activeHiveCount),
  );
}

/// Fiş fotoğrafı bu telefonda varsa; yoksa (henüz inmedi) null.
@riverpod
Future<File?> receiptFile(Ref ref, String storagePath) =>
    ref.watch(receiptFileStoreProvider).find(receiptFileName(storagePath));

/// Hareket yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da
/// çalışsın diye sürekli yaşar.
@Riverpod(keepAlive: true)
class FinanceActions extends _$FinanceActions {
  @override
  void build() {}

  /// Hareketi ve (lot satışında) satışı siler; Geri al da budur.
  Future<void> remove(FinanceTransaction transaction) =>
      ref.read(transactionRepositoryProvider).remove(transaction.id);
}
