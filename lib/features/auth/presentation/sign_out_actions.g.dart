// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_out_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Çıkış. Ekranın dinlemesi silme sürerken bitebilir; `keepAlive` olmazsa
/// `ref` ilk `await`'ten sonra geçersiz olur.

@ProviderFor(signOutActions)
final signOutActionsProvider = SignOutActionsProvider._();

/// Çıkış. Ekranın dinlemesi silme sürerken bitebilir; `keepAlive` olmazsa
/// `ref` ilk `await`'ten sonra geçersiz olur.

final class SignOutActionsProvider
    extends $FunctionalProvider<SignOutActions, SignOutActions, SignOutActions>
    with $Provider<SignOutActions> {
  /// Çıkış. Ekranın dinlemesi silme sürerken bitebilir; `keepAlive` olmazsa
  /// `ref` ilk `await`'ten sonra geçersiz olur.
  SignOutActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signOutActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signOutActionsHash();

  @$internal
  @override
  $ProviderElement<SignOutActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignOutActions create(Ref ref) {
    return signOutActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignOutActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignOutActions>(value),
    );
  }
}

String _$signOutActionsHash() => r'b0262c50de244a7891108b201aafef78ead5a535';
