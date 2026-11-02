// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gelir ya da gider ekleme formu. Ekran açık kaldığı sürece yaşar. Her
/// şey yerel DB'ye ve fiş klasörüne yazılır; kaydedilmeden kapanan formun
/// çektiği fiş silinir.

@ProviderFor(TransactionFormController)
final transactionFormControllerProvider = TransactionFormControllerFamily._();

/// Gelir ya da gider ekleme formu. Ekran açık kaldığı sürece yaşar. Her
/// şey yerel DB'ye ve fiş klasörüne yazılır; kaydedilmeden kapanan formun
/// çektiği fiş silinir.
final class TransactionFormControllerProvider
    extends $NotifierProvider<TransactionFormController, TransactionFormState> {
  /// Gelir ya da gider ekleme formu. Ekran açık kaldığı sürece yaşar. Her
  /// şey yerel DB'ye ve fiş klasörüne yazılır; kaydedilmeden kapanan formun
  /// çektiği fiş silinir.
  TransactionFormControllerProvider._({
    required TransactionFormControllerFamily super.from,
    required (TransactionKind, {String? customerId}) super.argument,
  }) : super(
         retry: null,
         name: r'transactionFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionFormControllerHash();

  @override
  String toString() {
    return r'transactionFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TransactionFormController create() => TransactionFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionFormControllerHash() =>
    r'a96323ee8f2022db739857ec55776d3f73ead30c';

/// Gelir ya da gider ekleme formu. Ekran açık kaldığı sürece yaşar. Her
/// şey yerel DB'ye ve fiş klasörüne yazılır; kaydedilmeden kapanan formun
/// çektiği fiş silinir.

final class TransactionFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TransactionFormController,
          TransactionFormState,
          TransactionFormState,
          TransactionFormState,
          (TransactionKind, {String? customerId})
        > {
  TransactionFormControllerFamily._()
    : super(
        retry: null,
        name: r'transactionFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Gelir ya da gider ekleme formu. Ekran açık kaldığı sürece yaşar. Her
  /// şey yerel DB'ye ve fiş klasörüne yazılır; kaydedilmeden kapanan formun
  /// çektiği fiş silinir.

  TransactionFormControllerProvider call(
    TransactionKind kind, {
    String? customerId,
  }) => TransactionFormControllerProvider._(
    argument: (kind, customerId: customerId),
    from: this,
  );

  @override
  String toString() => r'transactionFormControllerProvider';
}

/// Gelir ya da gider ekleme formu. Ekran açık kaldığı sürece yaşar. Her
/// şey yerel DB'ye ve fiş klasörüne yazılır; kaydedilmeden kapanan formun
/// çektiği fiş silinir.

abstract class _$TransactionFormController
    extends $Notifier<TransactionFormState> {
  late final _$args = ref.$arg as (TransactionKind, {String? customerId});
  TransactionKind get kind => _$args.$1;
  String? get customerId => _$args.customerId;

  TransactionFormState build(TransactionKind kind, {String? customerId});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TransactionFormState, TransactionFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionFormState, TransactionFormState>,
              TransactionFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(_$args.$1, customerId: _$args.customerId),
    );
  }
}
