import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/presentation/task_push.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_push_service.dart';
import '../../../helpers/fake_sync_service.dart';
import '../../../helpers/test_database.dart';

const _title = 'Kestanelikte kat ekle';

final _task = Task(
  id: '019a7f3c-0000-7000-8000-00000000a001',
  orgId: testOrganization.id,
  title: _title,
  assignedTo: testUser.id,
  dueAt: DateTime.utc(2026, 11, 14, 9),
  createdAt: DateTime.utc(2026, 11, 12, 9),
  updatedAt: DateTime.utc(2026, 11, 12, 9),
);

/// P9.2, madde 5: başka telefonda atanan görevin bildirimine, uygulama arka
/// plandayken dokunulur. Bildirim senkrondan önce gelir; görev bu telefona
/// henüz inmemiştir.
void main() {
  setUpAll(() => initializeDateFormatting('tr'));

  late AppDatabase db;
  late FakePushService push;
  late FakeSyncService sync;

  setUp(() {
    db = openTestDatabase();
    push = FakePushService();
    sync = FakeSyncService();
  });

  tearDown(() => db.close());

  Future<void> open(WidgetTester tester) async {
    final container = ProviderContainer.test(
      overrides: [...signedIn(db: db, push: push, sync: sync)],
    )..listen(pushTaskLinksProvider, (_, _) {});
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('görev yerelde yoksa önce senkron, sonra görev açılır', (
    tester,
  ) async {
    // Turun çektiği satır.
    sync.onDone = () => db.into(db.tasks).insert(_task.toInsertable());
    await open(tester);
    final before = sync.syncCount;

    push.opens.add(_task.id);
    await tester.pumpAndSettle();

    expect(sync.syncCount, before + 1);
    expect(find.text(_title), findsWidgets);
    expect(find.text('Görev bulunamadı; silinmiş olabilir.'), findsNothing);
  });

  testWidgets('görev zaten yerelde: tur beklenmeden açılır', (tester) async {
    await tester.runAsync(() => db.into(db.tasks).insert(_task.toInsertable()));
    await open(tester);
    final before = sync.syncCount;

    push.opens.add(_task.id);
    await tester.pumpAndSettle();

    expect(sync.syncCount, before);
    expect(find.text(_title), findsWidgets);
  });

  testWidgets('tur gelmezse ekran beklemeden sonra yine açılır', (
    tester,
  ) async {
    await open(tester);
    sync.gate = Completer<void>();

    push.opens.add(_task.id);
    await tester.pump(pushTaskSyncWait + const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Görev bulunamadı; silinmiş olabilir.'), findsOneWidget);
    sync.gate!.complete();
    await tester.pumpAndSettle();
  });
}
