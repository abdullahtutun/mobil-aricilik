import 'dart:async';

import 'package:flutter_riverpod/misc.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/app_info_service_provider.dart';
import 'package:mobil_arici/core/services/basemap_service_provider.dart';
import 'package:mobil_arici/core/services/code_scanner_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/services/place_search_service_provider.dart';
import 'package:mobil_arici/core/services/print_service_provider.dart';
import 'package:mobil_arici/core/services/push_service_provider.dart';
import 'package:mobil_arici/core/services/screen_awake.dart';
import 'package:mobil_arici/core/services/share_service_provider.dart';
import 'package:mobil_arici/core/services/url_launcher_service_provider.dart';
import 'package:mobil_arici/features/auth/data/auth_service.dart';
import 'package:mobil_arici/features/auth/domain/app_user.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/task_push.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';

import 'fake_app_info_service.dart';
import 'fake_basemap_service.dart';
import 'fake_code_scanner.dart';
import 'fake_documents.dart';
import 'fake_knowledge.dart';
import 'fake_media.dart';
import 'fake_offline_maps.dart';
import 'fake_organization_service.dart';
import 'fake_place_search_service.dart';
import 'fake_print_service.dart';
import 'fake_push_service.dart';
import 'fake_receipts.dart';
import 'fake_reminder_notifications.dart';
import 'fake_screen_awake.dart';
import 'fake_share_service.dart';
import 'fake_sync_service.dart';
import 'fake_url_launcher.dart';
import 'fake_weather_service.dart';
import 'test_database.dart';

const testUser = AppUser(id: 'test-user', email: 'ari@example.com');

/// Ağsız auth servisi: çağrıları kaydeder, istenen hatayı atar.
class FakeAuthService implements AuthService {
  new({this._user});

  AppUser? _user;
  final _changes = StreamController<AppUser?>.broadcast();

  /// Sonraki çağrıların atacağı hata; null ise çağrı başarılı.
  AuthFailure? sendFailure;
  AuthFailure? verifyFailure;

  final sentCodes = <({String email, String locale})>[];
  final verifiedCodes = <({String email, String code, String locale})>[];
  int signOutCount = 0;

  /// Sunucudan gelen oturum değişikliğini taklit eder.
  void emit(AppUser? user) {
    _user = user;
    _changes.add(user);
  }

  @override
  AppUser? get currentUser => _user;

  @override
  Stream<AppUser?> get userChanges => _changes.stream;

  @override
  Future<void> sendCode({required String email, required String locale}) async {
    sentCodes.add((email: email, locale: locale));
    if (sendFailure case final failure?) throw AuthServiceException(failure);
  }

  @override
  Future<void> verifyCode({
    required String email,
    required String code,
    required String locale,
  }) async {
    verifiedCodes.add((email: email, code: code, locale: locale));
    if (verifyFailure case final failure?) throw AuthServiceException(failure);
    emit(AppUser(id: testUser.id, email: email));
  }

  @override
  Future<void> signOut() async {
    signOutCount++;
    emit(null);
  }
}

/// `App`'i giriş yapılmış ve işletmesi olan bir kullanıcıyla açar. Yerel
/// DB bellek içi; verilmezse boş açılır. Kamera, yazıcı, paylaşma, adres
/// açıcı, senkron, medya (foto, ses, Storage), belge dosyaları (PDF seçici,
/// çizici, Storage), fiş klasörü, hava servisi ve ekranı açık tutma sahte;
/// hava servisi verilmezse çevrimdışı gibi hata atar. İlk tam çekme bitmiş
/// sayılır ([fullPullDone] yanlışsa DB'den okunur).
List<Override> signedIn({
  FakeAuthService? auth,
  AppDatabase? db,
  FakeCodeScanner? scanner,
  FakePrintService? printer,
  FakeShareService? share,
  FakeUrlLauncher? urlLauncher,
  FakeSyncService? sync,
  FakeMedia? media,
  FakeDocuments? documents,
  FakeReceipts? receipts,
  FakeReminderNotifications? reminders,
  FakeWeatherService? weather,
  FakeScreenAwake? screenAwake,
  FakeBasemapService? basemap,
  FakePlaceSearchService? placeSearch,
  FakeAppInfoService? appInfo,
  FakePushService? push,
  FakeDeviceTokenService? deviceTokens,
  FakeKnowledge? knowledge,
  FakeOfflineMaps? offlineMaps,
  bool fullPullDone = true,
}) => [
  authServiceProvider.overrideWithValue(
    auth ?? FakeAuthService(user: testUser),
  ),
  ...organizationOverrides(),
  appDatabaseProvider.overrideWithValue(db ?? openTestDatabase()),
  codeScannerProvider.overrideWithValue((scanner ?? FakeCodeScanner()).builder),
  printServiceProvider.overrideWithValue(printer ?? FakePrintService()),
  shareServiceProvider.overrideWithValue(share ?? FakeShareService()),
  urlLauncherServiceProvider.overrideWithValue(
    urlLauncher ?? FakeUrlLauncher(),
  ),
  ...syncOverrides(service: sync, fullPullDone: fullPullDone),
  ...(media ?? FakeMedia()).overrides,
  ...(documents ?? FakeDocuments()).overrides,
  ...(receipts ?? FakeReceipts()).overrides,
  reminderNotificationsProvider.overrideWithValue(
    reminders ?? FakeReminderNotifications(),
  ),
  weatherServiceProvider.overrideWithValue(weather ?? FakeWeatherService()),
  screenAwakeProvider.overrideWithValue(screenAwake ?? FakeScreenAwake()),
  basemapServiceProvider.overrideWithValue(basemap ?? FakeBasemapService()),
  placeSearchServiceProvider.overrideWithValue(
    placeSearch ?? FakePlaceSearchService(),
  ),
  appInfoServiceProvider.overrideWithValue(appInfo ?? FakeAppInfoService()),
  pushServiceProvider.overrideWithValue(push ?? FakePushService()),
  deviceTokenServiceProvider.overrideWithValue(
    deviceTokens ?? FakeDeviceTokenService(),
  ),
  ...(knowledge ?? FakeKnowledge()).overrides,
  ...(offlineMaps ?? FakeOfflineMaps()).overrides,
];
