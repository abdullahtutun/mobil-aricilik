import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/sync/sync_repository.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_providers.g.dart';

@Riverpod(keepAlive: true)
SyncRepository syncRepository(Ref ref) =>
    SyncRepository(ref.watch(appDatabaseProvider));

/// Gönderilmeyi bekleyen kayıt sayısı.
@riverpod
Stream<int> syncPendingCount(Ref ref) =>
    ref.watch(syncRepositoryProvider).watchPendingCount();

/// Sunucunun reddettiği kayıtlar.
@riverpod
Stream<List<RejectedRecord>> syncRejected(Ref ref) =>
    ref.watch(syncRepositoryProvider).watchRejected();

/// Bu cihazda ilk tam çekme bitti mi; router ilk girişte sekmeleri bitene
/// kadar açmaz.
@Riverpod(keepAlive: true)
Stream<bool> fullPullDone(Ref ref) =>
    ref.watch(syncRepositoryProvider).watchFullPullDone();

/// Oturum açık ve işletme belli; senkron yalnız o zaman çalışır.
@Riverpod(keepAlive: true)
bool syncReady(Ref ref) =>
    ref.watch(currentUserProvider.select((user) => user != null)) &&
    ref.watch(
      currentOrganizationProvider.select(
        (organization) => organization.value != null,
      ),
    );
