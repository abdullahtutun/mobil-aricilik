import 'package:clock/clock.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/queens/data/queen_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'queen_providers.g.dart';

@Riverpod(keepAlive: true)
QueenRepository queenRepository(Ref ref) =>
    QueenRepository(ref.watch(appDatabaseProvider));

/// İşletmenin ana arıları, kayıt sırasıyla. İşletme yoksa boş.
@riverpod
Stream<List<Queen>> organizationQueens(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(queenRepositoryProvider).watchAll(orgId);
}

/// Ana; yoksa ya da silindiyse null.
@riverpod
Stream<Queen?> queen(Ref ref, String queenId) =>
    ref.watch(queenRepositoryProvider).watchById(queenId);

/// Kovandaki ana; kovan ya da ana yoksa null. Ana değişince yeniden kurulur.
@riverpod
Future<Queen?> hiveQueen(Ref ref, String hiveId) async {
  final hive = await ref.watch(hiveProvider(hiveId).future);
  final queenId = hive?.queenId;
  if (queenId == null) return null;
  return await ref.watch(queenProvider(queenId).future);
}

/// Ana kimliğine göre işaret rengi; işaretsiz ana haritada yok. Kovan
/// karolarındaki renk noktası buradan.
@riverpod
Future<Map<String, QueenMarkColor>> queenMarkColors(Ref ref) async => {
  for (final queen in await ref.watch(organizationQueensProvider.future))
    queen.id: ?queen.markColor,
};

/// Aktif kovanlardaki yaşlı analar ([oldQueensInHives]), en yaşlı önce.
@riverpod
Future<List<HiveQueen>> oldQueens(Ref ref) async {
  final (hives, queens) = await (
    ref.watch(organizationHivesProvider.future),
    ref.watch(organizationQueensProvider.future),
  ).wait;
  return oldQueensInHives(hives, queens, currentYear: clock.now().year);
}

/// Kovan kartındaki ana arı eylemleri: yeni ana verme ve geri alma. Geri al
/// snackbar'ı ekran kapandıktan sonra da çalışsın diye sürekli yaşar.
@Riverpod(keepAlive: true)
class QueenActions extends _$QueenActions {
  @override
  void build() {}

  Future<bool> undoGive(QueenGiven given) =>
      ref.read(queenRepositoryProvider).undoGive(given);
}

/// Ana kimliğine göre içinde bulunduğu kovan (her durumda); kovanda olmayan
/// ana haritada yok. Anne ana "Kovan 88" diye buradan anılır.
@riverpod
Future<Map<String, Hive>> hivesByQueen(Ref ref) async => {
  for (final hive in await ref.watch(organizationHivesProvider.future))
    ?hive.queenId: hive,
};
