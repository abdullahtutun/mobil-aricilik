import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/services/push_service.dart';
import 'package:mobil_arici/features/tasks/presentation/task_push.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_push_service.dart';
import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakePushService push;
  late FakeDeviceTokenService tokens;

  setUp(() {
    db = openTestDatabase();
    push = FakePushService();
    tokens = FakeDeviceTokenService();
  });

  tearDown(() => db.close());

  ProviderContainer open() {
    // Ayar akışı ilk değerini verene kadar dinlenir.
    return ProviderContainer.test(
        overrides: [...signedIn(db: db, push: push, deviceTokens: tokens)],
      )
      ..listen(pushEnabledProvider, (_, _) {})
      ..listen(pushRegistrationProvider, (_, _) {});
  }

  test('açıkken izin bir kez sorulur ve token kaydedilir', () async {
    open();
    await pumpEventQueue();

    expect(push.permissionRequests, 1);
    expect(tokens.registered, {'token-1': 'android'});
  });

  test('izin verilmediyse token kaydedilmez', () async {
    push.grantOnRequest = false;
    open();
    await pumpEventQueue();

    expect(tokens.registered, isEmpty);
  });

  test('izin daha önce soruldu: yeniden sorulmaz', () async {
    await db
        .into(db.localSettings)
        .insert(
          LocalSettingsCompanion.insert(
            key: 'push_permission_asked',
            value: 'true',
          ),
        );
    push.permitted = true;
    open();
    await pumpEventQueue();

    expect(push.permissionRequests, 0);
    expect(tokens.registered, hasLength(1));
  });

  test('token yenilenince yeni token kaydedilir', () async {
    open();
    await pumpEventQueue();

    push.refreshes.add('token-2');
    await pumpEventQueue();

    expect(tokens.registered.keys, containsAll(['token-1', 'token-2']));
  });

  test('çevrimdışı kayıt hata vermez', () async {
    tokens.offline = true;
    open();
    await pumpEventQueue();

    expect(tokens.registered, isEmpty);
    expect(tokens.calls, ['register:token-1']);
  });

  test('ayardan kapatınca token silinir, açınca yeniden kaydedilir', () async {
    final container = open();
    await pumpEventQueue();
    final registration = container.read(pushRegistrationProvider.notifier);

    await registration.setEnabled(enabled: false);
    await pumpEventQueue();
    expect(tokens.registered, isEmpty);
    expect(await container.read(pushEnabledProvider.future), isFalse);

    await registration.setEnabled(enabled: true);
    await pumpEventQueue();
    expect(tokens.registered, {'token-1': 'android'});
  });

  test('kapalıyken açılışta hiçbir şey sorulmaz ya da kaydedilmez', () async {
    await db
        .into(db.localSettings)
        .insert(
          LocalSettingsCompanion.insert(key: 'push_enabled', value: 'false'),
        );
    open();
    await pumpEventQueue();

    expect(push.permissionRequests, 0);
    expect(tokens.calls, isEmpty);
  });

  test(
    "çıkıştan önce unregister token'ı siler ve cihaz token'ını yeniler",
    () async {
      final container = open();
      await pumpEventQueue();

      await container
          .read(pushRegistrationProvider.notifier)
          .unregister(deleteDeviceToken: true);

      expect(tokens.registered, isEmpty);
      expect(push.tokenDeleted, isTrue);
    },
  );

  group('taskIdOf', () {
    test('görev bildiriminden kimliği alır', () {
      expect(taskIdOf({'type': 'task', 'task_id': 't1'}), 't1');
    });

    test('başka tür ya da eksik alan null', () {
      expect(taskIdOf({'type': 'other', 'task_id': 't1'}), isNull);
      expect(taskIdOf({'type': 'task'}), isNull);
      expect(taskIdOf({'type': 'task', 'task_id': ''}), isNull);
    });
  });
}
