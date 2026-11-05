import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/sync/sync_reminder.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/reminder_notifications.dart';
import 'package:mobil_arici/core/sync/sync_backup_rules.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/fake_reminder_notifications.dart';
import '../../helpers/test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Gündüz; 3 gün sonrası da gündüz.
  final now = DateTime(2026, 11, 5, 15);
  late AppDatabase db;
  late FakeReminderNotifications notifications;
  late ProviderContainer container;

  setUp(() async {
    db = openTestDatabase();
    notifications = FakeReminderNotifications();
    container = ProviderContainer.test(
      overrides: signedIn(db: db, reminders: notifications),
    );
    await container.read(currentOrganizationProvider.future);
  });

  Future<void> settle() async {
    await pumpEventQueue();
    await container.read(syncReminderProvider.notifier).resync();
  }

  Future<void> start() async {
    container.listen(syncReminderProvider, (_, _) {});
    await settle();
  }

  /// [at]'te yazılmış bir arılık kaydı; outbox'a düşer.
  Future<void> write(DateTime at) => ApiaryRepository(
    db,
    clock: () => at,
  ).create(orgId: testOrganization.id, name: 'Yayla');

  Map<int, Reminder> scheduled() =>
      notifications.groups[ReminderGroups.sync] ?? const {};

  test('bekleyen yoksa bildirim kurulmaz', () async {
    await withClock(Clock.fixed(now), () async {
      await start();
      expect(scheduled(), isEmpty);
    });
  });

  test('en eski bekleyen kayıttan 3 gün sonraya tek bildirim; metinde '
      'bekleyen sayısı', () async {
    await withClock(Clock.fixed(now), () async {
      await write(now.subtract(const Duration(hours: 2)));
      await write(now);
      await start();

      final reminder = scheduled()[syncReminderId]!;
      expect(scheduled(), hasLength(1));
      expect(reminder.at, DateTime(2026, 11, 8, 13));
      expect(reminder.title, "Your records aren't backed up yet");
      expect(
        reminder.body,
        "2 records haven't reached the server for 3 days. Open the app when "
        "you're online.",
      );
    });
  });

  test('kayıtlar gönderilince ya da reddedilince bildirim kalkar', () async {
    await withClock(Clock.fixed(now), () async {
      await write(now);
      await start();
      expect(scheduled(), hasLength(1));

      // Reddedilen kayıt bekleyen sayılmaz; senkron ekranı onu gösterir.
      await db
          .update(db.outbox)
          .write(const OutboxCompanion(lastError: Value('invalid: x')));
      await settle();
      expect(scheduled(), isEmpty);

      await write(now);
      await settle();
      expect(scheduled(), hasLength(1));
      await db.delete(db.outbox).go();
      await settle();
      expect(scheduled(), isEmpty);
    });
  });

  test('an geçtiyse bildirim kurulmaz; uyarı ekranda', () async {
    await withClock(Clock.fixed(now), () async {
      await write(now.subtract(const Duration(days: 4)));
      await start();
      expect(scheduled(), isEmpty);
    });
  });

  test('Türkçe metin', () async {
    await withClock(Clock.fixed(now), () async {
      await write(now);
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await start();

      final reminder = scheduled()[syncReminderId]!;
      expect(reminder.title, 'Kayıtların henüz yedeklenmedi');
      expect(
        reminder.body,
        '1 kayıt 3 gündür sunucuya gönderilemedi. İnternete bağlanınca '
        'uygulamayı aç.',
      );
    });
  });
}
