// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Müşteri ekleme ([customerId] null) ve düzenleme formu: ad, telefon,
/// adres ve not. Düzenlenecek müşteri yoksa ya da silinmişse durum null.

@ProviderFor(CustomerFormController)
final customerFormControllerProvider = CustomerFormControllerFamily._();

/// Müşteri ekleme ([customerId] null) ve düzenleme formu: ad, telefon,
/// adres ve not. Düzenlenecek müşteri yoksa ya da silinmişse durum null.
final class CustomerFormControllerProvider
    extends $AsyncNotifierProvider<CustomerFormController, CustomerFormState?> {
  /// Müşteri ekleme ([customerId] null) ve düzenleme formu: ad, telefon,
  /// adres ve not. Düzenlenecek müşteri yoksa ya da silinmişse durum null.
  CustomerFormControllerProvider._({
    required CustomerFormControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'customerFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerFormControllerHash();

  @override
  String toString() {
    return r'customerFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CustomerFormController create() => CustomerFormController();

  @override
  bool operator ==(Object other) {
    return other is CustomerFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerFormControllerHash() =>
    r'5f4b53eb2dedfb9e17d0a454b27c6d7fa9b69b07';

/// Müşteri ekleme ([customerId] null) ve düzenleme formu: ad, telefon,
/// adres ve not. Düzenlenecek müşteri yoksa ya da silinmişse durum null.

final class CustomerFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CustomerFormController,
          AsyncValue<CustomerFormState?>,
          CustomerFormState?,
          FutureOr<CustomerFormState?>,
          String?
        > {
  CustomerFormControllerFamily._()
    : super(
        retry: null,
        name: r'customerFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Müşteri ekleme ([customerId] null) ve düzenleme formu: ad, telefon,
  /// adres ve not. Düzenlenecek müşteri yoksa ya da silinmişse durum null.

  CustomerFormControllerProvider call(String? customerId) =>
      CustomerFormControllerProvider._(argument: customerId, from: this);

  @override
  String toString() => r'customerFormControllerProvider';
}

/// Müşteri ekleme ([customerId] null) ve düzenleme formu: ad, telefon,
/// adres ve not. Düzenlenecek müşteri yoksa ya da silinmişse durum null.

abstract class _$CustomerFormController
    extends $AsyncNotifier<CustomerFormState?> {
  late final _$args = ref.$arg as String?;
  String? get customerId => _$args;

  FutureOr<CustomerFormState?> build(String? customerId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CustomerFormState?>, CustomerFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CustomerFormState?>, CustomerFormState?>,
              AsyncValue<CustomerFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
