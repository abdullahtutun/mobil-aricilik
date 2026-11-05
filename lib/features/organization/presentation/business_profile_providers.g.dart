// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Oturumdaki işletmenin profili; işletme yoksa null. Offline açılır: yalnız
/// yerel DB ve cihazdaki işletme kopyası okunur.

@ProviderFor(businessProfile)
final businessProfileProvider = BusinessProfileProvider._();

/// Oturumdaki işletmenin profili; işletme yoksa null. Offline açılır: yalnız
/// yerel DB ve cihazdaki işletme kopyası okunur.

final class BusinessProfileProvider
    extends
        $FunctionalProvider<
          OrganizationProfile?,
          OrganizationProfile?,
          OrganizationProfile?
        >
    with $Provider<OrganizationProfile?> {
  /// Oturumdaki işletmenin profili; işletme yoksa null. Offline açılır: yalnız
  /// yerel DB ve cihazdaki işletme kopyası okunur.
  BusinessProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessProfileHash();

  @$internal
  @override
  $ProviderElement<OrganizationProfile?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrganizationProfile? create(Ref ref) {
    return businessProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrganizationProfile? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrganizationProfile?>(value),
    );
  }
}

String _$businessProfileHash() => r'a778cb367e3bd7bb350b63ae7915ffd6610a1b3a';

/// Kovan, arılık ve muayene sayısı; kayıtlardan canlı. İşletme yoksa sıfır.

@ProviderFor(businessCounts)
final businessCountsProvider = BusinessCountsProvider._();

/// Kovan, arılık ve muayene sayısı; kayıtlardan canlı. İşletme yoksa sıfır.

final class BusinessCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<BusinessCounts>,
          BusinessCounts,
          Stream<BusinessCounts>
        >
    with $FutureModifier<BusinessCounts>, $StreamProvider<BusinessCounts> {
  /// Kovan, arılık ve muayene sayısı; kayıtlardan canlı. İşletme yoksa sıfır.
  BusinessCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessCountsHash();

  @$internal
  @override
  $StreamProviderElement<BusinessCounts> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<BusinessCounts> create(Ref ref) {
    return businessCounts(ref);
  }
}

String _$businessCountsHash() => r'6acfecdd75f97d555dd7cbcd075b01a329abaf77';

/// Üyeler adlarıyla (ekip kartı); işletme yoksa boş.

@ProviderFor(memberProfiles)
final memberProfilesProvider = MemberProfilesProvider._();

/// Üyeler adlarıyla (ekip kartı); işletme yoksa boş.

final class MemberProfilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemberProfile>>,
          List<MemberProfile>,
          Stream<List<MemberProfile>>
        >
    with
        $FutureModifier<List<MemberProfile>>,
        $StreamProvider<List<MemberProfile>> {
  /// Üyeler adlarıyla (ekip kartı); işletme yoksa boş.
  MemberProfilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberProfilesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberProfilesHash();

  @$internal
  @override
  $StreamProviderElement<List<MemberProfile>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MemberProfile>> create(Ref ref) {
    return memberProfiles(ref);
  }
}

String _$memberProfilesHash() => r'7b4383d8385d9e2e1f65a2fb9bf96431206eed55';

/// Oturumdaki kullanıcının üyeliği (adı ve rolü); üyelik henüz inmemişse
/// null.

@ProviderFor(ownMemberProfile)
final ownMemberProfileProvider = OwnMemberProfileProvider._();

/// Oturumdaki kullanıcının üyeliği (adı ve rolü); üyelik henüz inmemişse
/// null.

final class OwnMemberProfileProvider
    extends $FunctionalProvider<MemberProfile?, MemberProfile?, MemberProfile?>
    with $Provider<MemberProfile?> {
  /// Oturumdaki kullanıcının üyeliği (adı ve rolü); üyelik henüz inmemişse
  /// null.
  OwnMemberProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownMemberProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownMemberProfileHash();

  @$internal
  @override
  $ProviderElement<MemberProfile?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MemberProfile? create(Ref ref) {
    return ownMemberProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemberProfile? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemberProfile?>(value),
    );
  }
}

String _$ownMemberProfileHash() => r'ef1e55a77993cead15dfdfee430c43dd3057ad1b';

/// İşletme satırı ya da kullanıcının adı outbox'ta gönderilmeyi bekliyor
/// mu ("eşitlenecek" rozeti).

@ProviderFor(businessProfilePending)
final businessProfilePendingProvider = BusinessProfilePendingProvider._();

/// İşletme satırı ya da kullanıcının adı outbox'ta gönderilmeyi bekliyor
/// mu ("eşitlenecek" rozeti).

final class BusinessProfilePendingProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// İşletme satırı ya da kullanıcının adı outbox'ta gönderilmeyi bekliyor
  /// mu ("eşitlenecek" rozeti).
  BusinessProfilePendingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessProfilePendingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessProfilePendingHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return businessProfilePending(ref);
  }
}

String _$businessProfilePendingHash() =>
    r'4038fb05571a9d72a2d89964157b5efd988e741e';

/// Logo dosyası bu telefonda varsa; yoksa (henüz inmedi) null.

@ProviderFor(organizationLogoFile)
final organizationLogoFileProvider = OrganizationLogoFileFamily._();

/// Logo dosyası bu telefonda varsa; yoksa (henüz inmedi) null.

final class OrganizationLogoFileProvider
    extends $FunctionalProvider<AsyncValue<File?>, File?, FutureOr<File?>>
    with $FutureModifier<File?>, $FutureProvider<File?> {
  /// Logo dosyası bu telefonda varsa; yoksa (henüz inmedi) null.
  OrganizationLogoFileProvider._({
    required OrganizationLogoFileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'organizationLogoFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$organizationLogoFileHash();

  @override
  String toString() {
    return r'organizationLogoFileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<File?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<File?> create(Ref ref) {
    final argument = this.argument as String;
    return organizationLogoFile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrganizationLogoFileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$organizationLogoFileHash() =>
    r'114f052c66da2b68b2c4fadfa33d52df680efa4f';

/// Logo dosyası bu telefonda varsa; yoksa (henüz inmedi) null.

final class OrganizationLogoFileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<File?>, String> {
  OrganizationLogoFileFamily._()
    : super(
        retry: null,
        name: r'organizationLogoFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Logo dosyası bu telefonda varsa; yoksa (henüz inmedi) null.

  OrganizationLogoFileProvider call(String storagePath) =>
      OrganizationLogoFileProvider._(argument: storagePath, from: this);

  @override
  String toString() => r'organizationLogoFileProvider';
}
