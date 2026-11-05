import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deleted_screen.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_screen.dart';
import 'package:mobil_arici/features/account_deletion/presentation/deletion_pending_screen.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_email_screen.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/code_entry_form.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/today/presentation/today_screen.dart';

import '../../../helpers/business_seed.dart';
import '../../../helpers/fake_account_deletion_service.dart';
import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_connectivity_service.dart';
import '../../../helpers/fake_media.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

typedef _App = ({
  ProviderContainer container,
  AppDatabase db,
  FakeAuthService auth,
  FakeAccountDeletionService deletion,
  FakeConnectivityService connectivity,
  FakeMedia media,
  FakeSecureStorageWipe secure,
});

/// Kullanıcının ([testUser]) [role] rolünde olduğu "Yılmaz Arıcılık"
/// işletmesini Türkçe açar. [team] ekipteki diğer üyeler (ad, rol).
Future<_App> _open(
  WidgetTester tester, {
  MembershipRole role = MembershipRole.owner,
  Map<String, (String, MembershipRole)> team = const {},
  Future<void> Function(AppDatabase db)? seed,
  String location = AppRoutes.deleteAccount,
  bool online = true,
  DeletionRequestInfo? pending,
}) async {
  final db = openTestDatabase();
  await insertOrganizationRow(db);
  await addMember(db, userId: testUser.id, role: role);
  for (final MapEntry(key: userId, value: (name, memberRole)) in team.entries) {
    await addMember(db, userId: userId, role: memberRole);
    await (db.update(db.memberships)..where((t) => t.userId.equals(userId)))
        .write(MembershipsCompanion(fullName: Value(name)));
  }
  if (seed != null) await seed(db);
  final auth = FakeAuthService(user: testUser);
  final deletion = FakeAccountDeletionService()..pendingRequest = pending;
  final connectivity = FakeConnectivityService()..online = online;
  final media = FakeMedia();
  final secure = FakeSecureStorageWipe();
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(
        db: db,
        auth: auth,
        accountDeletion: deletion,
        connectivity: connectivity,
        media: media,
        secureStorageWipe: secure,
      ),
      teamServiceProvider.overrideWithValue(FakeTeamService(db: db)),
    ],
  );
  container.read(languageProvider.notifier).language = AppLanguage.turkish;
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await _settle(tester);
  if (pending == null) {
    container.read(routerProvider).go(location);
    await _settle(tester);
  }
  return (
    container: container,
    db: db,
    auth: auth,
    deletion: deletion,
    connectivity: connectivity,
    media: media,
    secure: secure,
  );
}

/// Sonsuz animasyon testi 10 dakika asmasın diye süre sınırlı.
Future<void> _settle(WidgetTester tester) => tester.pumpAndSettle(
  const Duration(milliseconds: 100),
  EnginePhase.sendSemanticsUpdate,
  const Duration(seconds: 10),
);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await _settle(tester);
  await tester.tap(finder);
  await _settle(tester);
}

Finder _button(String label) => find.widgetWithText(BigButton, label);

BigButton _bigButton(WidgetTester tester, String label) =>
    tester.widget<BigButton>(_button(label));

Finder get _codeField => find.descendant(
  of: find.byType(CodeEntryForm),
  matching: find.byType(TextField),
);

Finder get _confirmField => find.descendant(
  of: find.byType(LabeledField),
  matching: find.byType(TextField),
);

const _deleteWithOrganization = 'Hesabımı ve işletmemi sil';
const _deleteAccount = 'Hesabımı sil';

/// Yayımlanmış bir lot: herkese açık sayfası ve kavanozlarda QR kodu var.
Future<void> _seedPublishedLot(AppDatabase db) => db.customStatement(
  'INSERT INTO lots (id, org_id, year, seq, honey_kind, status, published, '
  "created_at, updated_at) VALUES ('lot-1', ?, 2026, 1, 'pine', 'open', 1, "
  "'2026-10-01T00:00:00.000Z', '2026-10-01T00:00:00.000Z')",
  [testOrganization.id],
);

Future<void> _seedRecords(AppDatabase db) async {
  await seedCountedRecords(db);
  await _seedPublishedLot(db);
}

/// İlk adımdan kod adımına geçer (yedeği atlar).
Future<void> _toVerify(WidgetTester tester) async {
  await _tap(tester, _button('Devam'));
  expect(find.text('Önce verini al'), findsOneWidget);
  await _tap(tester, _button('Atla'));
  expect(find.text('Kimliğini doğrula'), findsOneWidget);
}

Future<void> _enterCode(WidgetTester tester, String code) async {
  await tester.enterText(_codeField, code);
  await _settle(tester);
}

void main() {
  group('ilk adım duruma göre', () {
    testWidgets('tek kişilikte sayılar ve lot sayfası uyarısı ayrı', (
      tester,
    ) async {
      await _open(tester, seed: _seedRecords);

      expect(find.byType(AccountDeletionScreen), findsOneWidget);
      expect(find.text('Adım 1/4'), findsOneWidget);
      expect(find.text('Hesabın ve işletmen silinecek'), findsOneWidget);
      expect(
        find.textContaining('Yılmaz Arıcılık işletmesinde tek kişi sensin'),
        findsOneWidget,
      );
      // Uyarı kartı ayrı ve sayılardan önce.
      expect(
        find.descendant(
          of: find.byType(CriticalLockCard),
          matching: find.textContaining(
            '1 herkese açık lot sayfası silinecek, kavanozlardaki QR kodları '
            'çalışmayacak.',
            findRichText: true,
          ),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.qr_code_2_rounded), findsOneWidget);

      for (final (label, count) in [
        ('Kovan', '4'),
        ('Arılık', '2'),
        ('Muayene', '4'),
        ('Hasat', '0'),
        ('Belge', '0'),
        ('Fotoğraf', '0'),
      ]) {
        final row = find.widgetWithText(ListRow, label, skipOffstage: false);
        await tester.scrollUntilVisible(
          row,
          200,
          scrollable: find.byType(Scrollable).first,
        );
        expect(
          find.descendant(of: row, matching: find.text(count)),
          findsOneWidget,
          reason: label,
        );
      }
      expect(_bigButton(tester, 'Devam').onPressed, isNotNull);
    });

    testWidgets('lot yayımda değilse QR uyarısı yok', (tester) async {
      await _open(tester, seed: seedCountedRecords);
      expect(find.byType(CriticalLockCard), findsNothing);
    });

    testWidgets('ekipli sahip iki seçenekten birini seçer; devir ortağa', (
      tester,
    ) async {
      final app = await _open(
        tester,
        seed: _seedRecords,
        team: {
          'partner-1': ('Ayşe Kaya', MembershipRole.partner),
          'worker-1': ('Mustafa Demir', MembershipRole.worker),
        },
      );

      expect(
        find.text('Ekibin var: işletme için bir seçim yap'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Yılmaz Arıcılık işletmesinin sahibisin; ekipte 2 kişi daha '
          'var.',
        ),
        findsOneWidget,
      );
      expect(find.text('Sahipliği devret ve ayrıl'), findsOneWidget);
      expect(find.text('İşletmeyi ve tüm kayıtları sil'), findsOneWidget);
      // Seçim yapılmadan devam edilmez.
      expect(_bigButton(tester, 'Devam').onPressed, isNull);

      await _tap(tester, find.text('Sahipliği devret ve ayrıl'));
      // Yalnız ortak listelenir; işçi yeni sahip olamaz.
      expect(find.text('Ayşe Kaya'), findsOneWidget);
      expect(find.text('Mustafa Demir'), findsNothing);
      expect(_bigButton(tester, 'Devam').onPressed, isNull);
      await _tap(tester, find.text('Ayşe Kaya'));
      expect(_bigButton(tester, 'Devam').onPressed, isNotNull);

      await _tap(tester, find.text('İşletmeyi ve tüm kayıtları sil'));
      expect(
        find.text('Ekipteki 2 kişi de işletmeye erişemez.'),
        findsOneWidget,
      );
      expect(find.byType(CriticalLockCard), findsOneWidget);

      // Devirle sona kadar: talep ortağın kimliğiyle gider.
      await _tap(tester, find.text('Sahipliği devret ve ayrıl'));
      await _toVerify(tester);
      await _enterCode(tester, '482913');
      expect(find.text('Son onay'), findsOneWidget);
      expect(
        find.text('Ayşe Kaya, Yılmaz Arıcılık işletmesinin yeni sahibi olur.'),
        findsOneWidget,
      );
      expect(find.text('Onaylamak için SİL yaz'), findsOneWidget);
      await tester.enterText(_confirmField, 'sil');
      await _settle(tester);
      await _tap(tester, _button(_deleteAccount));

      expect(app.deletion.requests.single, (
        orgId: testOrganization.id,
        deleteOrganization: false,
        transferTo: 'partner-1',
      ));
    });

    testWidgets('ortak yoksa devir seçeneği nedenini söyler', (tester) async {
      await _open(
        tester,
        team: {'worker-1': ('Mustafa Demir', MembershipRole.worker)},
      );
      await _tap(tester, find.text('Sahipliği devret ve ayrıl'));
      expect(
        find.textContaining('Devretmek için ekipte bir ortak olmalı'),
        findsOneWidget,
      );
      expect(_bigButton(tester, 'Devam').onPressed, isNull);
    });

    testWidgets('üyede işletmenin silinmediği söylenir', (tester) async {
      await _open(
        tester,
        role: MembershipRole.worker,
        team: {'owner-1': ('Ahmet Yılmaz', MembershipRole.owner)},
        seed: _seedRecords,
      );

      expect(find.text('Yalnız hesabın silinecek'), findsOneWidget);
      expect(
        find.textContaining('Yılmaz Arıcılık işletmesi ve kayıtları silinmez'),
        findsOneWidget,
      );
      expect(find.text('Silinecek kayıtlar'), findsNothing);
      expect(find.byType(CriticalLockCard), findsNothing);
      expect(find.text('Sahipliği devret ve ayrıl'), findsNothing);
      expect(_bigButton(tester, 'Devam').onPressed, isNotNull);
    });
  });

  group('kimlik doğrulama', () {
    testWidgets('kod adımı açılınca hesabın e-postasına kod gider', (
      tester,
    ) async {
      final app = await _open(tester);
      await _toVerify(tester);

      // Silme kodu: giriş kodu (OTP) gönderilmez, yeni oturum açılmaz.
      expect(app.deletion.sentCodes, 1);
      expect(app.auth.sentCodes, isEmpty);
      expect(find.text('Adım 3/4'), findsOneWidget);
      expect(find.textContaining(testUser.email!), findsOneWidget);
      expect(_button('Kodu doğrula'), findsOneWidget);
      // Yeniden gönderme sayacı bitsin.
      await tester.pump(resendCooldown);
    });

    testWidgets('kod doğrulanmadan son onaya geçilmez', (tester) async {
      final app = await _open(tester);
      await _toVerify(tester);

      await _enterCode(tester, '111111');

      expect(app.deletion.verifiedCodes, ['111111']);
      expect(find.text('Son onay'), findsNothing);
      expect(find.text('Kimliğini doğrula'), findsOneWidget);
      expect(
        find.text(
          'Kod yanlış ya da süresi dolmuş. Yeniden dene ya da yeni kod iste.',
        ),
        findsOneWidget,
      );
      expect(find.byType(LabeledField), findsNothing);
      expect(app.deletion.requests, isEmpty);

      await _enterCode(tester, '482913');
      expect(find.text('Son onay'), findsOneWidget);
      expect(app.auth.verifiedCodes, isEmpty);
    });

    testWidgets('sunucu doğrulamanın süresi doldu derse koda dönülür', (
      tester,
    ) async {
      final app = await _open(tester);
      await _toVerify(tester);
      await _enterCode(tester, '482913');
      // 15 dakika geçti: sunucu kodu artık kabul etmiyor.
      app.deletion.codeVerified = false;
      await tester.enterText(_confirmField, 'Yılmaz Arıcılık');
      await _settle(tester);

      await _tap(tester, _button(_deleteWithOrganization));

      expect(find.text('Kimliğini doğrula'), findsOneWidget);
      expect(find.byType(AccountDeletedScreen), findsNothing);
      expect(app.auth.signOutCount, 0);
      await tester.pump(resendCooldown);
    });

    testWidgets('geri tuşu önceki adıma döner, doğrulama kalır', (
      tester,
    ) async {
      final app = await _open(tester);
      await _toVerify(tester);
      await _enterCode(tester, '482913');
      expect(find.text('Son onay'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await _settle(tester);
      expect(find.text('Kimliğini doğrula'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await _settle(tester);
      expect(find.text('Önce verini al'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await _settle(tester);
      expect(find.text('Adım 1/4'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await _settle(tester);
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(app.deletion.requests, isEmpty);
    });
  });

  group('son onay', () {
    testWidgets('yanlış yazılan işletme adında düğme kapalı kalır', (
      tester,
    ) async {
      final app = await _open(tester, seed: _seedRecords);
      await _toVerify(tester);
      await _enterCode(tester, '482913');

      expect(
        find.text('Onaylamak için işletmenin adını yaz: Yılmaz Arıcılık'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Yılmaz Arıcılık işletmesi ve tüm kayıtları da '
          'silinir.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('1 lot sayfası kapanır; QR kodları çalışmaz.'),
        findsOneWidget,
      );
      // Kırmızı düğme ikon ve kelime taşır.
      expect(
        find.descendant(
          of: _button(_deleteWithOrganization),
          matching: find.byIcon(Icons.delete_forever_rounded),
        ),
        findsOneWidget,
      );
      expect(
        _bigButton(tester, _deleteWithOrganization).variant,
        BigButtonVariant.danger,
      );
      expect(_bigButton(tester, _deleteWithOrganization).onPressed, isNull);

      for (final wrong in ['Yılmaz', 'Yilmaz Aricilik', 'SİL', 'Yılmaz Arı']) {
        await tester.enterText(_confirmField, wrong);
        await _settle(tester);
        expect(
          _bigButton(tester, _deleteWithOrganization).onPressed,
          isNull,
          reason: wrong,
        );
      }
      await tester.tap(_button(_deleteWithOrganization));
      await _settle(tester);
      expect(app.deletion.requests, isEmpty);

      await tester.enterText(_confirmField, ' yılmaz arıcılık ');
      await _settle(tester);
      expect(_bigButton(tester, _deleteWithOrganization).onPressed, isNotNull);
    });

    testWidgets('üye SİL yazar; yanlışta düğme kapalı', (tester) async {
      await _open(
        tester,
        role: MembershipRole.partner,
        team: {'owner-1': ('Ahmet Yılmaz', MembershipRole.owner)},
      );
      await _toVerify(tester);
      await _enterCode(tester, '482913');

      expect(find.text('Onaylamak için SİL yaz'), findsOneWidget);
      expect(find.text('İşletmenin kayıtları silinmez.'), findsOneWidget);
      for (final wrong in ['SIL', 'si', 'DELETE']) {
        await tester.enterText(_confirmField, wrong);
        await _settle(tester);
        expect(_bigButton(tester, _deleteAccount).onPressed, isNull);
      }
      await tester.enterText(_confirmField, 'SİL');
      await _settle(tester);
      expect(_bigButton(tester, _deleteAccount).onPressed, isNotNull);
    });

    testWidgets('sunucu reddederse neden yazılır, akışta kalınır', (
      tester,
    ) async {
      final app = await _open(tester);
      app.deletion.requestFailure = AccountDeletionFailure.rateLimited;
      await _toVerify(tester);
      await _enterCode(tester, '482913');
      await tester.enterText(_confirmField, 'Yılmaz Arıcılık');
      await _settle(tester);

      await _tap(tester, _button(_deleteWithOrganization));

      expect(
        find.text('Kısa sürede çok fazla deneme oldu. Yarın yeniden dene.'),
        findsOneWidget,
      );
      expect(find.byType(AccountDeletedScreen), findsNothing);
      expect(app.auth.signOutCount, 0);
    });
  });

  testWidgets('bitişte tarih yazılır, oturum kapanır, cihaz temizlenir', (
    tester,
  ) async {
    final app = await _open(tester, seed: _seedRecords);
    await tester.runAsync(() => app.media.store.write('foto.jpg', tinyImage));
    expect(app.media.fileNames, ['foto.jpg']);
    final before = await tester.runAsync(
      () => app.db.select(app.db.outbox).get(),
    );
    expect(before, isNotEmpty);

    await _toVerify(tester);
    await _enterCode(tester, '482913');
    await tester.enterText(_confirmField, 'Yılmaz Arıcılık');
    await _settle(tester);
    await _tap(tester, _button(_deleteWithOrganization));

    expect(app.deletion.requests.single.deleteOrganization, isFalse);
    expect(find.byType(AccountDeletedScreen), findsOneWidget);
    expect(find.text('Silme talebin alındı'), findsOneWidget);
    expect(
      find.text('Hesabın 12 Kas 2026 tarihinde kalıcı olarak silinecek.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Fikrini değiştirirsen bu tarihe kadar giriş yap; silme iptal olur.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Oturumun kapatıldı ve bu telefondaki verilerin silindi.'),
      findsOneWidget,
    );
    expect(app.auth.signOutCount, 1);
    expect(
      app.container.read(routerProvider).state.uri.path,
      AppRoutes.accountDeleted,
    );

    // Cihazda kalıntı yok: kayıtlar, outbox, imleçler, dosyalar, anahtarlar.
    final leftovers = await tester.runAsync(() async {
      final rows = <String, int>{};
      for (final table in app.db.allTables) {
        final count =
            (await app.db
                    .customSelect('SELECT * FROM ${table.actualTableName}')
                    .get())
                .length;
        if (count > 0) rows[table.actualTableName] = count;
      }
      return rows;
    });
    expect(leftovers, isEmpty);
    expect(app.media.fileNames, isEmpty);
    expect(app.secure.calls, 1);

    await _tap(tester, _button('Tamam'));
    expect(find.byType(SignInEmailScreen), findsOneWidget);
  });

  group('bekleme süresinde giriş', () {
    final pending = (
      scheduledFor: DateTime.utc(2026, 11, 12, 9, 30),
      kind: DeletionKind.account,
    );

    testWidgets('önce silinmek üzere ekranı; devam edilirse iptal olur', (
      tester,
    ) async {
      final app = await _open(tester, pending: pending);

      expect(find.byType(DeletionPendingScreen), findsOneWidget);
      expect(find.text('Hesabın silinmek üzere'), findsOneWidget);
      expect(
        find.text(
          'Hesabın 12 Kas 2026 tarihinde silinecek. Devam edersen silme '
          'iptal olur.',
        ),
        findsOneWidget,
      );
      expect(find.byType(TodayScreen), findsNothing);
      // Başka konuma gidilemez.
      app.container.read(routerProvider).go(AppRoutes.settings);
      await _settle(tester);
      expect(find.byType(DeletionPendingScreen), findsOneWidget);
      expect(app.deletion.cancelCalls, 0);

      await _tap(tester, _button('Devam et, hesabımı koru'));

      expect(app.deletion.cancelCalls, 1);
      expect(find.byType(TodayScreen), findsOneWidget);
      expect(
        find.text('Silme iptal edildi. Tekrar hoş geldin!'),
        findsOneWidget,
      );
      expect(app.auth.signOutCount, 0);
    });

    testWidgets('çıkış seçilirse talep sürer, telefon temizlenir', (
      tester,
    ) async {
      final app = await _open(tester, pending: pending, seed: _seedRecords);

      await _tap(tester, _button('Çıkış yap, silme sürsün'));

      expect(app.deletion.cancelCalls, 0);
      expect(app.auth.signOutCount, 1);
      expect(find.byType(SignInEmailScreen), findsOneWidget);
      final apiaries = await tester.runAsync(
        () => app.db.select(app.db.apiaries).get(),
      );
      expect(apiaries, isEmpty);
      expect(app.secure.calls, 1);
    });

    testWidgets('iptal edilemezse ekranda kalınır', (tester) async {
      final app = await _open(tester, pending: pending);
      app.deletion.cancelFailure = AccountDeletionFailure.network;

      await _tap(tester, _button('Devam et, hesabımı koru'));

      expect(find.byType(DeletionPendingScreen), findsOneWidget);
      expect(
        find.text(
          'Silme iptal edilemedi. Bağlantını kontrol edip yeniden dene.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('bekleyen talep yoksa uygulama doğrudan açılır', (
      tester,
    ) async {
      final app = await _open(tester, location: AppRoutes.today);
      expect(find.byType(TodayScreen), findsOneWidget);
      expect(app.deletion.pendingCalls, 1);
    });
  });

  group('internet', () {
    testWidgets('çevrimdışıyken Ayarlar akışı başlatmaz, nedenini söyler', (
      tester,
    ) async {
      await _open(tester, location: AppRoutes.settings, online: false);

      await _tap(tester, _button(_deleteAccount));

      expect(find.byType(AccountDeletionScreen), findsNothing);
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(
        find.text(
          'Hesabı silmek için internet gerekiyor; bağlanınca yeniden dene.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('çevrimdışı açılan silme ekranında adım yok', (tester) async {
      await _open(tester, online: false);

      expect(find.byType(AccountDeletionScreen), findsOneWidget);
      expect(
        find.text(
          'Hesabı silmek için internet gerekiyor; bağlanınca yeniden dene.',
        ),
        findsOneWidget,
      );
      expect(find.text('Adım 1/4'), findsNothing);
      expect(_button('Devam'), findsNothing);
    });
  });

  testWidgets("silme yoluna Bugün'den üç dokunuşla ulaşılır", (tester) async {
    await _open(tester, location: AppRoutes.today);

    await tester.tap(find.text('Daha fazla').last);
    await _settle(tester);
    await _tap(tester, find.text('Ayarlar'));
    expect(find.byType(SettingsScreen), findsOneWidget);
    await _tap(tester, _button(_deleteAccount));

    expect(find.byType(AccountDeletionScreen), findsOneWidget);
    expect(find.text('Adım 1/4'), findsOneWidget);
    // Ayarlar'daki giriş de kırmızı, ikon ve kelimeyle.
  });

  testWidgets("Ayarlar'daki Hesabımı sil düğmesi kritik, ikonlu, 56dp+", (
    tester,
  ) async {
    await _open(tester, location: AppRoutes.settings);
    final button = _button(_deleteAccount);
    await tester.scrollUntilVisible(
      button,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester.widget<BigButton>(button).variant,
      BigButtonVariant.dangerOutlined,
    );
    expect(
      find.descendant(
        of: button,
        matching: find.byIcon(Icons.delete_outline_rounded),
      ),
      findsOneWidget,
    );
    expect(tester.getSize(button).height, greaterThanOrEqualTo(56));
  });

  group('görünüm', () {
    for (final mode in [
      AppColorMode.light,
      AppColorMode.dark,
      AppColorMode.sun,
    ]) {
      for (final glove in [false, true]) {
        testWidgets(
          '${mode.name}${glove ? ' + eldiven' : ''}: 360dp 1.5x yazıda her '
          'adım taşmaz, düğmeler en az 56dp',
          (tester) async {
            tester.view
              ..physicalSize = const Size(360, 640)
              ..devicePixelRatio = 1;
            tester.platformDispatcher.textScaleFactorTestValue = 1.5;
            addTearDown(tester.view.reset);
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );

            final app = await _open(
              tester,
              seed: _seedRecords,
              team: {'partner-1': ('Ayşe Kaya', MembershipRole.partner)},
            );
            app.container.read(appearanceProvider.notifier)
              ..setColorMode(mode)
              ..setGloveMode(enabled: glove);
            await _settle(tester);

            void checkButton(String label) {
              expect(tester.takeException(), isNull, reason: label);
              expect(
                tester.getSize(_button(label)).height,
                greaterThanOrEqualTo(56),
                reason: label,
              );
            }

            await _tap(tester, find.text('İşletmeyi ve tüm kayıtları sil'));
            await tester.scrollUntilVisible(
              find.text('Fotoğraf'),
              200,
              scrollable: find.byType(Scrollable).first,
            );
            checkButton('Devam');
            await _tap(tester, _button('Devam'));
            checkButton('Kayıtlarımı indir');
            checkButton('Atla');
            await _tap(tester, _button('Atla'));
            checkButton('Kodu doğrula');
            await _enterCode(tester, '482913');
            checkButton(_deleteWithOrganization);
            await tester.scrollUntilVisible(
              _confirmField,
              200,
              scrollable: find.byType(Scrollable).first,
            );
            expect(tester.takeException(), isNull);
            await tester.enterText(_confirmField, 'Yılmaz Arıcılık');
            await _settle(tester);
            checkButton(_deleteWithOrganization);
            await _tap(tester, _button(_deleteWithOrganization));
            expect(tester.takeException(), isNull);
            checkButton('Tamam');
          },
        );
      }
    }

    testWidgets('bekleme ekranı 360dp 1.5x eldivende taşmaz', (tester) async {
      tester.view
        ..physicalSize = const Size(360, 640)
        ..devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      final app = await _open(
        tester,
        pending: (
          scheduledFor: DateTime.utc(2026, 11, 12),
          kind: DeletionKind.account,
        ),
      );
      app.container.read(appearanceProvider.notifier)
        ..setColorMode(AppColorMode.sun)
        ..setGloveMode(enabled: true);
      await _settle(tester);

      expect(tester.takeException(), isNull);
      for (final label in [
        'Devam et, hesabımı koru',
        'Çıkış yap, silme sürsün',
      ]) {
        expect(tester.getSize(_button(label)).height, greaterThanOrEqualTo(56));
      }
    });
  });
}
