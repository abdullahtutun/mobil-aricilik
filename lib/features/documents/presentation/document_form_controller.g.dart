// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Belge ekleme ([documentId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek belge yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye ve belge klasörüne yazılır; kaydedilmeden kapanan
/// formun seçtiği dosya silinir.

@ProviderFor(DocumentFormController)
final documentFormControllerProvider = DocumentFormControllerFamily._();

/// Belge ekleme ([documentId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek belge yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye ve belge klasörüne yazılır; kaydedilmeden kapanan
/// formun seçtiği dosya silinir.
final class DocumentFormControllerProvider
    extends $AsyncNotifierProvider<DocumentFormController, DocumentFormState?> {
  /// Belge ekleme ([documentId] null) ve düzenleme formu. Ekran açık kaldığı
  /// sürece yaşar. Düzenlenecek belge yoksa ya da silinmişse durum null.
  /// Her şey yerel DB'ye ve belge klasörüne yazılır; kaydedilmeden kapanan
  /// formun seçtiği dosya silinir.
  DocumentFormControllerProvider._({
    required DocumentFormControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'documentFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentFormControllerHash();

  @override
  String toString() {
    return r'documentFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DocumentFormController create() => DocumentFormController();

  @override
  bool operator ==(Object other) {
    return other is DocumentFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentFormControllerHash() =>
    r'4966062f800ed3701bec25dc08b3d999efff6749';

/// Belge ekleme ([documentId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek belge yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye ve belge klasörüne yazılır; kaydedilmeden kapanan
/// formun seçtiği dosya silinir.

final class DocumentFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DocumentFormController,
          AsyncValue<DocumentFormState?>,
          DocumentFormState?,
          FutureOr<DocumentFormState?>,
          String?
        > {
  DocumentFormControllerFamily._()
    : super(
        retry: null,
        name: r'documentFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Belge ekleme ([documentId] null) ve düzenleme formu. Ekran açık kaldığı
  /// sürece yaşar. Düzenlenecek belge yoksa ya da silinmişse durum null.
  /// Her şey yerel DB'ye ve belge klasörüne yazılır; kaydedilmeden kapanan
  /// formun seçtiği dosya silinir.

  DocumentFormControllerProvider call(String? documentId) =>
      DocumentFormControllerProvider._(argument: documentId, from: this);

  @override
  String toString() => r'documentFormControllerProvider';
}

/// Belge ekleme ([documentId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek belge yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye ve belge klasörüne yazılır; kaydedilmeden kapanan
/// formun seçtiği dosya silinir.

abstract class _$DocumentFormController
    extends $AsyncNotifier<DocumentFormState?> {
  late final _$args = ref.$arg as String?;
  String? get documentId => _$args;

  FutureOr<DocumentFormState?> build(String? documentId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DocumentFormState?>, DocumentFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DocumentFormState?>, DocumentFormState?>,
              AsyncValue<DocumentFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
