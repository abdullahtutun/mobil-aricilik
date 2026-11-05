// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler sahtesiyle override eder.

@ProviderFor(teamService)
final teamServiceProvider = TeamServiceProvider._();

/// Testler sahtesiyle override eder.

final class TeamServiceProvider
    extends $FunctionalProvider<TeamService, TeamService, TeamService>
    with $Provider<TeamService> {
  /// Testler sahtesiyle override eder.
  TeamServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamServiceHash();

  @$internal
  @override
  $ProviderElement<TeamService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TeamService create(Ref ref) {
    return teamService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TeamService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TeamService>(value),
    );
  }
}

String _$teamServiceHash() => r'5cb9165e6797b8458fedb702204fab459e3cf3ae';

/// Oturumdaki kullanıcının işletmedeki rolü; üyeliği henüz yerel DB'ye
/// inmediyse null.

@ProviderFor(currentRole)
final currentRoleProvider = CurrentRoleProvider._();

/// Oturumdaki kullanıcının işletmedeki rolü; üyeliği henüz yerel DB'ye
/// inmediyse null.

final class CurrentRoleProvider
    extends
        $FunctionalProvider<MembershipRole?, MembershipRole?, MembershipRole?>
    with $Provider<MembershipRole?> {
  /// Oturumdaki kullanıcının işletmedeki rolü; üyeliği henüz yerel DB'ye
  /// inmediyse null.
  CurrentRoleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentRoleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentRoleHash();

  @$internal
  @override
  $ProviderElement<MembershipRole?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MembershipRole? create(Ref ref) {
    return currentRole(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MembershipRole? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MembershipRole?>(value),
    );
  }
}

String _$currentRoleHash() => r'350b54f12de75de3847e9164e538bee577e27c88';

/// Kayıt ekleme/düzenleme butonları görünsün mü (viewer görmez).

@ProviderFor(canWriteRecords)
final canWriteRecordsProvider = CanWriteRecordsProvider._();

/// Kayıt ekleme/düzenleme butonları görünsün mü (viewer görmez).

final class CanWriteRecordsProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Kayıt ekleme/düzenleme butonları görünsün mü (viewer görmez).
  CanWriteRecordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canWriteRecordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canWriteRecordsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canWriteRecords(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canWriteRecordsHash() => r'749e91e4170bee7861898672e01bcae11d572c5b';

/// Arılık ve kovan silme menüde görünsün mü (yalnız owner ve partner).

@ProviderFor(canDeleteApiariesAndHives)
final canDeleteApiariesAndHivesProvider = CanDeleteApiariesAndHivesProvider._();

/// Arılık ve kovan silme menüde görünsün mü (yalnız owner ve partner).

final class CanDeleteApiariesAndHivesProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Arılık ve kovan silme menüde görünsün mü (yalnız owner ve partner).
  CanDeleteApiariesAndHivesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canDeleteApiariesAndHivesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canDeleteApiariesAndHivesHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canDeleteApiariesAndHives(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canDeleteApiariesAndHivesHash() =>
    r'200fff38d9008fcb2654a0f76777580b11477c56';

/// Finans menüsü görünsün mü (worker ve viewer görmez).

@ProviderFor(canSeeFinance)
final canSeeFinanceProvider = CanSeeFinanceProvider._();

/// Finans menüsü görünsün mü (worker ve viewer görmez).

final class CanSeeFinanceProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Finans menüsü görünsün mü (worker ve viewer görmez).
  CanSeeFinanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canSeeFinanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canSeeFinanceHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canSeeFinance(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canSeeFinanceHash() => r'9b9a6ba77fde5941a6ae22ca7464796e8bb592e0';

/// İşletme bilgileri değiştirilebilsin mi (owner ve partner).

@ProviderFor(canEditOrganization)
final canEditOrganizationProvider = CanEditOrganizationProvider._();

/// İşletme bilgileri değiştirilebilsin mi (owner ve partner).

final class CanEditOrganizationProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// İşletme bilgileri değiştirilebilsin mi (owner ve partner).
  CanEditOrganizationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canEditOrganizationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canEditOrganizationHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canEditOrganization(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canEditOrganizationHash() =>
    r'cdf92c7ce078fc1840bc5cace11d4b8c35ae80d0';

/// Üyelerin e-postaları (kullanıcı kimliğine göre). Çevrimdışıysa ya da
/// çağrı başarısızsa boş harita; liste yerel üyeliklerle yine çizilir.

@ProviderFor(memberEmails)
final memberEmailsProvider = MemberEmailsProvider._();

/// Üyelerin e-postaları (kullanıcı kimliğine göre). Çevrimdışıysa ya da
/// çağrı başarısızsa boş harita; liste yerel üyeliklerle yine çizilir.

final class MemberEmailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, String?>>,
          Map<String, String?>,
          FutureOr<Map<String, String?>>
        >
    with
        $FutureModifier<Map<String, String?>>,
        $FutureProvider<Map<String, String?>> {
  /// Üyelerin e-postaları (kullanıcı kimliğine göre). Çevrimdışıysa ya da
  /// çağrı başarısızsa boş harita; liste yerel üyeliklerle yine çizilir.
  MemberEmailsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberEmailsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberEmailsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, String?>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, String?>> create(Ref ref) {
    return memberEmails(ref);
  }
}

String _$memberEmailsHash() => r'7c98e1bb45865aea7563589e84a859dee4780803';

@ProviderFor(activityRepository)
final activityRepositoryProvider = ActivityRepositoryProvider._();

final class ActivityRepositoryProvider
    extends
        $FunctionalProvider<
          ActivityRepository,
          ActivityRepository,
          ActivityRepository
        >
    with $Provider<ActivityRepository> {
  ActivityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityRepositoryHash();

  @$internal
  @override
  $ProviderElement<ActivityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActivityRepository create(Ref ref) {
    return activityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityRepository>(value),
    );
  }
}

String _$activityRepositoryHash() =>
    r'3f7b3e6fe17e1df4012b83e24ab332b8f559cafd';

/// Ekibin son işlemleri, yeniden eskiye; yerel DB'den.

@ProviderFor(recentActivity)
final recentActivityProvider = RecentActivityProvider._();

/// Ekibin son işlemleri, yeniden eskiye; yerel DB'den.

final class RecentActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityEntry>>,
          List<ActivityEntry>,
          Stream<List<ActivityEntry>>
        >
    with
        $FutureModifier<List<ActivityEntry>>,
        $StreamProvider<List<ActivityEntry>> {
  /// Ekibin son işlemleri, yeniden eskiye; yerel DB'den.
  RecentActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentActivityHash();

  @$internal
  @override
  $StreamProviderElement<List<ActivityEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ActivityEntry>> create(Ref ref) {
    return recentActivity(ref);
  }
}

String _$recentActivityHash() => r'f9c7af7dc1e76f1143e9f4af60df9ee807d10a98';

@ProviderFor(InviteController)
final inviteControllerProvider = InviteControllerProvider._();

final class InviteControllerProvider
    extends $NotifierProvider<InviteController, InviteState> {
  InviteControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inviteControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inviteControllerHash();

  @$internal
  @override
  InviteController create() => InviteController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InviteState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InviteState>(value),
    );
  }
}

String _$inviteControllerHash() => r'7a38d1948593cc2e588ac7020d0f27b0f4086602';

abstract class _$InviteController extends $Notifier<InviteState> {
  InviteState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<InviteState, InviteState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InviteState, InviteState>,
              InviteState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Üyelik işlemleri (katılma, rol, çıkarma). Hata [TeamServiceException]
/// olarak gelir. İşlem ağ beklerken ekranın dinlemesi bitebilir; `keepAlive`
/// olmazsa `ref` ilk `await`'ten sonra geçersiz olur.

@ProviderFor(teamActions)
final teamActionsProvider = TeamActionsProvider._();

/// Üyelik işlemleri (katılma, rol, çıkarma). Hata [TeamServiceException]
/// olarak gelir. İşlem ağ beklerken ekranın dinlemesi bitebilir; `keepAlive`
/// olmazsa `ref` ilk `await`'ten sonra geçersiz olur.

final class TeamActionsProvider
    extends $FunctionalProvider<TeamActions, TeamActions, TeamActions>
    with $Provider<TeamActions> {
  /// Üyelik işlemleri (katılma, rol, çıkarma). Hata [TeamServiceException]
  /// olarak gelir. İşlem ağ beklerken ekranın dinlemesi bitebilir; `keepAlive`
  /// olmazsa `ref` ilk `await`'ten sonra geçersiz olur.
  TeamActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamActionsHash();

  @$internal
  @override
  $ProviderElement<TeamActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TeamActions create(Ref ref) {
    return teamActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TeamActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TeamActions>(value),
    );
  }
}

String _$teamActionsHash() => r'156447320b30ab8c58ab3a65be5964ab8b6bad99';
