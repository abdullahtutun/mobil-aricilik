import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/analytics/analytics_rules.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';

/// Kullanım olaylarının yerel kuyruğu (`analytics_queue`). Olay önce
/// buraya yazılır, ağ gelince `TelemetryUploadService` gönderir ve siler.
/// Analitik kapalıyken olay yazılmaz.
class AnalyticsRepository {
  new(this.db, {this.clock = DateTime.now});

  final AppDatabase db;

  final DateTime Function() clock;

  /// [event]'i [props]'un güvenli değerleriyle kuyruğa yazar
  /// ([sanitizeAnalyticsProps]). Kuyruk [analyticsQueueLimit]'i aşarsa en
  /// eski olaylar silinir. Kayıt hata atsa da çağıranın işi bozulmasın diye
  /// hata yutulur; analitik hiçbir akışı durdurmaz.
  Future<void> record(
    AnalyticsEvent event, [
    Map<String, Object?> props = const {},
  ]) async {
    try {
      if (!await LocalSettingsRepository(db).analyticsEnabled()) return;
      await db.transaction(() async {
        await db
            .into(db.analyticsQueue)
            .insert(
              AnalyticsQueueCompanion.insert(
                id: generateId(),
                name: event.value,
                props: jsonEncode(sanitizeAnalyticsProps(props)),
                occurredAt: clock().toUtc(),
              ),
            );
        await db.customStatement(
          'DELETE FROM analytics_queue WHERE id NOT IN '
          '(SELECT id FROM analytics_queue ORDER BY occurred_at DESC, id DESC '
          'LIMIT ?)',
          [analyticsQueueLimit],
        );
      });
    } on Object {
      // Analitik yan iş; yerel DB hatası kaydı ya da taramayı bozmasın.
    }
  }

  /// "Kullanım verisi paylaş". Kapatınca bekleyen olaylar silinir;
  /// yeniden açınca kurulum kimliği yenilenir, eski olaylarla bağ kurulmaz.
  Future<void> setEnabled({required bool enabled}) => db.transaction(() async {
    await db
        .into(db.localSettings)
        .insertOnConflictUpdate(
          LocalSettingsCompanion.insert(
            key: LocalSettingsRepository.analyticsEnabledKey,
            value: '$enabled',
          ),
        );
    if (enabled) {
      await _writeInstallId(generateId());
    } else {
      await db.delete(db.analyticsQueue).go();
    }
  });

  /// Bu kurulumun analitik kimliği; yoksa üretip saklar.
  Future<String> installId() => db.transaction(() async {
    final row =
        await (db.select(db.localSettings)..where(
              (t) =>
                  t.key.equals(LocalSettingsRepository.analyticsInstallIdKey),
            ))
            .getSingleOrNull();
    if (row != null) return row.value;
    final id = generateId();
    await _writeInstallId(id);
    return id;
  });

  /// Gönderilmeyi bekleyen en eski [limit] olay.
  Future<List<QueuedAnalyticsEvent>> pending({
    int limit = analyticsBatchSize,
  }) =>
      (db.select(db.analyticsQueue)
            ..orderBy([
              (t) => OrderingTerm.asc(t.occurredAt),
              (t) => OrderingTerm.asc(t.id),
            ])
            ..limit(limit))
          .get();

  /// Gönderilen olayları siler.
  Future<void> remove(Iterable<String> ids) =>
      (db.delete(db.analyticsQueue)..where((t) => t.id.isIn(ids))).go();

  Future<void> _writeInstallId(String id) => db
      .into(db.localSettings)
      .insertOnConflictUpdate(
        LocalSettingsCompanion.insert(
          key: LocalSettingsRepository.analyticsInstallIdKey,
          value: id,
        ),
      );
}
