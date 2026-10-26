import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/analytics/analytics_repository.dart';
import 'package:mobil_arici/core/analytics/analytics_rules.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late AnalyticsRepository analytics;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    analytics = AnalyticsRepository(db, clock: clock.call);
  });

  test('olayı güvenli değerleriyle kuyruğa yazar', () async {
    await analytics.record(AnalyticsEvent.inspectionSaved, {
      'duration_s': 95,
      'hive_number': 'K-12',
    });

    final [event] = await analytics.pending();
    expect(event.name, 'inspection_saved');
    expect(jsonDecode(event.props), {'duration_s': 95});
    expect(event.occurredAt, clock.current);
  });

  test('varsayılan açık; kapalıyken olay yazılmaz', () async {
    expect(await LocalSettingsRepository(db).analyticsEnabled(), isTrue);

    await analytics.setEnabled(enabled: false);
    await analytics.record(AnalyticsEvent.scanFinished, {'result': 'found'});

    expect(await analytics.pending(), isEmpty);
    expect(await LocalSettingsRepository(db).analyticsEnabled(), isFalse);
  });

  test('kapatınca bekleyen olaylar silinir', () async {
    await analytics.record(AnalyticsEvent.scanFinished);
    await analytics.record(AnalyticsEvent.syncPushed);

    await analytics.setEnabled(enabled: false);

    expect(await db.select(db.analyticsQueue).get(), isEmpty);
  });

  test('kurulum kimliği kalıcı; yeniden açınca yenilenir', () async {
    final first = await analytics.installId();
    expect(await analytics.installId(), first);

    await analytics.setEnabled(enabled: false);
    await analytics.setEnabled(enabled: true);

    expect(await analytics.installId(), isNot(first));
  });

  test('kuyruk sınırı aşılınca en eski olaylar silinir', () async {
    for (var i = 0; i < analyticsQueueLimit + 3; i++) {
      clock.advance(const Duration(seconds: 1));
      await analytics.record(AnalyticsEvent.scanFinished, {'n': i});
    }

    final all = await analytics.pending(limit: analyticsQueueLimit + 10);
    expect(all, hasLength(analyticsQueueLimit));
    expect(jsonDecode(all.first.props), {'n': 3});
  });

  test('pending eskiden yeniye ve sınırlı; remove siler', () async {
    for (var i = 0; i < 3; i++) {
      clock.advance(const Duration(seconds: 1));
      await analytics.record(AnalyticsEvent.scanFinished, {'n': i});
    }

    final batch = await analytics.pending(limit: 2);
    expect([for (final e in batch) (jsonDecode(e.props) as Map)['n']], [0, 1]);

    await analytics.remove(batch.map((e) => e.id));
    final [rest] = await analytics.pending();
    expect(jsonDecode(rest.props), {'n': 2});
  });

  test('yerel DB hatası kaydı yapanı bozmaz', () async {
    await db.close();

    await expectLater(analytics.record(AnalyticsEvent.scanFinished), completes);
  });
}
