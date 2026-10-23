import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_label_providers.g.dart';

/// İşletmenin kovanları (her durumda); numaralar sayı sırasıyla. İşletme
/// yoksa boş.
@riverpod
Stream<List<Hive>> organizationHives(Ref ref) {
  final orgId = ref.watch(
    currentOrganizationProvider.select(
      (organization) => organization.value?.id,
    ),
  );
  if (orgId == null) return Stream.value(const []);
  return ref
      .watch(hiveRepositoryProvider)
      .watchAll(orgId)
      .map(
        (hives) => hives..sort((a, b) => compareNatural(a.number, b.number)),
      );
}

/// Okutulan ya da derin linkle gelen etiket kodunu kovana çevirir ve
/// tanınmayan etiketi kovana atar. Her şey yerel DB'de; ağ gerekmez.
@Riverpod(keepAlive: true)
class HiveLabelActions extends _$HiveLabelActions {
  @override
  void build() {}

  /// Koda bağlı kovan; yoksa null. Önce bizim etiketimizdeki kimliğe, sonra
  /// kovanlara atanmış etiket kodlarına bakar. Aktif olmayan kovan da
  /// bulunur.
  Future<Hive?> find(String code) async {
    final repository = ref.read(hiveRepositoryProvider);
    if (hiveIdFromLabelCode(code) case final hiveId?) {
      if (await repository.findById(hiveId) case final hive?) return hive;
    }
    final orgId = ref.read(currentOrganizationProvider).value?.id;
    if (orgId == null) return null;
    return await repository.findByTagCode(
      orgId: orgId,
      tagCode: normalizeLabelCode(code),
    );
  }

  /// Etiketi kovana atar; sonra bu kod okutulunca kovan açılır. Etiket
  /// başka kovandaysa ondan alınır.
  Future<Hive> assign(String hiveId, String code) => ref
      .read(hiveRepositoryProvider)
      .assignTag(hiveId, normalizeLabelCode(code));
}

/// Etiket yazdırmada elle yapılan seçimler (kovan kimliği → seçili mi).
/// Dokunulmamış kovan aktifse seçili sayılır ([isLabelSelected]). Ekran
/// açık kaldığı sürece yaşar.
@riverpod
class HiveLabelSelection extends _$HiveLabelSelection {
  @override
  Map<String, bool> build(String apiaryId) => const {};

  void toggle(Hive hive) =>
      state = {...state, hive.id: !isLabelSelected(hive, state)};

  void selectAll(List<Hive> hives, {required bool selected}) =>
      state = {for (final hive in hives) hive.id: selected};
}

/// Kovan etiket için seçili mi: elle seçilmediyse aktif kovanlar seçili,
/// sönen, satılan gibi aktif olmayanlar seçili değil.
bool isLabelSelected(Hive hive, Map<String, bool> choices) =>
    choices[hive.id] ?? hive.status.isCounted;
