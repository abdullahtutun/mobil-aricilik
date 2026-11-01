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

String _$financeActionsHash() => r'46c2d6f9353da5ad4c24e00377ab87ac0c528c65';

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
