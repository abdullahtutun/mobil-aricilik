import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/role_permissions.dart';
import 'package:mobil_arici/features/team/domain/invite.dart';

void main() {
  group('davet kodu', () {
    test('yazılan kod düzenlenir: boşluk ve tire atılır, harf büyür', () {
      expect(normalizeInviteCode(' ar7-k2q '), 'AR7K2Q');
      expect(normalizeInviteCode('ar7 k2q'), 'AR7K2Q');
    });

    test('geçerli kod altı karakter ve alfabeden', () {
      expect(isInviteCode('AR7K2Q'), isTrue);
      expect(isInviteCode('AR7K2'), isFalse);
      expect(isInviteCode('AR7K2QQ'), isFalse);
      // 0/O ve 1/I/L alfabede yok.
      expect(isInviteCode('AR0K2Q'), isFalse);
      expect(isInviteCode('AR1K2Q'), isFalse);
      expect(isInviteCode('ARIK2Q'), isFalse);
      expect(isInviteCode('arlk2q'), isFalse);
    });

    test('alfabede 31 karışmayan karakter var', () {
      expect(inviteCodeAlphabet.length, 31);
      expect(inviteCodeAlphabet, isNot(contains('O')));
      expect(inviteCodeAlphabet, isNot(contains('0')));
    });
  });

  group('rol kısıtları', () {
    test('viewer kayıt giremez, diğerleri girer; rol bilinmiyorsa girer', () {
      expect(canWriteRecords(MembershipRole.viewer), isFalse);
      for (final role in [
        MembershipRole.owner,
        MembershipRole.partner,
        MembershipRole.worker,
        null,
      ]) {
        expect(canWriteRecords(role), isTrue, reason: '$role');
      }
    });

    test('finansı yalnız owner ve partner görür', () {
      expect(canSeeFinance(MembershipRole.owner), isTrue);
      expect(canSeeFinance(MembershipRole.partner), isTrue);
      expect(canSeeFinance(MembershipRole.worker), isFalse);
      expect(canSeeFinance(MembershipRole.viewer), isFalse);
      expect(canSeeFinance(null), isTrue);
    });

    test('owner ve partner davet eder, yalnız owner üyeleri yönetir', () {
      expect(canInvite(MembershipRole.owner), isTrue);
      expect(canInvite(MembershipRole.partner), isTrue);
      expect(canInvite(MembershipRole.worker), isFalse);
      expect(canInvite(MembershipRole.viewer), isFalse);
      expect(canManageMembers(MembershipRole.owner), isTrue);
      expect(canManageMembers(MembershipRole.partner), isFalse);
    });

    test('owner davetle verilmez', () {
      expect(invitableRoles, isNot(contains(MembershipRole.owner)));
    });
  });
}
