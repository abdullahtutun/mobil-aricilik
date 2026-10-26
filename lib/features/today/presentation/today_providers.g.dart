// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// İşletmedeki her kovanın en son muayenesi, kovan kimliğine göre;
/// işletme yoksa boş.

@ProviderFor(organizationLatestInspections)
final organizationLatestInspectionsProvider =
    OrganizationLatestInspectionsProvider._();

/// İşletmedeki her kovanın en son muayenesi, kovan kimliğine göre;
/// işletme yoksa boş.

final class OrganizationLatestInspectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Inspection>>,
          Map<String, Inspection>,
          Stream<Map<String, Inspection>>
        >
    with
        $FutureModifier<Map<String, Inspection>>,
        $StreamProvider<Map<String, Inspection>> {
  /// İşletmedeki her kovanın en son muayenesi, kovan kimliğine göre;
  /// işletme yoksa boş.
  OrganizationLatestInspectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationLatestInspectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationLatestInspectionsHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, Inspection>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, Inspection>> create(Ref ref) {
    return organizationLatestInspections(ref);
  }
}

String _$organizationLatestInspectionsHash() =>
    r'a2fc42f5a40e8f559d5b5e2bd9ed037ab71e1036';

/// Şerit çıkarma görevi açık olan uygulamalar; işletme yoksa boş.

@ProviderFor(openRemovalTreatments)
final openRemovalTreatmentsProvider = OpenRemovalTreatmentsProvider._();

/// Şerit çıkarma görevi açık olan uygulamalar; işletme yoksa boş.

final class OpenRemovalTreatmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Treatment>>,
          List<Treatment>,
          Stream<List<Treatment>>
        >
    with $FutureModifier<List<Treatment>>, $StreamProvider<List<Treatment>> {
  /// Şerit çıkarma görevi açık olan uygulamalar; işletme yoksa boş.
  OpenRemovalTreatmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openRemovalTreatmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openRemovalTreatmentsHash();

  @$internal
  @override
  $StreamProviderElement<List<Treatment>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Treatment>> create(Ref ref) {
    return openRemovalTreatments(ref);
  }
}

String _$openRemovalTreatmentsHash() =>
    r'15f4afdd3928cd2a222dbd54cd28faf48150d19b';

/// "Dikkat isteyenler": aktif kovanlar gruba göre ([attentionGroups]).
/// Yalnız yerel DB'den birleşir; muayene, görev ya da uygulama değişince
/// yeniden hesaplanır.

@ProviderFor(todayAttention)
final todayAttentionProvider = TodayAttentionProvider._();

/// "Dikkat isteyenler": aktif kovanlar gruba göre ([attentionGroups]).
/// Yalnız yerel DB'den birleşir; muayene, görev ya da uygulama değişince
/// yeniden hesaplanır.

final class TodayAttentionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<AttentionKind, List<AttentionEntry>>>,
          Map<AttentionKind, List<AttentionEntry>>,
          FutureOr<Map<AttentionKind, List<AttentionEntry>>>
        >
    with
        $FutureModifier<Map<AttentionKind, List<AttentionEntry>>>,
        $FutureProvider<Map<AttentionKind, List<AttentionEntry>>> {
  /// "Dikkat isteyenler": aktif kovanlar gruba göre ([attentionGroups]).
  /// Yalnız yerel DB'den birleşir; muayene, görev ya da uygulama değişince
  /// yeniden hesaplanır.
  TodayAttentionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayAttentionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayAttentionHash();

  @$internal
  @override
  $FutureProviderElement<Map<AttentionKind, List<AttentionEntry>>>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<AttentionKind, List<AttentionEntry>>> create(Ref ref) {
    return todayAttention(ref);
  }
}

String _$todayAttentionHash() => r'1a77fb261098d6597ca06fe58c26c83214233b97';

/// Arılık başına dikkat isteyen kovan sayısı; harita pinindeki uyarı
/// rozeti.

@ProviderFor(apiaryAttentionCounts)
final apiaryAttentionCountsProvider = ApiaryAttentionCountsProvider._();

/// Arılık başına dikkat isteyen kovan sayısı; harita pinindeki uyarı
/// rozeti.

final class ApiaryAttentionCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  /// Arılık başına dikkat isteyen kovan sayısı; harita pinindeki uyarı
  /// rozeti.
  ApiaryAttentionCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiaryAttentionCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiaryAttentionCountsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    return apiaryAttentionCounts(ref);
  }
}

String _$apiaryAttentionCountsHash() =>
    r'682051620028674c0d37b8713d2129b5d2601b38';

/// Bugün paneldeki görevler: açık ve günü bugün ya da geçmiş.

@ProviderFor(todayTasks)
final todayTasksProvider = TodayTasksProvider._();

/// Bugün paneldeki görevler: açık ve günü bugün ya da geçmiş.

final class TodayTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TaskView>>,
          List<TaskView>,
          FutureOr<List<TaskView>>
        >
    with $FutureModifier<List<TaskView>>, $FutureProvider<List<TaskView>> {
  /// Bugün paneldeki görevler: açık ve günü bugün ya da geçmiş.
  TodayTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayTasksHash();

  @$internal
  @override
  $FutureProviderElement<List<TaskView>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TaskView>> create(Ref ref) {
    return todayTasks(ref);
  }
}

String _$todayTasksHash() => r'157c2419973d7176ac43ccc992aff07e59404a42';

/// Kurulumun durumu; arılık, aktif kovan ve muayene verisinden.

@ProviderFor(setupProgress)
final setupProgressProvider = SetupProgressProvider._();

/// Kurulumun durumu; arılık, aktif kovan ve muayene verisinden.

final class SetupProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<SetupProgress>,
          SetupProgress,
          FutureOr<SetupProgress>
        >
    with $FutureModifier<SetupProgress>, $FutureProvider<SetupProgress> {
  /// Kurulumun durumu; arılık, aktif kovan ve muayene verisinden.
  SetupProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupProgressHash();

  @$internal
  @override
  $FutureProviderElement<SetupProgress> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SetupProgress> create(Ref ref) {
    return setupProgress(ref);
  }
}

String _$setupProgressHash() => r'a01d1eeaf9c76fd503fecf1a0c6316358ef197c7';

/// [ApiarySummary] listesinden arılık adları, kimliğe göre.

@ProviderFor(apiaryNames)
final apiaryNamesProvider = ApiaryNamesProvider._();

/// [ApiarySummary] listesinden arılık adları, kimliğe göre.

final class ApiaryNamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, String>>,
          Map<String, String>,
          FutureOr<Map<String, String>>
        >
    with
        $FutureModifier<Map<String, String>>,
        $FutureProvider<Map<String, String>> {
  /// [ApiarySummary] listesinden arılık adları, kimliğe göre.
  ApiaryNamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiaryNamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiaryNamesHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, String>> create(Ref ref) {
    return apiaryNames(ref);
  }
}

String _$apiaryNamesHash() => r'422e4b1432d520b5d3f6bc6f84de66edcafa9c02';
