import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/reminder_notifications.dart';
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/documents/presentation/document_reminders.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/presentation/task_reminders.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_reminder_notifications.dart';
import '../../../helpers/test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 10, 27, 15);
  late AppDatabase db;
  late FakeReminderNotifications notifications;
  late FakeAuthService auth;
  late ProviderContainer container;
  late DocumentRepository documents;
  final orgId = testOrganization.id;

  setUp(() async {
    db = openTestDatabase();
    notifications = FakeReminderNotifications();
    auth = FakeAuthService(user: testUser);
    documents = DocumentRepository(db);
    container = ProviderContainer.test(
      overrides: signedIn(db: db, auth: auth, reminders: notifications),
    );
    await container.read(currentOrganizationProvider.future);
  });

  Future<void> settle() async {
    await pumpEventQueue();
    await container.read(documentRemindersProvider.notifier).resync();
  }

  Future<void> start() async {
    container.listen(documentRemindersProvider, (_, _) {});
    await settle();
  }

  Future<VaultDocument> add(String name, DateTime? expiresOn) =>
      documents.create(
        orgId: orgId,
        type: DocumentType.healthReport,
        name: name,
        expiresOn: expiresOn,
        file: (fileId: name, kind: DocumentFileKind.pdf, byteSize: 10),
      );

  Map<int, Reminder> scheduled() =>
      notifications.groups[ReminderGroups.documents] ?? const {};

  test("geçerlilik tarihi olan belgeye 30, 7 ve 1 gün kala saat 9'da "
      'bildirim kurulur; süresiz ve geçmiş olanlar kurulmaz', () async {
    await withClock(Clock.fixed(now), () async {
      final report = await add('Sağlık raporu', DateTime(2026, 12));
      await add('Tescil', null);
      await add('Eski izin', DateTime(2026, 10));

      await start();

      expect(scheduled().keys.toSet(), {
        documentReminderId(report.id, 30),
        documentReminderId(report.id, 7),
        documentReminderId(report.id, 1),
      });
      final week = scheduled()[documentReminderId(report.id, 7)]!;
      expect(week.at, DateTime(2026, 11, 24, 9));
      expect(week.title, 'Sağlık raporu');
      expect(week.body, 'Expires in 7 days · Dec 1, 2026');
    });
  });

  test('tarihi değişen ve silinen belge kendiliğinden yansır', () async {
    await withClock(Clock.fixed(now), () async {
      final report = await add('Sağlık raporu', DateTime(2026, 12));
      await start();
      expect(scheduled(), hasLength(3));

      await documents.update(
        report.copyWith(expiresOn: DateTime(2026, 11, 10)),
      );
      await settle();
      // 30 gün önce (11 Ekim) geçti.
      expect(scheduled().keys.toSet(), {
        documentReminderId(report.id, 7),
        documentReminderId(report.id, 1),
      });

      await documents.remove(report.id);
      await settle();
      expect(scheduled(), isEmpty);
    });
  });

  test('Türkçe metin; görev hatırlatmalarına dokunmaz', () async {
    await withClock(Clock.fixed(now), () async {
      await TaskRepository(db).create(
        orgId: orgId,
        title: 'Ziyaret',
        dueAt: DateTime(2026, 10, 28, 9),
      );
      container.listen(taskRemindersProvider, (_, _) {});
      await pumpEventQueue();
      await container.read(taskRemindersProvider.notifier).resync();
      final report = await add('Nakil evrakı', DateTime(2026, 11, 3));
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await start();

      expect(
        scheduled()[documentReminderId(report.id, 1)]!.body,
        '1 gün sonra süresi doluyor · 3 Kas 2026',
      );
      expect(notifications.groups[ReminderGroups.tasks], hasLength(1));
      expect(notifications.channelName, 'Hatırlatmalar');
    });
  });

  test('çıkışta belge hatırlatmaları kalkar', () async {
    await withClock(Clock.fixed(now), () async {
      await add('Sağlık raporu', DateTime(2026, 12));
      await start();
      expect(scheduled(), hasLength(3));

      auth.emit(null);
      await pumpEventQueue();
      await settle();

      expect(scheduled(), isEmpty);
    });
  });
}
