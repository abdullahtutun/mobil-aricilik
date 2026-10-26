import 'package:clock/clock.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/design_system/appearance_provider.dart';
import 'package:mobil_arici/core/design_system/appearance_settings.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/data/tour_repository.dart';
import 'package:mobil_arici/features/inspections/domain/apiary_tour.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/tour_rules.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/task_reminders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tour_providers.g.dart';

@Riverpod(keepAlive: true)
TourRepository tourRepository(Ref ref) =>
    TourRepository(ref.watch(appDatabaseProvider));

/// Süren tur; başka işletmenin turu sayılmaz.
@riverpod
Stream<ApiaryTour?> currentTour(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  return ref
      .watch(tourRepositoryProvider)
      .watchTour()
      .map((tour) => tour?.orgId == orgId ? tour : null);
}

/// Arılığın süren turu: kovanları (durumlarıyla) ve sıradaki kovan.
typedef TourProgress = ({ApiaryTour tour, List<TourEntry> entries, Hive? next});

/// [apiaryId] arılığının süren turu; arılıkta tur yoksa null.
@riverpod
Future<TourProgress?> apiaryTour(Ref ref, String apiaryId) async {
  final tour = await ref.watch(currentTourProvider.future);
  if (tour == null || tour.apiaryId != apiaryId) return null;
  final hives = await ref.watch(apiaryHivesProvider(apiaryId).future);
  final entries = tourEntries(tour, hives);
  return (tour: tour, entries: entries, next: nextTourHive(tour, entries));
}

/// [apiaryId] turunda kaydedilen muayeneler.
@riverpod
Stream<List<Inspection>> tourInspections(Ref ref, String apiaryId) async* {
  final progress = await ref.watch(apiaryTourProvider(apiaryId).future);
  if (progress == null) {
    yield const [];
    return;
  }
  yield* ref
      .watch(inspectionRepositoryProvider)
      .watchByIds(progress.tour.inspections.values);
}

/// [apiaryId] turunun özeti; turda tur yoksa null.
@riverpod
Future<TourSummary?> apiaryTourSummary(Ref ref, String apiaryId) async {
  final progress = await ref.watch(apiaryTourProvider(apiaryId).future);
  if (progress == null) return null;
  final inspections = await ref.watch(tourInspectionsProvider(apiaryId).future);
  return tourSummary(progress.tour, progress.entries, inspections);
}

/// [apiaryId] turundaki muayenelerden açılan "tekrar bak" görevleri.
@riverpod
Stream<List<Task>> tourReminderTasks(Ref ref, String apiaryId) async* {
  final progress = await ref.watch(apiaryTourProvider(apiaryId).future);
  if (progress == null) {
    yield const [];
    return;
  }
  yield* ref
      .watch(taskRepositoryProvider)
      .watchBySources(TaskSource.inspection, progress.tour.inspections.values);
}

/// Turda kaydedilip sıradaki kovanın muayenesi açılırken bildirimi
/// gösterilecek muayene.
typedef TourSavedInspection = ({SavedInspection saved, String hiveNumber});

/// Turun eylemleri; yazmalar verildiği sırayla çalışır. Turda açılan
/// güneş modunu tur bitince eski moda döndürmek için bellekte iz tutar.
@Riverpod(keepAlive: true)
class TourActions extends _$TourActions {
  var _queue = Future<void>.value();

  /// Güneş modu turda açıldıysa önceki renk modu.
  AppColorMode? _colorModeBeforeSun;

  TourSavedInspection? _pendingSaved;

  @override
  void build() {}

  TourRepository get _repository => ref.read(tourRepositoryProvider);

  /// [apiaryId] arılığının aktif kovanlarıyla (numara sırasıyla) yeni tur
  /// başlatır; süren tur (başka arılığın da) silinir.
  Future<ApiaryTour> start(String apiaryId) => _serial(() async {
    final hives = await ref.read(hiveRepositoryProvider).findByApiary(apiaryId)
      ..sort((a, b) => compareNatural(a.number, b.number));
    final tour = ApiaryTour(
      orgId: ref.read(currentOrgIdProvider)!,
      apiaryId: apiaryId,
      startedAt: clock.now().toUtc(),
      hiveIds: tourHiveIds(hives),
    );
    await _repository.saveTour(tour);
    return tour;
  });

  Future<void> skip(String hiveId) =>
      _update((tour) => skipTourHive(tour, hiveId));

  /// Kaydedilen muayeneyi tura yazar ve sıradaki kovanı döner; hepsi
  /// bittiyse null. Sıradaki kovan varsa muayenesi açılınca bu kaydın
  /// bildirimi gösterilir ([takePendingSaved]).
  Future<Hive?> record(TourSavedInspection saved) => _serial(() async {
    final tour = await _repository.readTour();
    if (tour == null) return null;
    final updated = recordTourInspection(tour, saved.saved.inspection);
    await _repository.saveTour(updated);
    final hives = await ref
        .read(hiveRepositoryProvider)
        .findByApiary(tour.apiaryId);
    final next = nextTourHive(updated, tourEntries(updated, hives));
    _pendingSaved = next == null ? null : saved;
    return next;
  });

  /// Muayenenin Geri al'ı: kovan turda yeniden bekleyen olur.
  Future<void> undo(Inspection inspection) =>
      _update((tour) => undoTourInspection(tour, inspection));

  /// "Turu bitir": özet bu ana göre.
  Future<void> finish() =>
      _update((tour) => tour.copyWith(finishedAt: clock.now().toUtc()));

  /// Önerilen görevleri tek transaction'da yazar (bana atanmış, turun
  /// arılığına bağlı) ve turu kapatır.
  Future<void> saveTasks(
    ApiaryTour tour,
    List<({String title, DateTime dueAt, String? hiveId})> tasks,
  ) async {
    if (tasks.isNotEmpty) {
      final userId = ref.read(currentUserIdProvider);
      await ref.read(taskRepositoryProvider).createMany(tour.orgId, [
        for (final task in tasks)
          (
            title: task.title,
            dueAt: task.dueAt,
            apiaryId: tour.apiaryId,
            hiveId: task.hiveId,
            assignedTo: userId,
          ),
      ]);
      await ref.read(reminderAccessProvider.notifier).requestNotifications();
    }
    await close();
  }

  /// Turu siler; turda açılan güneş modu kapanır.
  Future<void> close() => _serial(() async {
    _pendingSaved = null;
    await _repository.clearTour();
    setSunMode(enabled: false);
  });

  /// Güneş modunu açar ya da önceki moda döndürür.
  void setSunMode({required bool enabled}) {
    final appearance = ref.read(appearanceProvider.notifier);
    final current = ref.read(appearanceProvider).colorMode;
    if (enabled) {
      if (current == AppColorMode.sun) return;
      _colorModeBeforeSun = current;
      appearance.setColorMode(AppColorMode.sun);
    } else if (_colorModeBeforeSun case final previous?) {
      _colorModeBeforeSun = null;
      if (current == AppColorMode.sun) appearance.setColorMode(previous);
    }
  }

  /// Gösterilecek bildirimi alır; bir kez döner.
  TourSavedInspection? takePendingSaved() {
    final saved = _pendingSaved;
    _pendingSaved = null;
    return saved;
  }

  Future<void> _update(ApiaryTour Function(ApiaryTour tour) change) =>
      _serial(() async {
        final tour = await _repository.readTour();
        if (tour != null) await _repository.saveTour(change(tour));
      });

  Future<T> _serial<T>(Future<T> Function() write) {
    final result = _queue.then((_) => write());
    _queue = result.then((_) {}, onError: (_) {});
    return result;
  }
}
