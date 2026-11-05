import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/document_services_provider.dart';
import 'package:mobil_arici/core/services/logo_file_store_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/services/receipt_file_store_provider.dart';
import 'package:mobil_arici/core/services/secure_storage.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/core/sync/sync_service_provider.dart';
import 'package:mobil_arici/features/account_deletion/data/account_deletion_repository.dart';
import 'package:mobil_arici/features/account_deletion/data/account_deletion_service.dart';
import 'package:mobil_arici/features/account_deletion/data/device_data_wiper.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion_rules.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/task_push.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_deletion_providers.g.dart';

/// Testler sahtesiyle override eder.
@Riverpod(keepAlive: true)
AccountDeletionService accountDeletionService(Ref ref) =>
    SupabaseAccountDeletionService(ref.watch(supabaseClientProvider));

@Riverpod(keepAlive: true)
AccountDeletionRepository accountDeletionRepository(Ref ref) =>
    AccountDeletionRepository(ref.watch(appDatabaseProvider));

/// Testler geçici klasörlerle override eder.
@Riverpod(keepAlive: true)
DeviceDataWiper deviceDataWiper(Ref ref) => DeviceDataWiper(
  db: ref.watch(appDatabaseProvider),
  fileStores: [
    ref.watch(mediaFileStoreProvider),
    ref.watch(documentFileStoreProvider),
    ref.watch(receiptFileStoreProvider),
    ref.watch(logoFileStoreProvider),
  ],
  mapAreas: ref.watch(mapAreaStoreProvider),
  reminders: ref.watch(reminderNotificationsProvider),
  clearSecureStorage: appSecureStorage.deleteAll,
  temporaryDirectory: () async {
    try {
      return await getTemporaryDirectory();
    } on Object {
      return null;
    }
  },
);

/// Oturumdaki işletmede kullanıcının durumu (tek kişilik sahip, ekipli
/// sahip, üye); üyelik henüz inmediyse bilinmiyor.
@riverpod
DeletionScenario deletionScenario(Ref ref) => deletionScenarioOf(
  userId: ref.watch(currentUserProvider.select((user) => user?.id)),
  members: ref.watch(organizationMembersProvider).value ?? const [],
);

/// İşletme silinirse gidecek kayıtların sayıları; yerel DB'den canlı.
@riverpod
Stream<DeletionCounts> deletionCounts(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(emptyDeletionCounts);
  return ref.watch(accountDeletionRepositoryProvider).watchCounts(orgId);
}

/// Oturumdaki kullanıcının bekleyen silme talebi; varsa router kullanıcıyı
/// önce "Hesabın silinmek üzere" ekranına götürür. Giriş yapılınca bir kez
/// sorulur. Sorulamazsa (çevrimdışı) talep yok sayılır; uygulama yine açılır
/// ve sonraki açılışta yeniden sorulur.
@Riverpod(keepAlive: true)
class PendingDeletion extends _$PendingDeletion {
  @override
  Future<DeletionRequestInfo?> build() async {
    final userId = ref.watch(currentUserProvider.select((user) => user?.id));
    if (userId == null) return null;
    try {
      return await ref.read(accountDeletionServiceProvider).pending();
    } on AccountDeletionException {
      return null;
    }
  }

  /// "Devam et": talep iptal edilir, uygulama açılır. Hata
  /// [AccountDeletionException] olarak gelir; talep o zaman sürer.
  Future<void> keepAccount() async {
    await ref.read(accountDeletionServiceProvider).cancel();
    if (ref.mounted) state = const AsyncData(null);
  }

  /// "Çıkış yap": talep sürer; oturum kapanır, telefondaki veriler silinir.
  Future<void> leave() =>
      ref.read(accountDeletionActionsProvider).leaveDevice();
}

/// Son silme talebinin sonucu; bitiş ekranı tarihi buradan okur. Oturum
/// kapandıktan sonra da durur.
typedef DeletionOutcome = ({DeletionRequestInfo request, bool deviceCleared});

@Riverpod(keepAlive: true)
class LastDeletionOutcome extends _$LastDeletionOutcome {
  @override
  DeletionOutcome? build() => null;

  void requested(DeletionRequestInfo request) =>
      state = (request: request, deviceCleared: false);

  void deviceCleared() {
    if (state case final outcome?) {
      state = (request: outcome.request, deviceCleared: true);
    }
  }
}

/// Talep ve cihaz temizliği. İşlem ağ beklerken ekranın dinlemesi bitebilir;
/// `keepAlive` olmazsa `ref` ilk `await`'ten sonra geçersiz olur.
@Riverpod(keepAlive: true)
AccountDeletionActions accountDeletionActions(Ref ref) =>
    AccountDeletionActions(ref);

class AccountDeletionActions {
  const new(this._ref);

  final Ref _ref;

  /// Talebi açar ve sonucunu [lastDeletionOutcomeProvider]'a yazar. Hata
  /// [AccountDeletionException] olarak gelir.
  Future<DeletionRequestInfo> request({
    required String orgId,
    required bool deleteOrganization,
    String? transferTo,
  }) async {
    final request = await _ref
        .read(accountDeletionServiceProvider)
        .request(
          orgId: orgId,
          deleteOrganization: deleteOrganization,
          transferTo: transferTo,
        );
    _ref.read(lastDeletionOutcomeProvider.notifier).requested(request);
    return request;
  }

  /// Oturumu kapatır, süren senkron turunun bitmesini bekler ve telefondaki
  /// her şeyi siler. Sunucu talepte bildirim token'larını zaten sildi.
  Future<void> leaveDevice() async {
    try {
      await _ref.read(pushRegistrationProvider.notifier).unregister();
      await _ref.read(currentUserProvider.notifier).signOut();
      await _ref.read(syncServiceProvider).whenIdle();
      await _ref.read(deviceDataWiperProvider).wipe();
    } on Object {
      // Temizlik elden geldiğince yapılır: her adım ayrı denenir, biri
      // başarısız olsa da diğerleri silinir; akış bitiş ekranında durmaz.
    } finally {
      _ref.invalidate(installedMapAreasProvider);
      _ref.read(lastDeletionOutcomeProvider.notifier).deviceCleared();
    }
  }
}
