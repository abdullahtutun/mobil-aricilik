// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'migration_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Göç planı ekleme ([migrationId] null) ve düzenleme formu: yıl ve ad.
/// Düzenlenecek plan yoksa ya da silinmişse durum null. Yeni planın yılı
/// bu yıl, adı [defaultName] (ekranın dilinde).

@ProviderFor(MigrationFormController)
final migrationFormControllerProvider = MigrationFormControllerFamily._();

/// Göç planı ekleme ([migrationId] null) ve düzenleme formu: yıl ve ad.
/// Düzenlenecek plan yoksa ya da silinmişse durum null. Yeni planın yılı
/// bu yıl, adı [defaultName] (ekranın dilinde).
final class MigrationFormControllerProvider
    extends
        $AsyncNotifierProvider<MigrationFormController, MigrationFormState?> {
  /// Göç planı ekleme ([migrationId] null) ve düzenleme formu: yıl ve ad.
  /// Düzenlenecek plan yoksa ya da silinmişse durum null. Yeni planın yılı
  /// bu yıl, adı [defaultName] (ekranın dilinde).
  MigrationFormControllerProvider._({
    required MigrationFormControllerFamily super.from,
    required (String?, {String defaultName}) super.argument,
  }) : super(
         retry: null,
         name: r'migrationFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$migrationFormControllerHash();

  @override
  String toString() {
    return r'migrationFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MigrationFormController create() => MigrationFormController();

  @override
  bool operator ==(Object other) {
    return other is MigrationFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$migrationFormControllerHash() =>
    r'44a1c142144fc4c48e2c5efb593284b215131966';

/// Göç planı ekleme ([migrationId] null) ve düzenleme formu: yıl ve ad.
/// Düzenlenecek plan yoksa ya da silinmişse durum null. Yeni planın yılı
/// bu yıl, adı [defaultName] (ekranın dilinde).

final class MigrationFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MigrationFormController,
          AsyncValue<MigrationFormState?>,
          MigrationFormState?,
          FutureOr<MigrationFormState?>,
          (String?, {String defaultName})
        > {
  MigrationFormControllerFamily._()
    : super(
        retry: null,
        name: r'migrationFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Göç planı ekleme ([migrationId] null) ve düzenleme formu: yıl ve ad.
  /// Düzenlenecek plan yoksa ya da silinmişse durum null. Yeni planın yılı
  /// bu yıl, adı [defaultName] (ekranın dilinde).

  MigrationFormControllerProvider call(
    String? migrationId, {
    String defaultName = '',
  }) => MigrationFormControllerProvider._(
    argument: (migrationId, defaultName: defaultName),
    from: this,
  );

  @override
  String toString() => r'migrationFormControllerProvider';
}

/// Göç planı ekleme ([migrationId] null) ve düzenleme formu: yıl ve ad.
/// Düzenlenecek plan yoksa ya da silinmişse durum null. Yeni planın yılı
/// bu yıl, adı [defaultName] (ekranın dilinde).

abstract class _$MigrationFormController
    extends $AsyncNotifier<MigrationFormState?> {
  late final _$args = ref.$arg as (String?, {String defaultName});
  String? get migrationId => _$args.$1;
  String get defaultName => _$args.defaultName;

  FutureOr<MigrationFormState?> build(
    String? migrationId, {
    String defaultName = '',
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<MigrationFormState?>, MigrationFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MigrationFormState?>, MigrationFormState?>,
              AsyncValue<MigrationFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(_$args.$1, defaultName: _$args.defaultName),
    );
  }
}
