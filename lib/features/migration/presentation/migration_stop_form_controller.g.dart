// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'migration_stop_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Durak ekleme ([stopId] null) ve düzenleme formu. Yeni durak planın
/// sonuna eklenir, planlı başlar ve bugünden [defaultStopDays] gün sürer.
/// Düzenlenecek durak yoksa ya da silinmişse durum null.

@ProviderFor(MigrationStopFormController)
final migrationStopFormControllerProvider =
    MigrationStopFormControllerFamily._();

/// Durak ekleme ([stopId] null) ve düzenleme formu. Yeni durak planın
/// sonuna eklenir, planlı başlar ve bugünden [defaultStopDays] gün sürer.
/// Düzenlenecek durak yoksa ya da silinmişse durum null.
final class MigrationStopFormControllerProvider
    extends
        $AsyncNotifierProvider<
          MigrationStopFormController,
          MigrationStopFormState?
        > {
  /// Durak ekleme ([stopId] null) ve düzenleme formu. Yeni durak planın
  /// sonuna eklenir, planlı başlar ve bugünden [defaultStopDays] gün sürer.
  /// Düzenlenecek durak yoksa ya da silinmişse durum null.
  MigrationStopFormControllerProvider._({
    required MigrationStopFormControllerFamily super.from,
    required (String, String?) super.argument,
  }) : super(
         retry: null,
         name: r'migrationStopFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$migrationStopFormControllerHash();

  @override
  String toString() {
    return r'migrationStopFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MigrationStopFormController create() => MigrationStopFormController();

  @override
  bool operator ==(Object other) {
    return other is MigrationStopFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$migrationStopFormControllerHash() =>
    r'10f510d6bb425c8812aa07d93bcb94abbe2cf2f7';

/// Durak ekleme ([stopId] null) ve düzenleme formu. Yeni durak planın
/// sonuna eklenir, planlı başlar ve bugünden [defaultStopDays] gün sürer.
/// Düzenlenecek durak yoksa ya da silinmişse durum null.

final class MigrationStopFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MigrationStopFormController,
          AsyncValue<MigrationStopFormState?>,
          MigrationStopFormState?,
          FutureOr<MigrationStopFormState?>,
          (String, String?)
        > {
  MigrationStopFormControllerFamily._()
    : super(
        retry: null,
        name: r'migrationStopFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Durak ekleme ([stopId] null) ve düzenleme formu. Yeni durak planın
  /// sonuna eklenir, planlı başlar ve bugünden [defaultStopDays] gün sürer.
  /// Düzenlenecek durak yoksa ya da silinmişse durum null.

  MigrationStopFormControllerProvider call(
    String migrationId,
    String? stopId,
  ) => MigrationStopFormControllerProvider._(
    argument: (migrationId, stopId),
    from: this,
  );

  @override
  String toString() => r'migrationStopFormControllerProvider';
}

/// Durak ekleme ([stopId] null) ve düzenleme formu. Yeni durak planın
/// sonuna eklenir, planlı başlar ve bugünden [defaultStopDays] gün sürer.
/// Düzenlenecek durak yoksa ya da silinmişse durum null.

abstract class _$MigrationStopFormController
    extends $AsyncNotifier<MigrationStopFormState?> {
  late final _$args = ref.$arg as (String, String?);
  String get migrationId => _$args.$1;
  String? get stopId => _$args.$2;

  FutureOr<MigrationStopFormState?> build(String migrationId, String? stopId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<MigrationStopFormState?>,
              MigrationStopFormState?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<MigrationStopFormState?>,
                MigrationStopFormState?
              >,
              AsyncValue<MigrationStopFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
