import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/utils/xlsx.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_email_screen.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/fake_share_service.dart';
import '../../helpers/fake_team_service.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeShareService share;
  late FakeAuthService auth;

  setUp(() {
    db = openTestDatabase();
    share = FakeShareService();
    auth = FakeAuthService(user: testUser);
  });

  Future<ProviderContainer> open(WidgetTester tester) async {
    final container = ProviderContainer.test(
      overrides: signedIn(db: db, share: share, auth: auth),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    container.read(routerProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();
    return container;
  }

  Finder inSettings(Finder finder) =>
      find.descendant(of: find.byType(SettingsScreen), matching: finder);

  Future<void> tapInSettings(WidgetTester tester, String text) async {
    final target = inSettings(find.text(text));
    await tester.scrollUntilVisible(
      target,
      200,
      scrollable: inSettings(find.byType(Scrollable)).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  /// Paylaşılan dosyadaki çalışma kitabının sayfa adları.
  String workbookXml(Uint8List bytes) => utf8.decode(
    ZipDecoder().decodeBytes(bytes).findFile('xl/workbook.xml')!.content,
  );

  Future<void> addApiary(String name, {DateTime? at}) => ApiaryRepository(
    db,
    clock: () => at ?? DateTime.now(),
  ).create(orgId: testOrganization.id, name: name);

  group('Verileri dışa aktar', () {
    testWidgets('dokununca tüm kayıtlar tek Excel dosyası olarak paylaşılır; '
        'sahip gelir/gideri de görür', (tester) async {
      await addMember(db, userId: testUser.id, role: MembershipRole.owner);
      await addApiary('Yayla');
      await open(tester);

      expect(inSettings(find.text('Excel')), findsOneWidget);
      await tapInSettings(tester, 'Export data');

      final file = share.files.single;
      expect(file.mimeType, xlsxMimeType);
      expect(
        file.filename,
        matches(RegExp(r'^Mobil Arıcı \d{4}-\d{2}-\d{2}\.xlsx$')),
      );
      final workbook = workbookXml(file.bytes);
      expect(workbook, contains('name="Apiaries"'));
      expect(workbook, contains('name="Income and expenses"'));
      final apiaries = utf8.decode(
        ZipDecoder()
            .decodeBytes(file.bytes)
            .findFile('xl/worksheets/sheet1.xml')!
            .content,
      );
      expect(apiaries, contains('>Yayla</t>'));
    });

    testWidgets('çalışan gelir/gideri dosyada görmez', (tester) async {
      await addMember(db, userId: testUser.id, role: MembershipRole.worker);
      await open(tester);

      await tapInSettings(tester, 'Export data');

      expect(
        workbookXml(share.files.single.bytes),
        isNot(contains('Income and expenses')),
      );
    });

    testWidgets('Türkçe metinler ve sayfa adları', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('tr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      await open(tester);

      expect(
        inSettings(
          find.text(
            'Tüm kayıtların tek Excel dosyasında; istediğin yere gönder ya '
            'da kaydet.',
          ),
        ),
        findsOneWidget,
      );
      await tapInSettings(tester, 'Verileri dışa aktar');

      expect(share.files.single.filename, startsWith('Mobil Arıcı '));
      expect(workbookXml(share.files.single.bytes), contains('Arılıklar'));
    });

    testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
      tester.view
        ..physicalSize = const Size(360, 640)
        ..devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final container = await open(tester);

      for (final glove in [false, true]) {
        container
            .read(appearanceProvider.notifier)
            .setGloveMode(enabled: glove);
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          inSettings(find.text('Export data')),
          200,
          scrollable: inSettings(find.byType(Scrollable)).first,
        );
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Bekleyen kayıtla çıkış', () {
    Future<void> tapSignOut(WidgetTester tester) async {
      await tapInSettings(tester, 'Sign out');
    }

    testWidgets('gönderilmemiş kayıt varsa onay penceresi sayısıyla uyarır; '
        'yine de çıkılabilir', (tester) async {
      await addApiary('Yayla');
      await addApiary('Ova');
      await open(tester);

      await tapSignOut(tester);

      expect(
        find.text(
          "2 records haven't been sent to the server yet and are only on "
          "this phone. If you sign out, they won't be sent. Connect to the "
          'internet and sync first.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Sign out anyway'));
      await tester.pumpAndSettle();

      expect(auth.signOutCount, 1);
      expect(find.byType(SignInEmailScreen), findsOneWidget);
    });

    testWidgets('bekleyen yoksa eski metin', (tester) async {
      await open(tester);

      await tapSignOut(tester);

      expect(find.text('Sign out anyway'), findsNothing);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Sign out'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Türkçe uyarı', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('tr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      await addApiary('Yayla');
      await open(tester);

      await tapInSettings(tester, 'Çıkış yap');

      expect(
        find.text(
          '1 kayıt henüz sunucuya gönderilmedi ve yalnız bu telefonda. Çıkış '
          'yaparsan gönderilmezler. Önce internete bağlanıp eşitle.',
        ),
        findsOneWidget,
      );
      expect(find.text('Yine de çıkış yap'), findsOneWidget);
    });
  });
}
