// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stok kalemi ekleme ([itemId] null) ve düzenleme formu: ad, kategori,
/// birim, konum ve eşik. Düzenlenecek kalem yoksa ya da silinmişse durum
/// null. Yeni kalemin kategorisi [category] (listede açık sekme).

@ProviderFor(InventoryFormController)
final inventoryFormControllerProvider = InventoryFormControllerFamily._();

/// Stok kalemi ekleme ([itemId] null) ve düzenleme formu: ad, kategori,
/// birim, konum ve eşik. Düzenlenecek kalem yoksa ya da silinmişse durum
/// null. Yeni kalemin kategorisi [category] (listede açık sekme).
final class InventoryFormControllerProvider
    extends
        $AsyncNotifierProvider<InventoryFormController, InventoryFormState?> {
  /// Stok kalemi ekleme ([itemId] null) ve düzenleme formu: ad, kategori,
  /// birim, konum ve eşik. Düzenlenecek kalem yoksa ya da silinmişse durum
  /// null. Yeni kalemin kategorisi [category] (listede açık sekme).
  InventoryFormControllerProvider._({
    required InventoryFormControllerFamily super.from,
    required (String?, {InventoryCategory? category}) super.argument,
  }) : super(
         retry: null,
         name: r'inventoryFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inventoryFormControllerHash();

  @override
  String toString() {
    return r'inventoryFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  InventoryFormController create() => InventoryFormController();

  @override
  bool operator ==(Object other) {
    return other is InventoryFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inventoryFormControllerHash() =>
    r'3c2c1bc31c1d2a02c4f1ed41fe61f18e39dc780c';

/// Stok kalemi ekleme ([itemId] null) ve düzenleme formu: ad, kategori,
/// birim, konum ve eşik. Düzenlenecek kalem yoksa ya da silinmişse durum
/// null. Yeni kalemin kategorisi [category] (listede açık sekme).

final class InventoryFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          InventoryFormController,
          AsyncValue<InventoryFormState?>,
          InventoryFormState?,
          FutureOr<InventoryFormState?>,
          (String?, {InventoryCategory? category})
        > {
  InventoryFormControllerFamily._()
    : super(
        retry: null,
        name: r'inventoryFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Stok kalemi ekleme ([itemId] null) ve düzenleme formu: ad, kategori,
  /// birim, konum ve eşik. Düzenlenecek kalem yoksa ya da silinmişse durum
  /// null. Yeni kalemin kategorisi [category] (listede açık sekme).

  InventoryFormControllerProvider call(
    String? itemId, {
    InventoryCategory? category,
  }) => InventoryFormControllerProvider._(
    argument: (itemId, category: category),
    from: this,
  );

  @override
  String toString() => r'inventoryFormControllerProvider';
}

/// Stok kalemi ekleme ([itemId] null) ve düzenleme formu: ad, kategori,
/// birim, konum ve eşik. Düzenlenecek kalem yoksa ya da silinmişse durum
/// null. Yeni kalemin kategorisi [category] (listede açık sekme).

abstract class _$InventoryFormController
    extends $AsyncNotifier<InventoryFormState?> {
  late final _$args = ref.$arg as (String?, {InventoryCategory? category});
  String? get itemId => _$args.$1;
  InventoryCategory? get category => _$args.category;

  FutureOr<InventoryFormState?> build(
    String? itemId, {
    InventoryCategory? category,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<InventoryFormState?>, InventoryFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<InventoryFormState?>, InventoryFormState?>,
              AsyncValue<InventoryFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(_$args.$1, category: _$args.category),
    );
  }
}
