import 'dart:async';

import 'package:flutter_riverpod/misc.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/code_scanner_provider.dart';
import 'package:mobil_arici/core/services/print_service_provider.dart';
import 'package:mobil_arici/features/auth/data/auth_service.dart';
import 'package:mobil_arici/features/auth/domain/app_user.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';

import 'fake_code_scanner.dart';
import 'fake_organization_service.dart';
import 'fake_print_service.dart';
import 'fake_sync_service.dart';
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
/// DB bellek içi; verilmezse boş açılır. Kamera, yazıcı ve senkron sahte;
/// ilk tam çekme bitmiş sayılır ([fullPullDone] yanlışsa DB'den okunur).
List<Override> signedIn({
  FakeAuthService? auth,
  AppDatabase? db,
  FakeCodeScanner? scanner,
  FakePrintService? printer,
  FakeSyncService? sync,
  bool fullPullDone = true,
}) => [
  authServiceProvider.overrideWithValue(
    auth ?? FakeAuthService(user: testUser),
  ),
  ...organizationOverrides(),
  appDatabaseProvider.overrideWithValue(db ?? openTestDatabase()),
  codeScannerProvider.overrideWithValue((scanner ?? FakeCodeScanner()).builder),
  printServiceProvider.overrideWithValue(printer ?? FakePrintService()),
  ...syncOverrides(service: sync, fullPullDone: fullPullDone),
];
