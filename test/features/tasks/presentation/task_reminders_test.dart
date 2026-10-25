import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';
import 'package:mobil_arici/features/tasks/presentation/task_reminders.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_reminder_notifications.dart';
import '../../../helpers/test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Görevler bu andan sonraya kurulur; kurallar saati `clock`'tan okur.
  final now = DateTime(2026, 10, 24, 15);
  late AppDatabase db;
  late FakeReminderNotifications notifications;
  late FakeAuthService auth;
  late ProviderContainer container;
  late TaskRepository tasks;
  final orgId = testOrganization.id;

  setUp(() async {
    db = openTestDatabase();
    notifications = FakeReminderNotifications();
    auth = FakeAuthService(user: testUser);
    tasks = TaskRepository(db);
    container = ProviderContainer.test(
      overrides: signedIn(db: db, auth: auth, reminders: notifications),
    );
    await container.read(currentOrganizationProvider.future);
  });

  Future<void> settle() async {
    await pumpEventQueue();
    await container.read(taskRemindersProvider.notifier).resync();
  }

  /// Eşitleyiciyi başlatır (bootstrap gibi) ve DB akışının ilk değerini
  /// bekler.
  Future<void> start() async {
    container.listen(taskRemindersProvider, (_, _) {});
    await settle();
  }

  Future<Task> add(
    String title,
    DateTime dueAt, {
    String? assignedTo,
    String? apiaryId,
  }) => tasks.create(
    orgId: orgId,
    title: title,
    dueAt: dueAt,
    apiaryId: apiaryId,
    assignedTo: assignedTo,
  );

  test('bana atanmış ve atanmamış, ileride olan açık görevler kurulur; '
      'başkasınınki, geçmiş ve tamamlanan kurulmaz', () async {
    await withClock(Clock.fixed(now), () async {
      final apiary = await ApiaryRepository(db)
          .create(orgId: orgId, name: 'Kızılçam');
      final mine = await add(
        'Ana ver',
        DateTime(2026, 10, 25, 9),
        assignedTo: testUser.id,
        apiaryId: apiary.id,
      );
      final open = await add('Şeker al', DateTime(2026, 10, 26, 10));
      await add('Başkası', DateTime(2026, 10, 25), assignedTo: 'someone');
      await add('Geçti', DateTime(2026, 10, 24, 14), assignedTo: testUser.id);
      final done = await add('Bitti', DateTime(2026, 10, 27));
      await tasks.setCompleted(done, completed: true);

      await start();

      expect(notifications.scheduled.keys.toSet(), {
        reminderNotificationId(mine.id),
        reminderNotificationId(open.id),
      });
      final reminder =
          notifications.scheduled[reminderNotificationId(mine.id)]!;
      expect(reminder.at, DateTime(2026, 10, 25, 9));
      expect(reminder.title, 'Ana ver');
      expect(reminder.body, 'Kızılçam');
      expect(
        notifications.scheduled[reminderNotificationId(open.id)]!.body,
        'Your task is due.',
      );
      expect(notifications.channelName, 'Reminders');
    });
  });

  test('tamamlanan, silinen ve günü değişen görev yansır; senkronla gelen '
      'görev kurulur', () async {
    await withClock(Clock.fixed(now), () async {
      final first = await add('Ziyaret', DateTime(2026, 10, 25, 9));
      final second = await add('Varroa sayımı', DateTime(2026, 10, 26, 9));
      await start();
      expect(notifications.scheduled, hasLength(2));

      await tasks.setCompleted(first, completed: true);
      await settle();
      expect(notifications.scheduled.keys, [reminderNotificationId(second.id)]);

      await tasks.update(second.copyWith(dueAt: DateTime(2026, 10, 28, 7)));
      await settle();
      expect(
        notifications.scheduled.values.single.at,
        DateTime(2026, 10, 28, 7),
      );

      // Senkron satırı doğrudan tabloya yazar.
      await db
          .into(db.tasks)
          .insert(
            Task(
              id: 'pulled',
              orgId: orgId,
              title: 'Ekipten',
              dueAt: DateTime(2026, 10, 29, 9).toUtc(),
              createdAt: now.toUtc(),
              updatedAt: now.toUtc(),
              serverSeq: 4,
            ).toInsertable(),
          );
      await settle();
      expect(
        notifications.scheduled.keys,
        contains(reminderNotificationId('pulled')),
      );

      await tasks.delete(second.id);
      await settle();
      expect(notifications.scheduled.keys, [reminderNotificationId('pulled')]);
    });
  });

  test('dil değişince metinler o dilde yeniden kurulur', () async {
    await withClock(Clock.fixed(now), () async {
      final inspectionTask = await tasks.addTreatmentRemoval(
        orgId: orgId,
        groupId: 'group-1',
        apiaryId: 'apiary-1',
        dueAt: DateTime(2026, 11, 5, 9),
      );
      await start();
      final id = reminderNotificationId(inspectionTask.id);
      expect(notifications.scheduled[id]!.title, 'Remove strips');
      expect(notifications.scheduled[id]!.body, 'treatment');

      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await settle();

      expect(notifications.scheduled[id]!.title, 'Şeritleri çıkar');
      expect(notifications.scheduled[id]!.body, 'ilaç');
      expect(notifications.channelName, 'Hatırlatmalar');
    });
  });

  test('çıkışta bütün hatırlatmalar kalkar', () async {
    await withClock(Clock.fixed(now), () async {
      await add('Ziyaret', DateTime(2026, 10, 25, 9));
      await start();
      expect(notifications.scheduled, hasLength(1));

      auth.emit(null);
      await pumpEventQueue();
      await settle();

      expect(notifications.scheduled, isEmpty);
    });
  });

  group('izinler', () {
    test('bildirim izni sorulur; verilmezse false', () async {
      notifications
        ..permitted = false
        ..grantOnRequest = false;

      final granted = await container
          .read(reminderAccessProvider.notifier)
          .requestNotifications();

      expect(granted, isFalse);
      expect(notifications.permissionRequests, 1);
      expect(
        (await container.read(reminderAccessProvider.future)).notifications,
        isFalse,
      );
    });

    test('tam zamanlı alarm izni verilince durum güncellenir ve '
        'hatırlatmalar yeniden kurulur', () async {
      await withClock(Clock.fixed(now), () async {
        notifications.exact = false;
        await add('Ziyaret', DateTime(2026, 10, 25, 9));
        await start();
        expect(
          (await container.read(reminderAccessProvider.future)).exact,
          isFalse,
        );
        final before = notifications.replaceCalls;

        await container.read(reminderAccessProvider.notifier).requestExact();

        expect(notifications.exactRequests, 1);
        expect(
          (await container.read(reminderAccessProvider.future)).exact,
          isTrue,
        );
        expect(notifications.replaceCalls, greaterThan(before));
        expect(notifications.scheduled, hasLength(1));
      });
    });
  });
}
