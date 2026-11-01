// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inventoryRepository)
final inventoryRepositoryProvider = InventoryRepositoryProvider._();

final class InventoryRepositoryProvider
    extends
        $FunctionalProvider<
          InventoryRepository,
          InventoryRepository,
          InventoryRepository
        >
    with $Provider<InventoryRepository> {
  InventoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<InventoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryRepository create(Ref ref) {
    return inventoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryRepository>(value),
    );
  }
}

String _$inventoryRepositoryHash() =>
    r'057bde409b5d2f87a90f99336cb4aab90b681945';

/// Oturumdaki işletmenin kalemleri ve stokları; işletme yoksa boş.

@ProviderFor(inventoryStocks)
final inventoryStocksProvider = InventoryStocksProvider._();

/// Oturumdaki işletmenin kalemleri ve stokları; işletme yoksa boş.

final class InventoryStocksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InventoryStock>>,
          List<InventoryStock>,
          Stream<List<InventoryStock>>
        >
    with
        $FutureModifier<List<InventoryStock>>,
        $StreamProvider<List<InventoryStock>> {
  /// Oturumdaki işletmenin kalemleri ve stokları; işletme yoksa boş.
  InventoryStocksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryStocksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryStocksHash();

  @$internal
  @override
  $StreamProviderElement<List<InventoryStock>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<InventoryStock>> create(Ref ref) {
    return inventoryStocks(ref);
  }
}

String _$inventoryStocksHash() => r'0310ef946548e10a4f3eb2dad65cf648e605728d';

/// Kalem ve stoğu; yoksa ya da silinmişse null.

@ProviderFor(inventoryStock)
final inventoryStockProvider = InventoryStockFamily._();

/// Kalem ve stoğu; yoksa ya da silinmişse null.

final class InventoryStockProvider
    extends
        $FunctionalProvider<
          AsyncValue<InventoryStock?>,
          InventoryStock?,
          Stream<InventoryStock?>
        >
    with $FutureModifier<InventoryStock?>, $StreamProvider<InventoryStock?> {
  /// Kalem ve stoğu; yoksa ya da silinmişse null.
  InventoryStockProvider._({
    required InventoryStockFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'inventoryStockProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inventoryStockHash();

  @override
  String toString() {
    return r'inventoryStockProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<InventoryStock?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<InventoryStock?> create(Ref ref) {
    final argument = this.argument as String;
    return inventoryStock(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryStockProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inventoryStockHash() => r'e37f2c439d17ba322cc4d17cab63e86313ffafbe';

/// Kalem ve stoğu; yoksa ya da silinmişse null.

final class InventoryStockFamily extends $Family
    with $FunctionalFamilyOverride<Stream<InventoryStock?>, String> {
  InventoryStockFamily._()
    : super(
        retry: null,
        name: r'inventoryStockProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kalem ve stoğu; yoksa ya da silinmişse null.

  InventoryStockProvider call(String id) =>
      InventoryStockProvider._(argument: id, from: this);

  @override
  String toString() => r'inventoryStockProvider';
}

/// Kalemin hareketleri, yeni önce.

@ProviderFor(inventoryMoves)
final inventoryMovesProvider = InventoryMovesFamily._();

/// Kalemin hareketleri, yeni önce.

final class InventoryMovesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InventoryMove>>,
          List<InventoryMove>,
          Stream<List<InventoryMove>>
        >
    with
        $FutureModifier<List<InventoryMove>>,
        $StreamProvider<List<InventoryMove>> {
  /// Kalemin hareketleri, yeni önce.
  InventoryMovesProvider._({
    required InventoryMovesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'inventoryMovesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inventoryMovesHash();

  @override
  String toString() {
    return r'inventoryMovesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<InventoryMove>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<InventoryMove>> create(Ref ref) {
    final argument = this.argument as String;
    return inventoryMoves(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryMovesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inventoryMovesHash() => r'825f40e937fcad49cdc82f937f3903ee67e807f7';

/// Kalemin hareketleri, yeni önce.

final class InventoryMovesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<InventoryMove>>, String> {
  InventoryMovesFamily._()
    : super(
        retry: null,
        name: r'inventoryMovesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kalemin hareketleri, yeni önce.

  InventoryMovesProvider call(String itemId) =>
      InventoryMovesProvider._(argument: itemId, from: this);

  @override
  String toString() => r'inventoryMovesProvider';
}

/// Besleme türüne göre son düşülen kalem (formdaki varsayılan); işletme
/// yoksa boş.

@ProviderFor(lastFeedingStockItems)
final lastFeedingStockItemsProvider = LastFeedingStockItemsProvider._();

/// Besleme türüne göre son düşülen kalem (formdaki varsayılan); işletme
/// yoksa boş.

final class LastFeedingStockItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<FeedingKind, String>>,
          Map<FeedingKind, String>,
          Stream<Map<FeedingKind, String>>
        >
    with
        $FutureModifier<Map<FeedingKind, String>>,
        $StreamProvider<Map<FeedingKind, String>> {
  /// Besleme türüne göre son düşülen kalem (formdaki varsayılan); işletme
  /// yoksa boş.
  LastFeedingStockItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastFeedingStockItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastFeedingStockItemsHash();

  @$internal
  @override
  $StreamProviderElement<Map<FeedingKind, String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<FeedingKind, String>> create(Ref ref) {
    return lastFeedingStockItems(ref);
  }
}

String _$lastFeedingStockItemsHash() =>
    r'54f66265308dc976d603468df3a3bb6e3e3a156e';

/// İlaca göre son düşülen kalem (formdaki varsayılan, alışveriş listesinde
/// ilacın kalemi); işletme yoksa boş.

@ProviderFor(lastTreatmentStockItems)
final lastTreatmentStockItemsProvider = LastTreatmentStockItemsProvider._();

/// İlaca göre son düşülen kalem (formdaki varsayılan, alışveriş listesinde
/// ilacın kalemi); işletme yoksa boş.

final class LastTreatmentStockItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, String>>,
          Map<String, String>,
          Stream<Map<String, String>>
        >
    with
        $FutureModifier<Map<String, String>>,
        $StreamProvider<Map<String, String>> {
  /// İlaca göre son düşülen kalem (formdaki varsayılan, alışveriş listesinde
  /// ilacın kalemi); işletme yoksa boş.
  LastTreatmentStockItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastTreatmentStockItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastTreatmentStockItemsHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, String>> create(Ref ref) {
    return lastTreatmentStockItems(ref);
  }
}

String _$lastTreatmentStockItemsHash() =>
    r'5d7d06a06af9d991ae93380b73d5c0f20a48b75f';

/// Alışveriş listesi ([shoppingList]): eşik altı kalemler ve açık planlı
/// ilaçlama görevlerinin ihtiyacı; ilaç adları [languageCode] dilinde.

@ProviderFor(shoppingListOf)
final shoppingListOfProvider = ShoppingListOfFamily._();

/// Alışveriş listesi ([shoppingList]): eşik altı kalemler ve açık planlı
/// ilaçlama görevlerinin ihtiyacı; ilaç adları [languageCode] dilinde.

final class ShoppingListOfProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShoppingLine>>,
          List<ShoppingLine>,
          FutureOr<List<ShoppingLine>>
        >
    with
        $FutureModifier<List<ShoppingLine>>,
        $FutureProvider<List<ShoppingLine>> {
  /// Alışveriş listesi ([shoppingList]): eşik altı kalemler ve açık planlı
  /// ilaçlama görevlerinin ihtiyacı; ilaç adları [languageCode] dilinde.
  ShoppingListOfProvider._({
    required ShoppingListOfFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shoppingListOfProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shoppingListOfHash();

  @override
  String toString() {
    return r'shoppingListOfProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ShoppingLine>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ShoppingLine>> create(Ref ref) {
    final argument = this.argument as String;
    return shoppingListOf(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShoppingListOfProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shoppingListOfHash() => r'a96db626dc25cc0871963e77d18a1150f5f16f8e';

/// Alışveriş listesi ([shoppingList]): eşik altı kalemler ve açık planlı
/// ilaçlama görevlerinin ihtiyacı; ilaç adları [languageCode] dilinde.

final class ShoppingListOfFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ShoppingLine>>, String> {
  ShoppingListOfFamily._()
    : super(
        retry: null,
        name: r'shoppingListOfProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Alışveriş listesi ([shoppingList]): eşik altı kalemler ve açık planlı
  /// ilaçlama görevlerinin ihtiyacı; ilaç adları [languageCode] dilinde.

  ShoppingListOfProvider call(String languageCode) =>
      ShoppingListOfProvider._(argument: languageCode, from: this);

  @override
  String toString() => r'shoppingListOfProvider';
}

/// Stok hareketleri ve kalem silme. Bildirimin Geri al'ı sayfa kapandıktan
/// sonra da çalışsın diye sürekli yaşar.

@ProviderFor(InventoryActions)
final inventoryActionsProvider = InventoryActionsProvider._();

/// Stok hareketleri ve kalem silme. Bildirimin Geri al'ı sayfa kapandıktan
/// sonra da çalışsın diye sürekli yaşar.
final class InventoryActionsProvider
    extends $NotifierProvider<InventoryActions, void> {
  /// Stok hareketleri ve kalem silme. Bildirimin Geri al'ı sayfa kapandıktan
  /// sonra da çalışsın diye sürekli yaşar.
  InventoryActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryActionsHash();

  @$internal
  @override
  InventoryActions create() => InventoryActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$inventoryActionsHash() => r'f5cfe5014a1cf088b60201ad119636d63efc35da';

/// Stok hareketleri ve kalem silme. Bildirimin Geri al'ı sayfa kapandıktan
/// sonra da çalışsın diye sürekli yaşar.

abstract class _$InventoryActions extends $Notifier<void> {
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
