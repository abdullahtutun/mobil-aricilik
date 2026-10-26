import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';

/// Gönderilmeyi bekleyen görüşler (`feedback_queue`). Görüş önce buraya
/// yazılır; ağ gelince `TelemetryUploadService` gönderir ve siler.
/// Senkronlanmaz, outbox'a yazılmaz.
class FeedbackRepository {
  new(this.db, {this.clock = DateTime.now});

  final AppDatabase db;

  final DateTime Function() clock;

  /// Görüşü kuyruğa yazar ve kimliğini döner. [screenshotFileName] medya
  /// klasöründe olmalı; gönderilince silinir.
  Future<String> queue({
    required String orgId,
    required FeedbackKind kind,
    required String message,
    String? screenshotFileName,
    Map<String, String>? deviceInfo,
  }) async {
    final id = generateId();
    await db
        .into(db.feedbackQueue)
        .insert(
          FeedbackQueueCompanion.insert(
            id: id,
            orgId: orgId,
            kind: kind,
            message: message,
            screenshotFileName: Value(screenshotFileName),
            deviceInfo: Value(
              deviceInfo == null ? null : jsonEncode(deviceInfo),
            ),
            createdAt: clock().toUtc(),
          ),
        );
    return id;
  }

  /// Gönderilmeyi bekleyen (kalıcı hata almamış) görüş sayısı.
  Stream<int> watchPendingCount() {
    final count = db.feedbackQueue.id.count();
    return (db.selectOnly(db.feedbackQueue)
          ..addColumns([count])
          ..where(db.feedbackQueue.failed.not()))
        .map((row) => row.read(count) ?? 0)
        .watchSingle();
  }

  /// Zamanı gelmiş en eski bekleyen görüş.
  Future<QueuedFeedback?> nextDue() {
    final now = clock().toUtc();
    return (db.select(db.feedbackQueue)
          ..where(
            (t) =>
                t.failed.not() &
                (t.nextAttemptAt.isNull() |
                    t.nextAttemptAt.isSmallerOrEqualValue(now)),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.createdAt),
            (t) => OrderingTerm.asc(t.id),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Gönderilen görüşü siler.
  Future<void> remove(String id) =>
      (db.delete(db.feedbackQueue)..where((t) => t.id.equals(id))).go();

  /// Geçici hatadan sonra [retryAt]'e erteler.
  Future<void> postpone(
    QueuedFeedback feedback, {
    required DateTime retryAt,
    required String error,
  }) => _update(
    feedback.id,
    FeedbackQueueCompanion(
      attempts: Value(feedback.attempts + 1),
      nextAttemptAt: Value(retryAt.toUtc()),
      lastError: Value(error),
    ),
  );

  /// Yeniden denemenin işe yaramayacağı hata; görüş kuyrukta kalır ama
  /// gönderilmez.
  Future<void> fail(QueuedFeedback feedback, String error) => _update(
    feedback.id,
    FeedbackQueueCompanion(
      attempts: Value(feedback.attempts + 1),
      lastError: Value(error),
      failed: const Value(true),
    ),
  );

  Future<void> _update(String id, FeedbackQueueCompanion values) => (db.update(
    db.feedbackQueue,
  )..where((t) => t.id.equals(id))).write(values);
}
