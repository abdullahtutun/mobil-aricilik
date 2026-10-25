// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queen_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kovana yeni ana verme ([editing] false) ya da kovandaki anayı düzenleme
/// formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa, ya da düzenlenecek
/// ana yoksa durum null. Her şey yerel DB'ye yazılır.

@ProviderFor(QueenFormController)
final queenFormControllerProvider = QueenFormControllerFamily._();

/// Kovana yeni ana verme ([editing] false) ya da kovandaki anayı düzenleme
/// formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa, ya da düzenlenecek
/// ana yoksa durum null. Her şey yerel DB'ye yazılır.
final class QueenFormControllerProvider
    extends $AsyncNotifierProvider<QueenFormController, QueenFormState?> {
  /// Kovana yeni ana verme ([editing] false) ya da kovandaki anayı düzenleme
  /// formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa, ya da düzenlenecek
  /// ana yoksa durum null. Her şey yerel DB'ye yazılır.
  QueenFormControllerProvider._({
    required QueenFormControllerFamily super.from,
    required ({String hiveId, bool editing}) super.argument,
  }) : super(
         retry: null,
         name: r'queenFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$queenFormControllerHash();

  @override
  String toString() {
    return r'queenFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  QueenFormController create() => QueenFormController();

  @override
  bool operator ==(Object other) {
    return other is QueenFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$queenFormControllerHash() =>
    r'881439d17cd3a2d0f1707c7a0a125baa774393ff';

/// Kovana yeni ana verme ([editing] false) ya da kovandaki anayı düzenleme
/// formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa, ya da düzenlenecek
/// ana yoksa durum null. Her şey yerel DB'ye yazılır.

final class QueenFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          QueenFormController,
          AsyncValue<QueenFormState?>,
          QueenFormState?,
          FutureOr<QueenFormState?>,
          ({String hiveId, bool editing})
        > {
  QueenFormControllerFamily._()
    : super(
        retry: null,
        name: r'queenFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovana yeni ana verme ([editing] false) ya da kovandaki anayı düzenleme
  /// formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa, ya da düzenlenecek
  /// ana yoksa durum null. Her şey yerel DB'ye yazılır.

  QueenFormControllerProvider call({
    required String hiveId,
    required bool editing,
  }) => QueenFormControllerProvider._(
    argument: (hiveId: hiveId, editing: editing),
    from: this,
  );

  @override
  String toString() => r'queenFormControllerProvider';
}

/// Kovana yeni ana verme ([editing] false) ya da kovandaki anayı düzenleme
/// formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa, ya da düzenlenecek
/// ana yoksa durum null. Her şey yerel DB'ye yazılır.

abstract class _$QueenFormController extends $AsyncNotifier<QueenFormState?> {
  late final _$args = ref.$arg as ({String hiveId, bool editing});
  String get hiveId => _$args.hiveId;
  bool get editing => _$args.editing;

  FutureOr<QueenFormState?> build({
    required String hiveId,
    required bool editing,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<QueenFormState?>, QueenFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<QueenFormState?>, QueenFormState?>,
              AsyncValue<QueenFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(hiveId: _$args.hiveId, editing: _$args.editing),
    );
  }
}
