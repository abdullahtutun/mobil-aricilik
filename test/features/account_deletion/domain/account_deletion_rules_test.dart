import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion_rules.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

Member _member(String userId, MembershipRole role) =>
    (userId: userId, role: role);

MemberProfile _profile(String userId, MembershipRole role) => (
  membershipId: 'm-$userId',
  userId: userId,
  role: role,
  fullName: null,
  deletionScheduledFor: null,
);

void main() {
  group('deletionScenarioOf', () {
    test('tek kişilik işletmenin sahibi', () {
      expect(
        deletionScenarioOf(
          userId: 'me',
          members: [_member('me', MembershipRole.owner)],
        ),
        DeletionScenario.soloOwner,
      );
    });

    test('ekipli işletmenin sahibi', () {
      expect(
        deletionScenarioOf(
          userId: 'me',
          members: [
            _member('me', MembershipRole.owner),
            _member('w', MembershipRole.worker),
          ],
        ),
        DeletionScenario.ownerWithTeam,
      );
    });

    test('ortak, işçi ve danışman üyedir', () {
      for (final role in [
        MembershipRole.partner,
        MembershipRole.worker,
        MembershipRole.viewer,
      ]) {
        expect(
          deletionScenarioOf(
            userId: 'me',
            members: [_member('o', MembershipRole.owner), _member('me', role)],
          ),
          DeletionScenario.member,
          reason: role.name,
        );
      }
    });

    test('üyelik inmediyse ya da oturum yoksa bilinmiyor', () {
      expect(
        deletionScenarioOf(
          userId: 'me',
          members: [_member('o', MembershipRole.owner)],
        ),
        DeletionScenario.unknown,
      );
      expect(
        deletionScenarioOf(userId: null, members: const []),
        DeletionScenario.unknown,
      );
    });
  });

  test('sahiplik yalnız ortaklara devredilir; kendisi listede yok', () {
    final candidates = transferCandidates([
      _profile('me', MembershipRole.owner),
      _profile('p1', MembershipRole.partner),
      _profile('w', MembershipRole.worker),
      _profile('v', MembershipRole.viewer),
      _profile('p2', MembershipRole.partner),
    ], userId: 'me');
    expect([for (final m in candidates) m.userId], ['p1', 'p2']);
  });

  test('işletme tek kişilikte ya da silme seçilince silinir', () {
    expect(deletesOrganization(DeletionScenario.soloOwner, null), isTrue);
    expect(
      deletesOrganization(
        DeletionScenario.ownerWithTeam,
        OwnerDeletionChoice.deleteOrganization,
      ),
      isTrue,
    );
    expect(
      deletesOrganization(
        DeletionScenario.ownerWithTeam,
        OwnerDeletionChoice.transfer,
      ),
      isFalse,
    );
    expect(deletesOrganization(DeletionScenario.member, null), isFalse);
  });

  test('ilk adımdan çıkış şartları', () {
    bool can(DeletionScenario s, [OwnerDeletionChoice? c, String? to]) =>
        canLeaveOverview(scenario: s, choice: c, transferTo: to);

    expect(can(DeletionScenario.soloOwner), isTrue);
    expect(can(DeletionScenario.member), isTrue);
    expect(can(DeletionScenario.unknown), isFalse);
    expect(can(DeletionScenario.ownerWithTeam), isFalse);
    expect(
      can(DeletionScenario.ownerWithTeam, OwnerDeletionChoice.transfer),
      isFalse,
    );
    expect(
      can(DeletionScenario.ownerWithTeam, OwnerDeletionChoice.transfer, 'p'),
      isTrue,
    );
    expect(
      can(
        DeletionScenario.ownerWithTeam,
        OwnerDeletionChoice.deleteOrganization,
      ),
      isTrue,
    );
  });

  group('confirmationMatches', () {
    final tr = const AppFormat('tr').upperCase;
    final en = const AppFormat('en').upperCase;

    test('Türkçe büyük/küçük harf ve boşluk farkı yok sayılır', () {
      expect(confirmationMatches('sil', 'SİL', upperCase: tr), isTrue);
      expect(confirmationMatches(' SİL ', 'SİL', upperCase: tr), isTrue);
      expect(
        confirmationMatches(
          'yılmaz  arıcılık',
          'Yılmaz Arıcılık',
          upperCase: tr,
        ),
        isTrue,
      );
    });

    test('yanlış yazılan metin eşleşmez', () {
      expect(confirmationMatches('SIL', 'SİL', upperCase: tr), isFalse);
      expect(confirmationMatches('SİLL', 'SİL', upperCase: tr), isFalse);
      expect(confirmationMatches('', 'SİL', upperCase: tr), isFalse);
      expect(
        confirmationMatches('Yılmaz', 'Yılmaz Arıcılık', upperCase: tr),
        isFalse,
      );
    });

    test('beklenen boşsa hiçbir şey eşleşmez', () {
      expect(confirmationMatches('', '', upperCase: tr), isFalse);
      expect(confirmationMatches(' ', ' ', upperCase: tr), isFalse);
    });

    test('İngilizce anahtar kelime', () {
      expect(confirmationMatches('delete', 'DELETE', upperCase: en), isTrue);
      expect(confirmationMatches('delet', 'DELETE', upperCase: en), isFalse);
    });
  });
}
