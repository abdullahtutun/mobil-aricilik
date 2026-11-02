// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionRepository)
final transactionRepositoryProvider = TransactionRepositoryProvider._();

final class TransactionRepositoryProvider
    extends
        $FunctionalProvider<
          TransactionRepository,
          TransactionRepository,
          TransactionRepository
        >
    with $Provider<TransactionRepository> {
  TransactionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransactionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionRepository create(Ref ref) {
    return transactionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionRepository>(value),
    );
  }
}

String _$transactionRepositoryHash() =>
    r'3aa8ec799ae327e93274d19afe4e5b474c10cee7';

@ProviderFor(customerRepository)
final customerRepositoryProvider = CustomerRepositoryProvider._();

final class CustomerRepositoryProvider
    extends
        $FunctionalProvider<
          CustomerRepository,
          CustomerRepository,
          CustomerRepository
        >
    with $Provider<CustomerRepository> {
  CustomerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerRepository create(Ref ref) {
    return customerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerRepository>(value),
    );
  }
}

String _$customerRepositoryHash() =>
    r'f689edf3044f7155530a88cdd11da9d7e1078996';

@ProviderFor(customerPaymentRepository)
final customerPaymentRepositoryProvider = CustomerPaymentRepositoryProvider._();

final class CustomerPaymentRepositoryProvider
    extends
        $FunctionalProvider<
          CustomerPaymentRepository,
          CustomerPaymentRepository,
          CustomerPaymentRepository
        >
    with $Provider<CustomerPaymentRepository> {
  CustomerPaymentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerPaymentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerPaymentRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomerPaymentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerPaymentRepository create(Ref ref) {
    return customerPaymentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerPaymentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerPaymentRepository>(value),
    );
  }
}

String _$customerPaymentRepositoryHash() =>
    r'b281dbbe5e302d756a37a4531eb5dca1f2814810';

/// Oturumdaki işletmenin hareketleri, yeni önce; işletme yoksa boş.

@ProviderFor(transactionRows)
final transactionRowsProvider = TransactionRowsProvider._();

/// Oturumdaki işletmenin hareketleri, yeni önce; işletme yoksa boş.

final class TransactionRowsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionRow>>,
          List<TransactionRow>,
          Stream<List<TransactionRow>>
        >
    with
        $FutureModifier<List<TransactionRow>>,
        $StreamProvider<List<TransactionRow>> {
  /// Oturumdaki işletmenin hareketleri, yeni önce; işletme yoksa boş.
  TransactionRowsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionRowsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionRowsHash();

  @$internal
  @override
  $StreamProviderElement<List<TransactionRow>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionRow>> create(Ref ref) {
    return transactionRows(ref);
  }
}

String _$transactionRowsHash() => r'dabd38abe0a94fbb12e63ed1ee0cf9e560736c26';

/// Hareket; yoksa ya da silinmişse (Geri al) null.

@ProviderFor(transactionRow)
final transactionRowProvider = TransactionRowFamily._();

/// Hareket; yoksa ya da silinmişse (Geri al) null.

final class TransactionRowProvider
    extends
        $FunctionalProvider<
          AsyncValue<TransactionRow?>,
          TransactionRow?,
          Stream<TransactionRow?>
        >
    with $FutureModifier<TransactionRow?>, $StreamProvider<TransactionRow?> {
  /// Hareket; yoksa ya da silinmişse (Geri al) null.
  TransactionRowProvider._({
    required TransactionRowFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'transactionRowProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionRowHash();

  @override
  String toString() {
    return r'transactionRowProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<TransactionRow?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<TransactionRow?> create(Ref ref) {
    final argument = this.argument as String;
    return transactionRow(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionRowProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionRowHash() => r'c22c4d8e2a0676cd8c737b25ccce930b763128cf';

/// Hareket; yoksa ya da silinmişse (Geri al) null.

final class TransactionRowFamily extends $Family
    with $FunctionalFamilyOverride<Stream<TransactionRow?>, String> {
  TransactionRowFamily._()
    : super(
        retry: null,
        name: r'transactionRowProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Hareket; yoksa ya da silinmişse (Geri al) null.

  TransactionRowProvider call(String id) =>
      TransactionRowProvider._(argument: id, from: this);

  @override
  String toString() => r'transactionRowProvider';
}

/// Gidere bağlanabilecek son taşımalar; işletme yoksa boş.

@ProviderFor(transportChoices)
final transportChoicesProvider = TransportChoicesProvider._();

/// Gidere bağlanabilecek son taşımalar; işletme yoksa boş.

final class TransportChoicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransportChoice>>,
          List<TransportChoice>,
          Stream<List<TransportChoice>>
        >
    with
        $FutureModifier<List<TransportChoice>>,
        $StreamProvider<List<TransportChoice>> {
  /// Gidere bağlanabilecek son taşımalar; işletme yoksa boş.
  TransportChoicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transportChoicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transportChoicesHash();

  @$internal
  @override
  $StreamProviderElement<List<TransportChoice>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransportChoice>> create(Ref ref) {
    return transportChoices(ref);
  }
}

String _$transportChoicesHash() => r'dbf6bedc55aa0dc4069d7346e1274bfb5d05b4db';

/// İşletmenin para birimi; hareketler bununla yazılır. İşletme henüz
/// yüklenmediyse null.

@ProviderFor(financeCurrency)
final financeCurrencyProvider = FinanceCurrencyProvider._();

/// İşletmenin para birimi; hareketler bununla yazılır. İşletme henüz
/// yüklenmediyse null.

final class FinanceCurrencyProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// İşletmenin para birimi; hareketler bununla yazılır. İşletme henüz
  /// yüklenmediyse null.
  FinanceCurrencyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financeCurrencyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financeCurrencyHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return financeCurrency(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$financeCurrencyHash() => r'edd1e57ef2194328c6f0aad6e333e5d0e7910b61';

/// Bu sezonun (takvim yılı) özeti: işletmenin para birimindeki gelir,
/// gider, net ve aktif kovan başı maliyet.

@ProviderFor(financeSeason)
final financeSeasonProvider = FinanceSeasonProvider._();

/// Bu sezonun (takvim yılı) özeti: işletmenin para birimindeki gelir,
/// gider, net ve aktif kovan başı maliyet.

final class FinanceSeasonProvider
    extends
        $FunctionalProvider<
          AsyncValue<SeasonSummary?>,
          SeasonSummary?,
          FutureOr<SeasonSummary?>
        >
    with $FutureModifier<SeasonSummary?>, $FutureProvider<SeasonSummary?> {
  /// Bu sezonun (takvim yılı) özeti: işletmenin para birimindeki gelir,
  /// gider, net ve aktif kovan başı maliyet.
  FinanceSeasonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financeSeasonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financeSeasonHash();

  @$internal
  @override
  $FutureProviderElement<SeasonSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SeasonSummary?> create(Ref ref) {
    return financeSeason(ref);
  }
}

String _$financeSeasonHash() => r'7d0657c83b447f31ec42f66b553bf4f0bff30718';

/// Bu sezonun konaklama noktası (arılık) kârları, büyük net önce
/// ([apiaryProfits]); işletmenin para birimindeki hareketlerden.

@ProviderFor(apiaryProfitList)
final apiaryProfitListProvider = ApiaryProfitListProvider._();

/// Bu sezonun konaklama noktası (arılık) kârları, büyük net önce
/// ([apiaryProfits]); işletmenin para birimindeki hareketlerden.

final class ApiaryProfitListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApiaryProfit>>,
          List<ApiaryProfit>,
          FutureOr<List<ApiaryProfit>>
        >
    with
        $FutureModifier<List<ApiaryProfit>>,
        $FutureProvider<List<ApiaryProfit>> {
  /// Bu sezonun konaklama noktası (arılık) kârları, büyük net önce
  /// ([apiaryProfits]); işletmenin para birimindeki hareketlerden.
  ApiaryProfitListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiaryProfitListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiaryProfitListHash();

  @$internal
  @override
  $FutureProviderElement<List<ApiaryProfit>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ApiaryProfit>> create(Ref ref) {
    return apiaryProfitList(ref);
  }
}

String _$apiaryProfitListHash() => r'b43e20aecdd6362d02c06274089e5fb23ebea8a7';

/// İşletmenin lota bağlı hasatları (lot, arılık, kg); işletme yoksa boş.

@ProviderFor(lotHarvestShares)
final lotHarvestSharesProvider = LotHarvestSharesProvider._();

/// İşletmenin lota bağlı hasatları (lot, arılık, kg); işletme yoksa boş.

final class LotHarvestSharesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LotHarvestShare>>,
          List<LotHarvestShare>,
          Stream<List<LotHarvestShare>>
        >
    with
        $FutureModifier<List<LotHarvestShare>>,
        $StreamProvider<List<LotHarvestShare>> {
  /// İşletmenin lota bağlı hasatları (lot, arılık, kg); işletme yoksa boş.
  LotHarvestSharesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lotHarvestSharesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lotHarvestSharesHash();

  @$internal
  @override
  $StreamProviderElement<List<LotHarvestShare>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LotHarvestShare>> create(Ref ref) {
    return lotHarvestShares(ref);
  }
}

String _$lotHarvestSharesHash() => r'350dc50dfdb51cfc2601d031ef460cc400434e42';

/// Oturumdaki işletmenin müşterileri, ada göre; işletme yoksa boş.

@ProviderFor(customerList)
final customerListProvider = CustomerListProvider._();

/// Oturumdaki işletmenin müşterileri, ada göre; işletme yoksa boş.

final class CustomerListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Customer>>,
          List<Customer>,
          Stream<List<Customer>>
        >
    with $FutureModifier<List<Customer>>, $StreamProvider<List<Customer>> {
  /// Oturumdaki işletmenin müşterileri, ada göre; işletme yoksa boş.
  CustomerListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerListHash();

  @$internal
  @override
  $StreamProviderElement<List<Customer>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Customer>> create(Ref ref) {
    return customerList(ref);
  }
}

String _$customerListHash() => r'ead292c55718e28559b9853055b91d195e59ceb0';

/// Müşteri; yoksa ya da silinmişse null.

@ProviderFor(customer)
final customerProvider = CustomerFamily._();

/// Müşteri; yoksa ya da silinmişse null.

final class CustomerProvider
    extends
        $FunctionalProvider<AsyncValue<Customer?>, Customer?, Stream<Customer?>>
    with $FutureModifier<Customer?>, $StreamProvider<Customer?> {
  /// Müşteri; yoksa ya da silinmişse null.
  CustomerProvider._({
    required CustomerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerHash();

  @override
  String toString() {
    return r'customerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Customer?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Customer?> create(Ref ref) {
    final argument = this.argument as String;
    return customer(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerHash() => r'd9c32ee45cc54c3172b336ede8aef86b83386913';

/// Müşteri; yoksa ya da silinmişse null.

final class CustomerFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Customer?>, String> {
  CustomerFamily._()
    : super(
        retry: null,
        name: r'customerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Müşteri; yoksa ya da silinmişse null.

  CustomerProvider call(String id) =>
      CustomerProvider._(argument: id, from: this);

  @override
  String toString() => r'customerProvider';
}

/// Müşterinin satışları, yeni önce.

@ProviderFor(customerSales)
final customerSalesProvider = CustomerSalesFamily._();

/// Müşterinin satışları, yeni önce.

final class CustomerSalesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionRow>>,
          List<TransactionRow>,
          Stream<List<TransactionRow>>
        >
    with
        $FutureModifier<List<TransactionRow>>,
        $StreamProvider<List<TransactionRow>> {
  /// Müşterinin satışları, yeni önce.
  CustomerSalesProvider._({
    required CustomerSalesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerSalesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerSalesHash();

  @override
  String toString() {
    return r'customerSalesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<TransactionRow>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionRow>> create(Ref ref) {
    final argument = this.argument as String;
    return customerSales(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerSalesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerSalesHash() => r'4ef86ba05762514e145e9681c71d4f575aec5eec';

/// Müşterinin satışları, yeni önce.

final class CustomerSalesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<TransactionRow>>, String> {
  CustomerSalesFamily._()
    : super(
        retry: null,
        name: r'customerSalesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Müşterinin satışları, yeni önce.

  CustomerSalesProvider call(String customerId) =>
      CustomerSalesProvider._(argument: customerId, from: this);

  @override
  String toString() => r'customerSalesProvider';
}

/// Müşteriler alacaklarıyla, ada göre.

@ProviderFor(customerSummaries)
final customerSummariesProvider = CustomerSummariesProvider._();

/// Müşteriler alacaklarıyla, ada göre.

final class CustomerSummariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CustomerSummary>>,
          List<CustomerSummary>,
          FutureOr<List<CustomerSummary>>
        >
    with
        $FutureModifier<List<CustomerSummary>>,
        $FutureProvider<List<CustomerSummary>> {
  /// Müşteriler alacaklarıyla, ada göre.
  CustomerSummariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerSummariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerSummariesHash();

  @$internal
  @override
  $FutureProviderElement<List<CustomerSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CustomerSummary>> create(Ref ref) {
    return customerSummaries(ref);
  }
}

String _$customerSummariesHash() => r'b19d6e45d1762a59e13b7ba51682e285463736a6';

/// İşletmenin para birimindeki alacakların özeti: silinmemiş müşterilerin
/// satışlarının kalanı ve alacağı olan müşteri sayısı.

@ProviderFor(receivables)
final receivablesProvider = ReceivablesProvider._();

/// İşletmenin para birimindeki alacakların özeti: silinmemiş müşterilerin
/// satışlarının kalanı ve alacağı olan müşteri sayısı.

final class ReceivablesProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReceivablesSummary?>,
          ReceivablesSummary?,
          FutureOr<ReceivablesSummary?>
        >
    with
        $FutureModifier<ReceivablesSummary?>,
        $FutureProvider<ReceivablesSummary?> {
  /// İşletmenin para birimindeki alacakların özeti: silinmemiş müşterilerin
  /// satışlarının kalanı ve alacağı olan müşteri sayısı.
  ReceivablesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receivablesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receivablesHash();

  @$internal
  @override
  $FutureProviderElement<ReceivablesSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReceivablesSummary?> create(Ref ref) {
    return receivables(ref);
  }
}

String _$receivablesHash() => r'06221cde275459a8196434fcee5821968c299880';

/// Fiş fotoğrafı bu telefonda varsa; yoksa (henüz inmedi) null.

@ProviderFor(receiptFile)
final receiptFileProvider = ReceiptFileFamily._();

/// Fiş fotoğrafı bu telefonda varsa; yoksa (henüz inmedi) null.

final class ReceiptFileProvider
    extends $FunctionalProvider<AsyncValue<File?>, File?, FutureOr<File?>>
    with $FutureModifier<File?>, $FutureProvider<File?> {
  /// Fiş fotoğrafı bu telefonda varsa; yoksa (henüz inmedi) null.
  ReceiptFileProvider._({
    required ReceiptFileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'receiptFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$receiptFileHash();

  @override
  String toString() {
    return r'receiptFileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<File?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<File?> create(Ref ref) {
    final argument = this.argument as String;
    return receiptFile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReceiptFileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$receiptFileHash() => r'b57730c9f780234a099c09a11562a3e1a83ebf5b';

/// Fiş fotoğrafı bu telefonda varsa; yoksa (henüz inmedi) null.

final class ReceiptFileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<File?>, String> {
  ReceiptFileFamily._()
    : super(
        retry: null,
        name: r'receiptFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fiş fotoğrafı bu telefonda varsa; yoksa (henüz inmedi) null.

  ReceiptFileProvider call(String storagePath) =>
      ReceiptFileProvider._(argument: storagePath, from: this);

  @override
  String toString() => r'receiptFileProvider';
}

/// Hareket yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da
/// çalışsın diye sürekli yaşar.

@ProviderFor(FinanceActions)
final financeActionsProvider = FinanceActionsProvider._();

/// Hareket yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da
/// çalışsın diye sürekli yaşar.
final class FinanceActionsProvider
    extends $NotifierProvider<FinanceActions, void> {
  /// Hareket yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da
  /// çalışsın diye sürekli yaşar.
  FinanceActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financeActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financeActionsHash();

  @$internal
  @override
  FinanceActions create() => FinanceActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$financeActionsHash() => r'140c9af2c4c5805256643efeffc3bd55abec62da';

/// Hareket yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da
/// çalışsın diye sürekli yaşar.

abstract class _$FinanceActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
