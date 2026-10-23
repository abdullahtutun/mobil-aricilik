// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_label_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

String _$organizationHivesHash() => r'6a6fd7a47813c48417957de44a44efb7c63f9304';

/// Okutulan ya da derin linkle gelen etiket kodunu kovana çevirir ve
/// tanınmayan etiketi kovana atar. Her şey yerel DB'de; ağ gerekmez.

@ProviderFor(HiveLabelActions)
final hiveLabelActionsProvider = HiveLabelActionsProvider._();

/// Okutulan ya da derin linkle gelen etiket kodunu kovana çevirir ve
/// tanınmayan etiketi kovana atar. Her şey yerel DB'de; ağ gerekmez.
final class HiveLabelActionsProvider
    extends $NotifierProvider<HiveLabelActions, void> {
  /// Okutulan ya da derin linkle gelen etiket kodunu kovana çevirir ve
  /// tanınmayan etiketi kovana atar. Her şey yerel DB'de; ağ gerekmez.
  HiveLabelActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveLabelActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveLabelActionsHash();

  @$internal
  @override
  HiveLabelActions create() => HiveLabelActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$hiveLabelActionsHash() => r'e50ffa9937c42fae633d30f7a69591f901cdc241';

/// Okutulan ya da derin linkle gelen etiket kodunu kovana çevirir ve
/// tanınmayan etiketi kovana atar. Her şey yerel DB'de; ağ gerekmez.

abstract class _$HiveLabelActions extends $Notifier<void> {
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

/// Etiket yazdırmada elle yapılan seçimler (kovan kimliği → seçili mi).
/// Dokunulmamış kovan aktifse seçili sayılır ([isLabelSelected]). Ekran
/// açık kaldığı sürece yaşar.

@ProviderFor(HiveLabelSelection)
final hiveLabelSelectionProvider = HiveLabelSelectionFamily._();

/// Etiket yazdırmada elle yapılan seçimler (kovan kimliği → seçili mi).
/// Dokunulmamış kovan aktifse seçili sayılır ([isLabelSelected]). Ekran
/// açık kaldığı sürece yaşar.
final class HiveLabelSelectionProvider
    extends $NotifierProvider<HiveLabelSelection, Map<String, bool>> {
  /// Etiket yazdırmada elle yapılan seçimler (kovan kimliği → seçili mi).
  /// Dokunulmamış kovan aktifse seçili sayılır ([isLabelSelected]). Ekran
  /// açık kaldığı sürece yaşar.
  HiveLabelSelectionProvider._({
    required HiveLabelSelectionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveLabelSelectionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveLabelSelectionHash();

  @override
  String toString() {
    return r'hiveLabelSelectionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  HiveLabelSelection create() => HiveLabelSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, bool>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HiveLabelSelectionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveLabelSelectionHash() =>
    r'c0dd3fccf5ed9a48a07a2d1a84cc87867796ddcb';

/// Etiket yazdırmada elle yapılan seçimler (kovan kimliği → seçili mi).
/// Dokunulmamış kovan aktifse seçili sayılır ([isLabelSelected]). Ekran
/// açık kaldığı sürece yaşar.

final class HiveLabelSelectionFamily extends $Family
    with
        $ClassFamilyOverride<
          HiveLabelSelection,
          Map<String, bool>,
          Map<String, bool>,
          Map<String, bool>,
          String
        > {
  HiveLabelSelectionFamily._()
    : super(
        retry: null,
        name: r'hiveLabelSelectionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Etiket yazdırmada elle yapılan seçimler (kovan kimliği → seçili mi).
  /// Dokunulmamış kovan aktifse seçili sayılır ([isLabelSelected]). Ekran
  /// açık kaldığı sürece yaşar.

  HiveLabelSelectionProvider call(String apiaryId) =>
      HiveLabelSelectionProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'hiveLabelSelectionProvider';
}

/// Etiket yazdırmada elle yapılan seçimler (kovan kimliği → seçili mi).
/// Dokunulmamış kovan aktifse seçili sayılır ([isLabelSelected]). Ekran
/// açık kaldığı sürece yaşar.

abstract class _$HiveLabelSelection extends $Notifier<Map<String, bool>> {
  late final _$args = ref.$arg as String;
  String get apiaryId => _$args;

  Map<String, bool> build(String apiaryId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<String, bool>, Map<String, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, bool>, Map<String, bool>>,
              Map<String, bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
