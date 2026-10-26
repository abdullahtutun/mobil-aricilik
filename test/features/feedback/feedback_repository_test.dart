import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/feedback/data/feedback_repository.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late FeedbackRepository feedback;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    feedback = FeedbackRepository(db, clock: clock.call);
  });

  test("görüşü kuyruğa yazar; outbox'a yazmaz", () async {
    final id = await feedback.queue(
      orgId: 'org-1',
      kind: FeedbackKind.missingFeature,
      message: 'Ekip modülü',
      screenshotFileName: 'feedback-1.jpg',
      deviceInfo: {'app_version': '1.0.0+1'},
    );

    final row = await feedback.nextDue();
    expect(row!.id, id);
    expect(row.orgId, 'org-1');
    expect(row.kind, FeedbackKind.missingFeature);
    expect(row.message, 'Ekip modülü');
    expect(row.screenshotFileName, 'feedback-1.jpg');
    expect(jsonDecode(row.deviceInfo!), {'app_version': '1.0.0+1'});
    expect(row.createdAt, clock.current);
    expect(await readOutbox(db), isEmpty);
  });

  test('ertelenen görüş zamanı gelince yeniden sıraya girer', () async {
    await feedback.queue(
      orgId: 'org-1',
      kind: FeedbackKind.bug,
      message: 'Hata',
    );
    final row = (await feedback.nextDue())!;

    await feedback.postpone(
      row,
      retryAt: clock.current.add(const Duration(minutes: 1)),
      error: 'offline',
    );
    expect(await feedback.nextDue(), isNull);

    clock.advance(const Duration(minutes: 1));
    final again = (await feedback.nextDue())!;
    expect(again.attempts, 1);
    expect(again.lastError, 'offline');
  });

  test('kalıcı hata alan görüş gönderilmez ve sayılmaz', () async {
    await feedback.queue(
      orgId: 'org-1',
      kind: FeedbackKind.bug,
      message: 'Hata',
    );
    expect(await feedback.watchPendingCount().first, 1);

    await feedback.fail((await feedback.nextDue())!, '42501: forbidden');

    expect(await feedback.nextDue(), isNull);
    expect(await feedback.watchPendingCount().first, 0);
  });

  test('en eski görüş önce gider; remove siler', () async {
    final first = await feedback.queue(
      orgId: 'org-1',
      kind: FeedbackKind.bug,
      message: 'Birinci',
    );
    clock.advance(const Duration(seconds: 1));
    final second = await feedback.queue(
      orgId: 'org-1',
      kind: FeedbackKind.thanks,
      message: 'İkinci',
    );

    expect((await feedback.nextDue())!.id, first);
    await feedback.remove(first);
    expect((await feedback.nextDue())!.id, second);
  });
}
