import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_providers.g.dart';

@Riverpod(keepAlive: true)
HiveRepository hiveRepository(Ref ref) =>
    HiveRepository(ref.watch(appDatabaseProvider));

/// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
/// "10").
@riverpod
Stream<List<Hive>> apiaryHives(Ref ref, String apiaryId) => ref
    .watch(hiveRepositoryProvider)
    .watchByApiary(apiaryId)
    .map(_sortedByNumber);

/// İşletmenin kovanları (her durumda); numaralar sayı sırasıyla. İşletme
/// yoksa boş.
@riverpod
Stream<List<Hive>> organizationHives(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(hiveRepositoryProvider).watchAll(orgId).map(_sortedByNumber);
}

List<Hive> _sortedByNumber(List<Hive> hives) =>
    hives..sort((a, b) => compareNatural(a.number, b.number));

/// Kovan kartı; kovan yoksa ya da silindiyse null.
@riverpod
Stream<Hive?> hive(Ref ref, String hiveId) =>
    ref.watch(hiveRepositoryProvider).watchById(hiveId);

enum HiveLayout { grid, list }

/// Arılık detayındaki kovan görünümü: ızgara ya da liste. Yalnız bellekte;
/// uygulama yeniden açılınca ızgaraya döner.
@Riverpod(keepAlive: true)
class HiveLayoutPreference extends _$HiveLayoutPreference {
  @override
  HiveLayout build() => HiveLayout.grid;

  HiveLayout get layout => state;

  set layout(HiveLayout layout) => state = layout;
}

/// Kovan kartındaki eylemler: durum değiştirme, taşıma ve taşımayı geri
/// alma. Geri al snackbar'ı ekran kapandıktan sonra da çalışsın diye
/// sürekli yaşar. Her şey yerel DB'ye yazılır.
@Riverpod(keepAlive: true)
class HiveActions extends _$HiveActions {
  @override
  void build() {}

  HiveRepository get _repository => ref.read(hiveRepositoryProvider);

  Future<void> setStatus(String hiveId, HiveStatus status) =>
      _repository.setStatus(hiveId, status);

  /// Kovan zaten o arılıktaysa null.
  Future<HiveMove?> move(String hiveId, {required String apiaryId}) =>
      _repository.move(hiveId, apiaryId: apiaryId);

  Future<void> undoMove(HiveMove move) => _repository.undoMove(move);
}
