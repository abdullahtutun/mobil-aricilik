// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiary_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arılık ekleme ([apiaryId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek arılık yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır; konum GPS'ten gelir, ağ gerekmez.

@ProviderFor(ApiaryFormController)
final apiaryFormControllerProvider = ApiaryFormControllerFamily._();

/// Arılık ekleme ([apiaryId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek arılık yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır; konum GPS'ten gelir, ağ gerekmez.
final class ApiaryFormControllerProvider
    extends $AsyncNotifierProvider<ApiaryFormController, ApiaryFormState?> {
  /// Arılık ekleme ([apiaryId] null) ve düzenleme formu. Ekran açık kaldığı
  /// sürece yaşar. Düzenlenecek arılık yoksa ya da silinmişse durum null.
  /// Her şey yerel DB'ye yazılır; konum GPS'ten gelir, ağ gerekmez.
  ApiaryFormControllerProvider._({
    required ApiaryFormControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'apiaryFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryFormControllerHash();

  @override
  String toString() {
    return r'apiaryFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ApiaryFormController create() => ApiaryFormController();

  @override
  bool operator ==(Object other) {
    return other is ApiaryFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryFormControllerHash() =>
    r'f3e653122047bf0f81af8a813567b638602ab1b0';

/// Arılık ekleme ([apiaryId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek arılık yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır; konum GPS'ten gelir, ağ gerekmez.

final class ApiaryFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ApiaryFormController,
          AsyncValue<ApiaryFormState?>,
          ApiaryFormState?,
          FutureOr<ApiaryFormState?>,
          String?
        > {
  ApiaryFormControllerFamily._()
    : super(
        retry: null,
        name: r'apiaryFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılık ekleme ([apiaryId] null) ve düzenleme formu. Ekran açık kaldığı
  /// sürece yaşar. Düzenlenecek arılık yoksa ya da silinmişse durum null.
  /// Her şey yerel DB'ye yazılır; konum GPS'ten gelir, ağ gerekmez.

  ApiaryFormControllerProvider call(String? apiaryId) =>
      ApiaryFormControllerProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryFormControllerProvider';
}

/// Arılık ekleme ([apiaryId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek arılık yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır; konum GPS'ten gelir, ağ gerekmez.

abstract class _$ApiaryFormController extends $AsyncNotifier<ApiaryFormState?> {
  late final _$args = ref.$arg as String?;
  String? get apiaryId => _$args;

  FutureOr<ApiaryFormState?> build(String? apiaryId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ApiaryFormState?>, ApiaryFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ApiaryFormState?>, ApiaryFormState?>,
              AsyncValue<ApiaryFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
