import 'package:mobil_arici/features/account_deletion/data/account_deletion_service.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';

/// Ağsız `account-delete`: talepleri kaydeder, istenen hatayı atar.
class FakeAccountDeletionService implements AccountDeletionService {
  /// Sunucudaki bekleyen talep; [pending] bunu döner, [cancel] siler.
  DeletionRequestInfo? pendingRequest;

  /// Sonraki talebin ya da iptalin hatası; null ise başarılı.
  AccountDeletionFailure? requestFailure;
  AccountDeletionFailure? pendingFailure;
  AccountDeletionFailure? cancelFailure;

  /// Talebin kalıcı silme zamanı.
  DateTime scheduledFor = DateTime.utc(2026, 11, 12, 9, 30);

  /// Gönderilen silme kodu; [verifyCode] yalnız bunu kabul eder.
  String code = '482913';
  AccountDeletionFailure? sendFailure;
  int sentCodes = 0;
  final verifiedCodes = <String>[];

  /// Sunucuda doğrulanmış kod var mı; yoksa [request] codeRequired atar.
  bool codeVerified = false;

  final requests =
      <({String orgId, bool deleteOrganization, String? transferTo})>[];
  int pendingCalls = 0;
  int cancelCalls = 0;

  @override
  Future<void> sendCode() async {
    sentCodes++;
    if (sendFailure case final failure?) {
      throw AccountDeletionException(failure);
    }
  }

  @override
  Future<void> verifyCode(String code) async {
    verifiedCodes.add(code);
    if (code != this.code) {
      throw const AccountDeletionException(AccountDeletionFailure.invalidCode);
    }
    codeVerified = true;
  }

  @override
  Future<DeletionRequestInfo> request({
    required String orgId,
    bool deleteOrganization = false,
    String? transferTo,
  }) async {
    requests.add((
      orgId: orgId,
      deleteOrganization: deleteOrganization,
      transferTo: transferTo,
    ));
    if (requestFailure case final failure?) {
      throw AccountDeletionException(failure);
    }
    if (!codeVerified) {
      throw const AccountDeletionException(AccountDeletionFailure.codeRequired);
    }
    codeVerified = false;
    final request = (
      scheduledFor: scheduledFor,
      kind: deleteOrganization
          ? DeletionKind.accountAndOrganization
          : DeletionKind.account,
    );
    pendingRequest = request;
    return request;
  }

  @override
  Future<DeletionRequestInfo?> pending() async {
    pendingCalls++;
    if (pendingFailure case final failure?) {
      throw AccountDeletionException(failure);
    }
    return pendingRequest;
  }

  @override
  Future<bool> cancel() async {
    cancelCalls++;
    if (cancelFailure case final failure?) {
      throw AccountDeletionException(failure);
    }
    final cancelled = pendingRequest != null;
    pendingRequest = null;
    return cancelled;
  }
}

/// Güvenli depoyu silme çağrılarını sayar.
class FakeSecureStorageWipe {
  int calls = 0;

  Future<void> call() async => calls++;
}
