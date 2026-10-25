import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/queens/data/queen_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rules.dart';
import 'package:mobil_arici/features/queens/presentation/queen_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'queen_form_controller.freezed.dart';
part 'queen_form_controller.g.dart';

@freezed
abstract class QueenFormState with _$QueenFormState {
  const factory({
    /// Anayı alan ya da anası düzenlenen kovan.
    required Hive hive,

    /// Düzenlenen ana; yeni anada null.
    String? queenId,
    int? year,
    QueenMarkColor? markColor,
    @Default('') String breed,
    @Default('') String breedLine,
    QueenSource? source,
    @Default(false) bool wingClipped,
    String? motherQueenId,
    @Default(false) bool saving,
  }) = _QueenFormState;

  /// Yeni ana bu yılın: yıl ve rengi öneri olarak dolu gelir.
  factory forNew(Hive hive, {required int currentYear}) => QueenFormState(
    hive: hive,
    year: currentYear,
    markColor: markColorForYear(currentYear),
  );

  factory fromQueen(Hive hive, Queen queen) => QueenFormState(
    hive: hive,
    queenId: queen.id,
    year: queen.year,
    markColor: queen.markColor,
    breed: queen.breed ?? '',
    breedLine: queen.breedLine ?? '',
    source: queen.source,
    wingClipped: queen.wingClipped,
    motherQueenId: queen.motherQueenId,
  );
}

/// Kovana yeni ana verme ([editing] false) ya da kovandaki anayı düzenleme
/// formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa, ya da düzenlenecek
/// ana yoksa durum null. Her şey yerel DB'ye yazılır.
@riverpod
class QueenFormController extends _$QueenFormController {
  @override
  Future<QueenFormState?> build({
    required String hiveId,
    required bool editing,
  }) async {
    final hive = await ref.read(hiveRepositoryProvider).findById(hiveId);
    if (hive == null) return null;
    if (!editing) {
      return QueenFormState.forNew(hive, currentYear: clock.now().year);
    }
    final queenId = hive.queenId;
    final queen = queenId == null
        ? null
        : await ref.read(queenRepositoryProvider).findById(queenId);
    return queen == null ? null : QueenFormState.fromQueen(hive, queen);
  }

  /// Renk yılı izliyorsa yeni yılın rengine geçer
  /// ([markColorAfterYearChange]).
  void selectYear(int? year) => _update(
    (form) => form.copyWith(
      year: year,
      markColor: markColorAfterYearChange(
        fromYear: form.year,
        toYear: year,
        markColor: form.markColor,
      ),
    ),
  );

  void selectMarkColor(QueenMarkColor? markColor) =>
      _update((form) => form.copyWith(markColor: markColor));

  void updateBreed(String breed) =>
      _update((form) => form.copyWith(breed: breed));

  void updateBreedLine(String breedLine) =>
      _update((form) => form.copyWith(breedLine: breedLine));

  void selectSource(QueenSource? source) =>
      _update((form) => form.copyWith(source: source));

  void selectWingClipped({required bool clipped}) =>
      _update((form) => form.copyWith(wingClipped: clipped));

  void selectMother(String? motherQueenId) =>
      _update((form) => form.copyWith(motherQueenId: motherQueenId));

  /// Yeni anayı kovana verir ya da anayı yazar. Yeni anada geri almak için
  /// [QueenGiven] döner; düzenlemede ve yazılamadığında null. Düzenlenen
  /// ana ya da kovan bu arada silindiyse durum null olur.
  Future<QueenGiven?> save() async {
    final form = state.value;
    if (form == null || form.saving) return null;
    final repository = ref.read(queenRepositoryProvider);
    final breed = form.breed.trim();
    final breedLine = form.breedLine.trim();
    _update((form) => form.copyWith(saving: true));

    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      final queenId = form.queenId;
      if (queenId == null) {
        final hive = await ref.read(hiveRepositoryProvider).findById(hiveId);
        if (hive == null) {
          if (ref.mounted) state = const AsyncData(null);
          return null;
        }
        return await repository.giveToHive(
          hiveId,
          year: form.year,
          markColor: form.markColor,
          breed: breed.isEmpty ? null : breed,
          breedLine: breedLine.isEmpty ? null : breedLine,
          source: form.source,
          wingClipped: form.wingClipped,
          motherQueenId: form.motherQueenId,
        );
      }
      // Formda olmayan alanlar (ör. çiftleşme) en son hâlinden alınır.
      final latest = await repository.findById(queenId);
      if (latest == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      await repository.update(
        latest.copyWith(
          year: form.year,
          markColor: form.markColor,
          breed: breed.isEmpty ? null : breed,
          breedLine: breedLine.isEmpty ? null : breedLine,
          source: form.source,
          wingClipped: form.wingClipped,
          motherQueenId: form.motherQueenId,
        ),
      );
      return null;
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(QueenFormState Function(QueenFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
