import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/sync/sync_indicator.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';

void main() {
  group('syncIndicatorOf', () {
    test('bekleyen kayıt yoksa eşitlendi', () {
      expect(syncIndicatorOf(pending: 0, rejected: 0), SyncIndicator.synced);
      expect(
        syncIndicatorOf(pending: 0, rejected: 0, lastStatus: SyncStatus.done),
        SyncIndicator.synced,
      );
    });

    test('bekleyen kayıt varsa bekliyor; ağ olmaması hata değil', () {
      expect(syncIndicatorOf(pending: 3, rejected: 0), SyncIndicator.pending);
      expect(
        syncIndicatorOf(
          pending: 3,
          rejected: 0,
          lastStatus: SyncStatus.retryLater,
        ),
        SyncIndicator.pending,
      );
      expect(
        syncIndicatorOf(
          pending: 0,
          rejected: 0,
          lastStatus: SyncStatus.retryLater,
        ),
        SyncIndicator.synced,
      );
    });

    test('reddedilen kayıt ya da yeniden denenmeyen hata, bekleyenin '
        'önüne geçer', () {
      expect(syncIndicatorOf(pending: 3, rejected: 1), SyncIndicator.error);
      for (final status in [SyncStatus.failed, SyncStatus.upgradeRequired]) {
        expect(
          syncIndicatorOf(pending: 3, rejected: 0, lastStatus: status),
          SyncIndicator.error,
          reason: status.name,
        );
      }
    });
  });

  group('syncRejectionOf', () {
    test('sync_push nedenlerini tanır', () {
      expect(syncRejectionOf('forbidden: RLS'), SyncRejection.forbidden);
      expect(
        syncRejectionOf('conflict: duplicate key: tag_code'),
        SyncRejection.conflict,
      );
      expect(
        syncRejectionOf('missing_reference: apiary'),
        SyncRejection.missingReference,
      );
      expect(syncRejectionOf('unsupported: x'), SyncRejection.unsupported);
      expect(syncRejectionOf('invalid: bad'), SyncRejection.invalid);
      // Mesajsız neden.
      expect(syncRejectionOf('forbidden'), SyncRejection.forbidden);
    });

    test('tanınmayan ya da biçimsiz neden bilinmeyen sayılır', () {
      expect(syncRejectionOf('timeout: x'), SyncRejection.unknown);
      expect(syncRejectionOf(''), SyncRejection.unknown);
      expect(syncRejectionOf('forbiddenx: y'), SyncRejection.unknown);
    });
  });
}
