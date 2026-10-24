// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hiveRepository)
final hiveRepositoryProvider = HiveRepositoryProvider._();

final class HiveRepositoryProvider
    extends $FunctionalProvider<HiveRepository, HiveRepository, HiveRepository>
    with $Provider<HiveRepository> {
  HiveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveRepositoryHash();

  @$internal
  @override
  $ProviderElement<HiveRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HiveRepository create(Ref ref) {
    return hiveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HiveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HiveRepository>(value),
    );
  }
}

String _$hiveRepositoryHash() => r'a0aa1124c7c7aa16dc4881d1ffbb4ea988725a78';

/// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
/// "10").

@ProviderFor(apiaryHives)
final apiaryHivesProvider = ApiaryHivesFamily._();

/// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
/// "10").

final class ApiaryHivesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Hive>>,
          List<Hive>,
          Stream<List<Hive>>
        >
    with $FutureModifier<List<Hive>>, $StreamProvider<List<Hive>> {
  /// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
  /// "10").
  ApiaryHivesProvider._({
    required ApiaryHivesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryHivesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryHivesHash();

  @override
  String toString() {
    return r'apiaryHivesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Hive>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Hive>> create(Ref ref) {
    final argument = this.argument as String;
    return apiaryHives(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryHivesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryHivesHash() => r'914a5de490a88eea1aa6581d01177de417399440';

/// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
/// "10").

final class ApiaryHivesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Hive>>, String> {
  ApiaryHivesFamily._()
    : super(
        retry: null,
        name: r'apiaryHivesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
  /// "10").

  ApiaryHivesProvider call(String apiaryId) =>
      ApiaryHivesProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryHivesProvider';
}

/// İşletmenin kovanları (her durumda); numaralar sayı sırasıyla. İşletme
/// yoksa boş.

@ProviderFor(organizationHives)
final organizationHivesProvider = OrganizationHivesProvider._();

/// İşletmenin kovanları (her durumda); numaralar sayı sırasıyla. İşletme
/// yoksa boş.

final class OrganizationHivesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Hive>>,
          List<Hive>,
          Stream<List<Hive>>
        >
    with $FutureModifier<List<Hive>>, $StreamProvider<List<Hive>> {
  /// İşletmenin kovanları (her durumda); numaralar sayı sırasıyla. İşletme
  /// yoksa boş.
  OrganizationHivesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationHivesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationHivesHash();

  @$internal
  @override
  $StreamProviderElement<List<Hive>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Hive>> create(Ref ref) {
    return organizationHives(ref);
  }
}

String _$organizationHivesHash() => r'66165a9e7ebc62f72f08c44cf062ff71ac080773';

/// Kovan kartı; kovan yoksa ya da silindiyse null.

@ProviderFor(hive)
final hiveProvider = HiveFamily._();

/// Kovan kartı; kovan yoksa ya da silindiyse null.

final class HiveProvider
    extends $FunctionalProvider<AsyncValue<Hive?>, Hive?, Stream<Hive?>>
    with $FutureModifier<Hive?>, $StreamProvider<Hive?> {
  /// Kovan kartı; kovan yoksa ya da silindiyse null.
  HiveProvider._({
    required HiveFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveHash();

  @override
  String toString() {
    return r'hiveProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Hive?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Hive?> create(Ref ref) {
    final argument = this.argument as String;
    return hive(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveHash() => r'c0a702a587ef56f1b0fb5137d9a606aeccf3c2f9';

/// Kovan kartı; kovan yoksa ya da silindiyse null.

final class HiveFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Hive?>, String> {
  HiveFamily._()
    : super(
        retry: null,
        name: r'hiveProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovan kartı; kovan yoksa ya da silindiyse null.

  HiveProvider call(String hiveId) =>
      HiveProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveProvider';
}

/// Arılık detayındaki kovan görünümü: ızgara ya da liste. Yalnız bellekte;
/// uygulama yeniden açılınca ızgaraya döner.

@ProviderFor(HiveLayoutPreference)
final hiveLayoutPreferenceProvider = HiveLayoutPreferenceProvider._();

/// Arılık detayındaki kovan görünümü: ızgara ya da liste. Yalnız bellekte;
/// uygulama yeniden açılınca ızgaraya döner.
final class HiveLayoutPreferenceProvider
    extends $NotifierProvider<HiveLayoutPreference, HiveLayout> {
  /// Arılık detayındaki kovan görünümü: ızgara ya da liste. Yalnız bellekte;
  /// uygulama yeniden açılınca ızgaraya döner.
  HiveLayoutPreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveLayoutPreferenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveLayoutPreferenceHash();

  @$internal
  @override
  HiveLayoutPreference create() => HiveLayoutPreference();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HiveLayout value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HiveLayout>(value),
    );
  }
}

String _$hiveLayoutPreferenceHash() =>
    r'2b8a40d4c7efe1c1027cbd4ac8027eef4a8f84f9';

/// Arılık detayındaki kovan görünümü: ızgara ya da liste. Yalnız bellekte;
/// uygulama yeniden açılınca ızgaraya döner.

abstract class _$HiveLayoutPreference extends $Notifier<HiveLayout> {
  HiveLayout build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HiveLayout, HiveLayout>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HiveLayout, HiveLayout>,
              HiveLayout,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Kovan kartındaki eylemler: durum değiştirme, taşıma ve taşımayı geri
/// alma. Geri al snackbar'ı ekran kapandıktan sonra da çalışsın diye
/// sürekli yaşar. Her şey yerel DB'ye yazılır.

@ProviderFor(HiveActions)
final hiveActionsProvider = HiveActionsProvider._();

/// Kovan kartındaki eylemler: durum değiştirme, taşıma ve taşımayı geri
/// alma. Geri al snackbar'ı ekran kapandıktan sonra da çalışsın diye
/// sürekli yaşar. Her şey yerel DB'ye yazılır.
final class HiveActionsProvider extends $NotifierProvider<HiveActions, void> {
  /// Kovan kartındaki eylemler: durum değiştirme, taşıma ve taşımayı geri
  /// alma. Geri al snackbar'ı ekran kapandıktan sonra da çalışsın diye
  /// sürekli yaşar. Her şey yerel DB'ye yazılır.
  HiveActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveActionsHash();

  @$internal
  @override
  HiveActions create() => HiveActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$hiveActionsHash() => r'f7c01c1f34bba32630628f6728088373f481d595';

/// Kovan kartındaki eylemler: durum değiştirme, taşıma ve taşımayı geri
/// alma. Geri al snackbar'ı ekran kapandıktan sonra da çalışsın diye
/// sürekli yaşar. Her şey yerel DB'ye yazılır.

abstract class _$HiveActions extends $Notifier<void> {
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
